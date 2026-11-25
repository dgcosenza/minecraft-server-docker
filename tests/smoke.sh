#!/usr/bin/env bash
set -euo pipefail

IMAGE="${1:?Usage: $0 <image-ref>}"
CID=""
TMP_DIR=""

cleanup() {
  if [ -n "$CID" ]; then
    docker rm -f "$CID" >/dev/null 2>&1 || true
  fi
  if [ -n "$TMP_DIR" ] && [ -d "$TMP_DIR" ]; then
    rm -rf "$TMP_DIR" || true
  fi
}
trap cleanup EXIT

echo "==> [1/7] Verify zero Mojang server JARs are bundled in image (EULA compliance)"
BUNDLED="$(docker run --rm --entrypoint sh "$IMAGE" -c "find / -xdev -name 'minecraft_server*.jar' 2>/dev/null || true")"
if [ -n "$BUNDLED" ]; then
  echo "FAIL: Mojang server JAR found inside image: $BUNDLED" >&2
  exit 1
fi
echo "PASS: Zero Mojang server JARs baked into image."

echo "==> [2/7] Verify default non-root user (UID/GID 1000) and core binaries"
UID_GID="$(docker run --rm --entrypoint sh "$IMAGE" -c 'printf "%s:%s:%s" "$(id -u)" "$(id -g)" "$(id -un)"')"
test "$UID_GID" = "1000:1000:minecraft" || { echo "FAIL: unexpected user $UID_GID" >&2; exit 1; }
docker run --rm --entrypoint sh "$IMAGE" -c '
  java -version 2>&1 | grep -q "Temurin-25"
  tini --version
  test "$(mc-image-helper java-release)" = "25"
  mc-monitor --help >/dev/null
  mc-server-runner --help >/dev/null
  rcon-cli --help >/dev/null
  restify --help >/dev/null
  test -x /usr/local/bin/gosu
'
echo "PASS: Default non-root user 1000:1000 and all helper binaries verified."

echo "==> [3/7] Verify EULA refusal negative check"
EULA_OUT="$(docker run --rm "$IMAGE" 2>&1 || true)"
printf '%s\n' "$EULA_OUT" | grep -qi "EULA" || { echo "FAIL: missing EULA error message" >&2; exit 1; }
echo "PASS: Container refuses to start without EULA=TRUE."

echo "==> [4/7] Start hardened rootless + read-only container with EULA=TRUE"
TMP_DIR="$(mktemp -d)"
chmod 0777 "$TMP_DIR"
RCON_PW="$(openssl rand -hex 12)"

CID="$(docker run -d \
  --read-only \
  --tmpfs /tmp:rw,noexec,nosuid,size=128m \
  --cap-drop ALL \
  --security-opt no-new-privileges:true \
  -e EULA=TRUE \
  -e TYPE=VANILLA \
  -e VERSION=LATEST \
  -e MEMORY=1G \
  -e JVM_OPTS="--enable-native-access=ALL-UNNAMED" \
  -e RCON_PASSWORD="$RCON_PW" \
  -e MOTD="Smoke Test Server" \
  -e ONLINE_MODE=FALSE \
  -e SPAWN_PROTECTION=0 \
  -e VIEW_DISTANCE=4 \
  -e SIMULATION_DISTANCE=4 \
  -e LEVEL_TYPE="minecraft:flat" \
  -v "${TMP_DIR}:/data" \
  "$IMAGE")"

echo "==> [5/7] Wait for runtime download + server startup + healthy status (timeout 240s)"
HEALTH=""
for i in $(seq 1 48); do
  STATUS="$(docker inspect --format='{{.State.Status}}' "$CID")"
  if [ "$STATUS" != "running" ]; then
    echo "FAIL: container stopped unexpectedly (status=$STATUS)" >&2
    docker logs "$CID" | tail -n 80 >&2 || true
    exit 1
  fi
  HEALTH="$(docker inspect --format='{{.State.Health.Status}}' "$CID")"
  if [ "$HEALTH" = "healthy" ]; then
    echo "Container healthy after $((i * 5))s."
    break
  fi
  sleep 5
done

if [ "$HEALTH" != "healthy" ]; then
  echo "FAIL: container did not reach healthy state (last=$HEALTH)" >&2
  docker logs "$CID" | tail -n 100 >&2 || true
  exit 1
fi

echo "==> [6/7] Functional probes: mc-health, non-root processes, rcon-cli, negative healthcheck"
HEALTH_OUT="$(docker exec "$CID" mc-health)"
echo "mc-health output: $HEALTH_OUT"
printf '%s\n' "$HEALTH_OUT" | grep -q "Smoke Test Server" || { echo "FAIL: MOTD mismatch" >&2; exit 1; }

PROCS="$(docker exec "$CID" ps -eo uid=,comm=)"
echo "Running processes:"
printf '%s\n' "$PROCS"
if printf '%s\n' "$PROCS" | awk '$1 == 0 { found=1 } END { exit !found }'; then
  echo "FAIL: found process running as UID 0!" >&2
  exit 1
fi
printf '%s\n' "$PROCS" | grep -q "java" || { echo "FAIL: java process not running" >&2; exit 1; }
printf '%s\n' "$PROCS" | grep -q "mc-server-runne" || { echo "FAIL: mc-server-runner not running" >&2; exit 1; }

RCON_OUT="$(docker exec "$CID" rcon-cli list)"
echo "rcon-cli list output: $RCON_OUT"
printf '%s\n' "$RCON_OUT" | grep -qi "players online" || { echo "FAIL: rcon-cli did not answer expected list output" >&2; exit 1; }

if docker exec -e SERVER_PORT=25599 "$CID" mc-health >/dev/null 2>&1; then
  echo "FAIL: negative healthcheck against closed port unexpectedly succeeded!" >&2
  exit 1
fi
echo "PASS: Negative healthcheck failed as expected on unreachable port."

echo "==> [7/7] Verify graceful SIGTERM world save and clean exit"
docker stop -t 45 "$CID" >/dev/null
EXIT_CODE="$(docker inspect --format='{{.State.ExitCode}}' "$CID")"
echo "Stopped container exit code: $EXIT_CODE"
docker logs "$CID" | tail -n 20
test "$EXIT_CODE" = "0" || test "$EXIT_CODE" = "143" || { echo "FAIL: unexpected exit code $EXIT_CODE" >&2; exit 1; }
echo "ALL SMOKE TESTS PASSED."
