# Minecraft Server on Debian 13 (trixie) + Eclipse Temurin 25 JRE

[![Daily CI](https://github.com/dgcosenza/minecraft-server-docker/actions/workflows/daily.yml/badge.svg)](https://github.com/dgcosenza/minecraft-server-docker/actions/workflows/daily.yml)
[![OpenSSF Scorecard Workflow](https://github.com/dgcosenza/minecraft-server-docker/actions/workflows/scorecard.yml/badge.svg)](https://github.com/dgcosenza/minecraft-server-docker/actions/workflows/scorecard.yml)
[![Gitleaks Secret Scan](https://github.com/dgcosenza/minecraft-server-docker/actions/workflows/gitleaks.yml/badge.svg)](https://github.com/dgcosenza/minecraft-server-docker/actions/workflows/gitleaks.yml)
[![Public Content Check](https://github.com/dgcosenza/minecraft-server-docker/actions/workflows/public-check.yml/badge.svg)](https://github.com/dgcosenza/minecraft-server-docker/actions/workflows/public-check.yml)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/dgcosenza/minecraft-server-docker/badge)](https://scorecard.dev/viewer/?uri=github.com/dgcosenza/minecraft-server-docker)
[![OpenSSF Best Practices](https://www.bestpractices.dev/projects/17162/badge)](https://www.bestpractices.dev/projects/17162)

[![Trivy + Grype: 0 Fixable CVEs](https://img.shields.io/badge/Trivy%20%2B%20Grype-0%20fixable%20CVEs-brightgreen?logo=trivy&logoColor=white)](https://github.com/dgcosenza/minecraft-server-docker/security/code-scanning)
[![Signed: Cosign OIDC](https://img.shields.io/badge/signed-Cosign%20OIDC-blueviolet)](https://github.com/dgcosenza/minecraft-server-docker#supply-chain-verification)
[![SLSA Build L3](https://img.shields.io/badge/SLSA-Build%20L3-brightgreen)](https://github.com/dgcosenza/minecraft-server-docker/attestations)
[![SBOM: SPDX + CycloneDX](https://img.shields.io/badge/SBOM-SPDX%20%2B%20CycloneDX-0A7BBB?logo=spdx&logoColor=white)](https://github.com/dgcosenza/minecraft-server-docker/releases/latest)
[![Base OS](https://img.shields.io/badge/base-Debian%2013%20(trixie--slim)-A81D33?logo=debian&logoColor=white)](https://github.com/dgcosenza/minecraft-server-docker/blob/main/Dockerfile)
[![Architectures](https://img.shields.io/badge/arch-amd64%20%7C%20arm64-007ec6?logo=linux&logoColor=white)](https://github.com/dgcosenza/minecraft-server-docker#supported-architectures)
[![Healthcheck: CI Verified](https://img.shields.io/badge/healthcheck-CI%20verified-brightgreen?logo=docker&logoColor=white)](https://github.com/dgcosenza/minecraft-server-docker#healthcheck)
[![Renovate Enabled](https://img.shields.io/badge/renovate-enabled-1A1F6C?logo=renovate&logoColor=white)](https://github.com/dgcosenza/minecraft-server-docker/blob/main/renovate.json)
[![Dependabot Enabled](https://img.shields.io/badge/dependabot-enabled-025E8C?logo=dependabot&logoColor=white)](https://github.com/dgcosenza/minecraft-server-docker/blob/main/.github/dependabot.yml)
[![Daily Rebuilds](https://img.shields.io/badge/rebuilds-daily-2088FF?logo=githubactions&logoColor=white)](https://github.com/dgcosenza/minecraft-server-docker/actions/workflows/daily.yml)

[![Latest Release](https://img.shields.io/github/v/release/dgcosenza/minecraft-server-docker?label=version&logo=github)](https://github.com/dgcosenza/minecraft-server-docker/releases/latest)
[![Release Date](https://img.shields.io/github/release-date/dgcosenza/minecraft-server-docker?label=released&logo=github)](https://github.com/dgcosenza/minecraft-server-docker/releases/latest)
[![Last Commit](https://img.shields.io/github/last-commit/dgcosenza/minecraft-server-docker?logo=github)](https://github.com/dgcosenza/minecraft-server-docker/commits/main)
[![Docker Pulls](https://img.shields.io/docker/pulls/dgcosenza/minecraft-server?logo=docker&logoColor=white)](https://hub.docker.com/r/dgcosenza/minecraft-server)
[![Docker Image Size](https://img.shields.io/docker/image-size/dgcosenza/minecraft-server/latest?logo=docker&logoColor=white)](https://hub.docker.com/r/dgcosenza/minecraft-server)
[![Registries: Docker Hub + GHCR](https://img.shields.io/badge/registries-Docker%20Hub%20%2B%20GHCR-2496ED?logo=docker&logoColor=white)](https://github.com/dgcosenza/minecraft-server-docker/pkgs/container/minecraft-server)
[![Packaging License: MIT](https://img.shields.io/badge/packaging-MIT-blue?logo=opensourceinitiative&logoColor=white)](https://github.com/dgcosenza/minecraft-server-docker/blob/main/LICENSE)
[![Upstream License](https://img.shields.io/badge/upstream-Apache--2.0-green?logo=opensourceinitiative&logoColor=white)](https://github.com/itzg/docker-minecraft-server/blob/master/LICENSE)
[![GitHub Issues](https://img.shields.io/github/issues/dgcosenza/minecraft-server-docker?logo=github)](https://github.com/dgcosenza/minecraft-server-docker/issues)
[![FNX Labs Catalog](https://img.shields.io/badge/catalog-FNX%20Labs-0b1020?logo=githubpages&logoColor=white)](https://dgcosenza.github.io/)

A hardened, rootless-by-default, multi-arch **Debian 13 (`trixie-slim`) + Eclipse Temurin 25 JRE** container image for **Minecraft Java Edition Server**, built with source-compiled `itzg` helper binaries and security-patched `mc-image-helper`, drop-in compatible with `itzg/minecraft-server`, maintained by **Daniel G. Cosenza from FNX Labs**.

- **Docker Hub:** [`dgcosenza/minecraft-server`](https://hub.docker.com/r/dgcosenza/minecraft-server)
- **GitHub Container Registry (GHCR):** [`ghcr.io/dgcosenza/minecraft-server`](https://github.com/dgcosenza/minecraft-server-docker/pkgs/container/minecraft-server) (identical signed multi-arch digest)
- **Source Repository:** [`dgcosenza/minecraft-server-docker`](https://github.com/dgcosenza/minecraft-server-docker)
- **Upstream Orchestration Scripts:** [`itzg/docker-minecraft-server`](https://github.com/itzg/docker-minecraft-server) (`Apache-2.0`)

> **EULA & Redistribution Notice:** This image **never** bundles any proprietary Mojang / Minecraft server JARs (explicitly asserted in CI on every build). Consistent with upstream `itzg/minecraft-server`, end users must explicitly accept the [Minecraft End User License Agreement](https://www.minecraft.net/en-us/eula) by setting `-e EULA=TRUE`, after which the official server binary is downloaded directly at container startup.

---

## Current Versions

<!-- versions:start -->
| Component | Resolved Version |
| --- | --- |
| Base OS | `Debian 13.8 (trixie-slim)` |
| Java Runtime | `Eclipse Temurin jdk-25.0.5.1+2 (JRE)` |
| itzg/docker-minecraft-server | `2026.11.1` |
| itzg/mc-image-helper | `1.80.0 (source-built, patched deps)` |
| itzg/mc-monitor | `1.21.1 (source-built)` |
| itzg/mc-server-runner | `1.18.0 (source-built)` |
| itzg/rcon-cli | `1.10.0 (source-built)` |
| itzg/restify | `1.7.22 (source-built)` |
| Architectures | `linux/amd64, linux/arm64` |
| Uncompressed size (per arch) | `amd64: 207.6 MB, arm64: 541.1 MB` |
| Last verified build (UTC) | `2026-11-27` |
| Published multi-arch digest | `dgcosenza/minecraft-server@sha256:e104db16d7ccd7e58e67455485d15e2421d762a44ce969652f7a2599f9a13cd6` |
| GHCR mirror | `ghcr.io/dgcosenza/minecraft-server@sha256:e104db16d7ccd7e58e67455485d15e2421d762a44ce969652f7a2599f9a13cd6` |
| Supply chain | Cosign OIDC signed + SPDX & CycloneDX SBOM attestations + SLSA Build L3 provenance |
| Security gate (Trivy + Grype on SBOM) | **0 fixable findings of any severity** (22 upstream-unfixed) |

**Recent upstream changes:**
- **itzg/docker-minecraft-server:** `2026.11.1` -> `2026.11.1` (commit `0699bd8497cb`)
- **Upstream version changed:** `no`
- **Eclipse Temurin 25 JRE:** `jdk-25.0.5.1+2` (amd64 & arm64 verified via Adoptium API)
- **Source-built helpers:** `mc-image-helper 1.80.0`, `mc-monitor 1.21.1`, `mc-server-runner 1.18.0`, `rcon-cli 1.10.0`, `restify 1.7.22`
- **Java security overrides:** `micrometer-core 1.16.9`, `bcprov-jdk18on 1.87`, `scala-library 2.13.18`, `tools.jackson.core 3.1.9`, `logback 1.5.38`, `classgraph 4.8.200`, `kotli...
<!-- versions:end -->

---

## Supported Tags & Tag Policy

Identical multi-arch OCI digests are published to **Docker Hub** (`dgcosenza/minecraft-server`) and **GHCR** (`ghcr.io/dgcosenza/minecraft-server`), accompanied by an automated signed [GitHub Release](https://github.com/dgcosenza/minecraft-server-docker/releases):

| Tag | Policy | Description |
| --- | --- | --- |
| `<upstream-version>-<YYYYMMDD>` (e.g. `2026.11.1-20261125`) | **Immutable** | Date-stamped daily build pinned to that upstream release and base refresh. |
| `sha-<short>` | **Immutable** | Packaging repository Git commit tag. |
| `<upstream-version>` (e.g. `2026.11.1`) | Moving | Latest verified daily build for that upstream `itzg/docker-minecraft-server` release. |
| `latest` | Moving | Latest verified daily Debian 13 + Temurin 25 JRE build. |

**Production pinning:** Pin by immutable registry digest rather than an unpinned moving tag:

```yaml
image: dgcosenza/minecraft-server:latest@sha256:<digest>
# or via GitHub Container Registry (identical digest):
image: ghcr.io/dgcosenza/minecraft-server:latest@sha256:<digest>
```

---

## Supported Architectures

| Architecture | Status | Verification |
| --- | --- | --- |
| `linux/amd64` | **Published & natively tested** | Built with native x86_64 Go, Gradle, and Temurin 25 JRE (`x64`), end-to-end smoke-tested (`read_only` + `cap_drop ALL` + runtime Vanilla download + `mc-health` + `rcon-cli` + graceful `SIGTERM`), Dive-gated, Syft/Trivy/Grype-scanned, and Cosign-signed. |
| `linux/arm64` | **Published & natively tested** | Built with native ARM64 Go, Gradle, and Temurin 25 JRE (`aarch64`), end-to-end smoke-tested (`read_only` + `cap_drop ALL` + runtime Vanilla download + `mc-health` + `rcon-cli` + graceful `SIGTERM`), Dive-gated, Syft/Trivy/Grype-scanned, and Cosign-signed. |

---

## Quick Start

### Docker CLI (Hardened Rootless + Read-Only Rootfs)

Ensure your host `./data` directory is owned by UID/GID `1000:1000`:

```bash
mkdir -p ./data && chown 1000:1000 ./data
docker run -d --name minecraft-server \
  --user 1000:1000 \
  --read-only \
  --tmpfs /tmp:rw,noexec,nosuid,size=128m \
  --cap-drop ALL \
  --security-opt no-new-privileges:true \
  -p 25565:25565 \
  -e EULA=TRUE \
  -e TYPE=VANILLA \
  -e VERSION=LATEST \
  -e MEMORY=2G \
  -e JVM_OPTS="--enable-native-access=ALL-UNNAMED" \
  -e RCON_PASSWORD="${RCON_PASSWORD}" \
  -v ./data:/data \
  dgcosenza/minecraft-server:latest
```

### Hardened Docker Compose

See [`docker-compose.example.yml`](https://github.com/dgcosenza/minecraft-server-docker/blob/main/docker-compose.example.yml):

```yaml
services:
  mc:
    image: dgcosenza/minecraft-server:latest
    container_name: minecraft-server
    restart: unless-stopped
    user: "1000:1000"
    read_only: true
    tmpfs:
      - /tmp:rw,noexec,nosuid,size=128m
    cap_drop:
      - ALL
    security_opt:
      - no-new-privileges:true
    tty: true
    stdin_open: true
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
      TYPE: "VANILLA"
      VERSION: "LATEST"
      MEMORY: "2G"
      JVM_OPTS: "--enable-native-access=ALL-UNNAMED"
      RCON_PASSWORD: "${RCON_PASSWORD}"
      TZ: "UTC"
    volumes:
      - ./data:/data
    healthcheck:
      test: ["CMD-SHELL", "mc-health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 2m
```

---

## Configuration

This image includes the full upstream `itzg/docker-minecraft-server` startup script suite and source-built `mc-image-helper`, preserving drop-in compatibility with standard environment variables.

### Key Environment Variables

| Variable | Description | Default |
| --- | --- | --- |
| `EULA` | Must be set to `TRUE` to accept the Minecraft EULA and allow runtime server download | `""` (required) |
| `TYPE` | Server type (`VANILLA`, `PAPER`, `FABRIC`, `FORGE`, `NEOFORGE`, `PURPUR`, `SPIGOT`, `MODRINTH`, `CURSEFORGE`, etc.) | `VANILLA` |
| `VERSION` | Minecraft version (`LATEST`, `SNAPSHOT`, or explicit version such as `1.21.11` / `26.3`) | `LATEST` |
| `MEMORY` / `INIT_MEMORY` / `MAX_MEMORY` | JVM heap size (supports absolute values like `2G` or percentages) | `1G` |
| `JVM_OPTS` / `JVM_XX_OPTS` / `JVM_DD_OPTS` | Additional JVM flags (e.g. `--enable-native-access=ALL-UNNAMED`) | `""` |
| `ENABLE_RCON` / `RCON_PORT` / `RCON_PASSWORD` / `RCON_PASSWORD_FILE` | Built-in RCON administration settings (`rcon-cli` reads `/data/.rcon-cli.yaml` automatically) | `true` / `25575` / random |
| `MOTD` / `DIFFICULTY` / `MODE` / `MAX_PLAYERS` / `ONLINE_MODE` / `WHITELIST` / `OPS` | Standard `server.properties` and access-control settings | Upstream defaults |
| `UID` / `GID` | Target UID/GID (used when explicitly started as root `--user 0` for volume remapping) | `1000` / `1000` |
| `STOP_DURATION` | Graceful shutdown wait window before `mc-server-runner` terminates Java | `60` |
| `TZ` | Container timezone | `UTC` |

### Volumes, Ports, and Privileges

| Path / Port | Purpose |
| --- | --- |
| `/data` | Persistent world data, `server.properties`, downloaded server JAR, logs, whitelist, and ops (owned by `1000:1000`) |
| `25565/tcp` | Minecraft Java Edition server port |
| `25575/tcp` | Optional RCON port (keep internal; never expose publicly) |

- **Default user:** Runs rootless by default as **`minecraft` (`UID=1000`, `GID=1000`)** under `/usr/bin/tini` PID 1 and `mc-server-runner`.
- **Custom UID/GID remapping:** If your host `/data` directory uses a UID/GID other than `1000:1000`, either `chown` the host directory to match `--user <uid>:<gid>` (recommended, stays rootless) or start with `--user 0` and `-e UID=<uid> -e GID=<gid>`, in which case `/image/scripts/start` adjusts ownership and immediately drops privileges via our zero-Go `setpriv`-based `/usr/local/bin/gosu` wrapper.

---

## Healthcheck

```bash
mc-health
```

Built into the image (`--start-period=2m --interval=30s --timeout=10s --retries=3`), invoking source-built `mc-monitor status` against `localhost:25565` (or `SERVER_HOST`/`SERVER_PORT`) and verifying a valid Minecraft server list ping response.

---

## Upgrade and Migration from `itzg/minecraft-server`

1. Confirm no players are online (`docker exec minecraft-server mc-health`) and back up your `/data` directory (especially `/data/world`, `server.properties`, `ops.json`, and `whitelist.json`) before switching.
2. Verify `/data` on the host is owned by `1000:1000` (matching default `UID=1000`/`GID=1000`). If it uses a different UID/GID, pass matching `--user` or `--user 0` with `UID`/`GID`.
3. Keep your existing environment variables (`EULA`, `TYPE`, `VERSION`, `JVM_OPTS`, `RCON_PASSWORD`, etc.), volume mount (`./data:/data`), and port (`25565:25565`) unchanged.
4. Tag the previous image locally for rollback, replace `image:` with a digest-pinned `dgcosenza/minecraft-server:latest@sha256:<digest>` (or GHCR), and recreate the container with `docker compose up -d`.

---

## Supply-Chain Verification

Every published digest (multi-arch index and per-architecture manifests) on both Docker Hub and GHCR is keyless-signed with **Sigstore Cosign** (GitHub OIDC), attested with **SPDX** and **CycloneDX** SBOMs, and backed by **SLSA Build L3** provenance (`actions/attest-build-provenance`).

### Verify image signature with Cosign

```bash
cosign verify \
  --certificate-identity-regexp="^https://github\.com/dgcosenza/minecraft-server-docker/\.github/workflows/daily\.yml@refs/heads/main$" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com" \
  ghcr.io/dgcosenza/minecraft-server:latest

# Or against Docker Hub (identical digest):
cosign verify \
  --certificate-identity-regexp="^https://github\.com/dgcosenza/minecraft-server-docker/\.github/workflows/daily\.yml@refs/heads/main$" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com" \
  dgcosenza/minecraft-server:latest
```

### Verify SPDX / CycloneDX SBOM attestations

```bash
cosign verify-attestation \
  --type spdxjson \
  --certificate-identity-regexp="^https://github\.com/dgcosenza/minecraft-server-docker/\.github/workflows/daily\.yml@refs/heads/main$" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com" \
  ghcr.io/dgcosenza/minecraft-server@sha256:<arch-digest>
```

### Verify SLSA Build Provenance

```bash
gh attestation verify oci://ghcr.io/dgcosenza/minecraft-server:latest --owner dgcosenza
```

---

## Security

- **Preflight gates:** Every push and pull request runs **Hadolint** (blocking on warning+), **Gitleaks** secret scanning across full git history, and **public-content/attribution** checks.
- **Vulnerability scan policy (all severities with a fix):** Every build generates **SPDX** and **CycloneDX** SBOMs with **Syft** per architecture, scans with **Trivy** (table, JSON, SARIF upload, blocking `--ignore-unfixed` gate) and **Grype** scanning the SPDX SBOM (`--only-fixed --fail-on negligible`), and enforces a **Dive** efficiency gate (`lowestEfficiency: 0.95`, `highestUserWastedPercent: 0.05`).
- **Source-remediated helpers:** All `itzg` Go utilities (`mc-monitor`, `mc-server-runner`, `rcon-cli`, `restify`) are compiled from official tags with the current patched Go toolchain and updated `golang.org/x/*` packages; `mc-image-helper` is compiled from source with patched transitive Java dependencies; prebuilt `tianon/gosu` is replaced by a zero-Go `setpriv` wrapper.
- **Rootless & read-only ready:** Runs as unprivileged `minecraft` (`1000:1000`) by default and is smoke-tested in CI with `--read-only`, `--cap-drop ALL`, and `--security-opt no-new-privileges:true`.
- **Dependency automation:** Renovate (`renovate.json`) pins base image digests and GitHub Action commit SHAs; Dependabot security alerts and OpenSSF Scorecard monitoring are enabled.
- See [`SECURITY.md`](https://github.com/dgcosenza/minecraft-server-docker/blob/main/SECURITY.md) for responsible disclosure.

---

## Build Locally

```bash
docker buildx build --platform linux/amd64 --load -t dgcosenza/minecraft-server:local .
```

---

## Update Policy

[`.github/workflows/daily.yml`](https://github.com/dgcosenza/minecraft-server-docker/blob/main/.github/workflows/daily.yml) runs automatically every day at **05:23 UTC**, on pushes to `main`, on pull requests (verification only), and via `workflow_dispatch`:

1. **Preflight & upstream check:** Runs public-content checks, **Hadolint**, and **Gitleaks**; resolves the latest official releases of `itzg/docker-minecraft-server`, `itzg/mc-image-helper`, `itzg/mc-monitor`, `itzg/mc-server-runner`, `itzg/rcon-cli`, and `itzg/restify` via the authenticated GitHub API (`GH_TOKEN`), resolves the latest Eclipse Temurin 25 JRE (`x64` + `aarch64`) checksums from Adoptium, resolves patched Maven dependency versions and current Debian/Go/JDK base digests, and emits `upstream-changes.md`.
2. **Multi-arch no-cache rebuild:** Rebuilds natively on `linux/amd64` and `linux/arm64` runners with `--no-cache` on schedule, upgrading Debian 13 packages and recompiling Go and Java helpers from source.
3. **Vulnerability fix & hard gate:** Generates per-arch **Syft** SPDX + CycloneDX SBOMs, diffs against `versions.json`, uploads **Trivy** SARIF, and blocks publication on any fixable finding of any severity in **Trivy** or **Grype** (scanning the SPDX SBOM), alongside the **Dive** efficiency gate.
4. **Native smoke tests:** Runs [`tests/smoke.sh`](https://github.com/dgcosenza/minecraft-server-docker/blob/main/tests/smoke.sh) natively on both architectures, asserting zero baked Mojang JARs, non-root `1000:1000` execution, EULA refusal check, read-only + `cap_drop ALL` live startup, `mc-health`, `rcon-cli`, negative healthcheck failure, and clean `SIGTERM` world save.
5. **Dual-registry publish & signing:** Assembles the multi-arch OCI manifest index on **GHCR** and mirrors the identical digest to **Docker Hub** with tags `latest`, `<upstream-version>`, `<upstream-version>-<YYYYMMDD>`, and `sha-<short>`; signs every digest and attaches SPDX/CycloneDX SBOM attestations via **Cosign** keyless OIDC; emits **SLSA Build L3** provenance; and publishes a signed **GitHub Release** with checksums and SBOMs.
6. **Automated documentation sync:** Commits updated `versions.json`, the README `Current Versions` block, and a dated `CHANGELOG.md` entry via `github-actions[bot]` (`[skip ci]`, validated by `public-check.sh`), then syncs the Docker Hub overview and short description.
7. **Failure alerting:** Opens or updates a single GitHub issue labeled `ci-failure` on any `main` or scheduled failure, and auto-closes it on the next green run.

---

## Design Decisions

- **Debian 13 (`trixie-slim`) + SHA-256 verified Adoptium Temurin 25 JRE:** Replaces upstream's Ubuntu base with minimal, daily-patched Debian 13 while preserving exact Eclipse Temurin 25 LTS JVM behavior and performance.
- **Source-compiled Go & Java helpers instead of prebuilt release archives:** Eliminates stale Go stdlib/module CVEs in `gosu`, `mc-monitor`, and `rcon-cli` as well as transitive Java CVEs (`micrometer-core`, `bcprov-jdk18on`, `scala-library`, `tools.jackson.core`, `logback`, `classgraph`, `kotlin-stdlib`) in `mc-image-helper`.
- **Zero-Go `setpriv` shim at `/usr/local/bin/gosu`:** Removes the 26-CVE prebuilt `gosu` Go binary permanently while remaining compatible with `no-new-privileges:true` when `--user 0` UID/GID remapping is explicitly requested.
- **Lean runtime package set:** Omits heavy/optional upstream utilities not required by standard Minecraft servers (`imagemagick`, `mysql-client`, `nfs-common`, `git-lfs`, `sudo`, and the unsigned third-party `Metalcape/knock` binary) to keep the image compact and minimize vulnerability surface. Users requiring automatic non-PNG server icon conversion can provide a pre-sized `64x64` PNG `server-icon.png` directly in `/data`.
- **`tini` PID 1 + `mc-server-runner`:** Ensures clean zombie reaping and reliable `SIGTERM` forwarding to `mc-server-runner`, which issues `stop` to save chunks cleanly before exit.
- **Hadolint `DL3008` ignore:** Daily `--no-cache` security rebuilds intentionally pull the newest Debian 13 security updates via `apt-get`.

---

## License

This repository follows a clear packaging-vs-upstream license split:

- **Container packaging, Gradle security overrides, privilege-drop shim, CI workflows, and documentation (`packaging: MIT`):** Licensed under the [MIT License](https://github.com/dgcosenza/minecraft-server-docker/blob/main/LICENSE) — copyright **Daniel G. Cosenza from FNX Labs**.
- **Upstream orchestration scripts and helper tools (`upstream: Apache-2.0`):** Incorporates [`itzg/docker-minecraft-server`](https://github.com/itzg/docker-minecraft-server/blob/master/LICENSE), `itzg/mc-server-runner`, `itzg/rcon-cli`, and `itzg/restify` under the **Apache License 2.0**, alongside `itzg/mc-image-helper`, `itzg/mc-monitor`, and `CreeperHost/Log4jPatcher` under the **MIT License**, and **Eclipse Temurin 25 JRE** under **GPL-2.0 with Classpath Exception**.
- **Minecraft Java Edition Server (runtime-fetched, NOT bundled):** Proprietary software of Mojang AB / Microsoft Corporation governed by the [Minecraft EULA](https://www.minecraft.net/en-us/eula). No Mojang server binaries are included or redistributed in this image.

Full third-party notices are maintained in [`THIRD-PARTY-NOTICES.md`](https://github.com/dgcosenza/minecraft-server-docker/blob/main/THIRD-PARTY-NOTICES.md). Release history is maintained in [`CHANGELOG.md`](https://github.com/dgcosenza/minecraft-server-docker/blob/main/CHANGELOG.md).

## Credits

- [Geoff Bourne (itzg) and contributors](https://github.com/itzg/docker-minecraft-server)
- [Eclipse Adoptium (Temurin)](https://adoptium.net/)
- [Debian Project](https://www.debian.org/)

Maintained by **Daniel G. Cosenza from FNX Labs**.
