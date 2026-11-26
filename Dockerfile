# syntax=docker/dockerfile:1

ARG DEBIAN_BASE=debian:trixie-slim@sha256:8aa5a7bf5a1955bddbe7d74fcdd0b91ab30e74362a8b73af672b0481b35b44a0
ARG GOLANG_IMAGE=golang:1.27-trixie@sha256:430985542100b871e108ccc00e8dcc5eef08ca14ee5825e98ebf563d8ffec4ee
ARG JDK_BUILDER_IMAGE=eclipse-temurin:21-jdk@sha256:8ad118b146aa92da815b576441acd6b42b38236797ad0b6edc8c200b85bb0734

# ---- Stage 1: compile itzg Go helper tools from official tags with patched Go & x/* ----
FROM ${GOLANG_IMAGE} AS go-builder

ARG MC_MONITOR_VERSION=1.21.0
ARG MC_SERVER_RUNNER_VERSION=1.17.0
ARG RCON_CLI_VERSION=1.9.0
ARG RESTIFY_VERSION=1.7.22

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /build
# Intentionally refresh golang.org/x/* security packages to latest patched releases on each daily build.
# hadolint ignore=DL3062
RUN set -eux; \
    mkdir -p /out; \
    build_tool() { \
      local repo="$1" ver="$2" bin="$3"; \
      rm -rf "/build/${bin}"; \
      git clone --depth 1 --branch "${ver}" "https://github.com/itzg/${repo}.git" "/build/${bin}"; \
      pushd "/build/${bin}"; \
      for mod in golang.org/x/net golang.org/x/text golang.org/x/crypto golang.org/x/sys; do \
        if grep -q "${mod}" go.mod; then \
          go get -u "${mod}@latest"; \
        fi; \
      done; \
      go mod tidy; \
      CGO_ENABLED=0 go build -trimpath -ldflags="-s -w -X main.version=${ver}" -o "/out/${bin}" .; \
      popd; \
    }; \
    build_tool mc-monitor "${MC_MONITOR_VERSION}" mc-monitor; \
    build_tool mc-server-runner "${MC_SERVER_RUNNER_VERSION}" mc-server-runner; \
    build_tool rcon-cli "${RCON_CLI_VERSION}" rcon-cli; \
    build_tool restify "${RESTIFY_VERSION}" restify

# ---- Stage 2: build itzg/mc-image-helper from official tag with patched Java deps ----
FROM ${JDK_BUILDER_IMAGE} AS java-builder

ARG TARGETARCH
ARG MC_HELPER_VERSION=1.78.3
ARG MICROMETER_CORE_VERSION=1.16.9
ARG BCPROV_VERSION=1.87
ARG SCALA_LIBRARY_VERSION=2.13.18
ARG JACKSON3_VERSION=3.1.9
ARG LOGBACK_VERSION=1.5.38
ARG CLASSGRAPH_VERSION=4.8.200
ARG KOTLIN_VERSION=1.6.21

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
    && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY gradle/security-overrides.gradle /tmp/security-overrides.gradle

RUN set -eux; \
    git clone --depth 1 --branch "${MC_HELPER_VERSION}" https://github.com/itzg/mc-image-helper.git /src; \
    OVERRIDE_MICROMETER_CORE="${MICROMETER_CORE_VERSION}" \
    OVERRIDE_BCPROV="${BCPROV_VERSION}" \
    OVERRIDE_SCALA_LIBRARY="${SCALA_LIBRARY_VERSION}" \
    OVERRIDE_JACKSON3="${JACKSON3_VERSION}" \
    OVERRIDE_LOGBACK="${LOGBACK_VERSION}" \
    OVERRIDE_CLASSGRAPH="${CLASSGRAPH_VERSION}" \
    OVERRIDE_KOTLIN="${KOTLIN_VERSION}" \
      ./gradlew --no-daemon --init-script /tmp/security-overrides.gradle installDist -x test; \
    rm -f /src/build/install/mc-image-helper/lib/*-windows-x86_64.jar; \
    if [ "${TARGETARCH}" = "amd64" ]; then \
      rm -f /src/build/install/mc-image-helper/lib/*-linux-aarch_64.jar; \
    elif [ "${TARGETARCH}" = "arm64" ]; then \
      rm -f /src/build/install/mc-image-helper/lib/*-linux-x86_64.jar; \
    fi

# ---- Stage 3: fetch verified Eclipse Temurin 25 JRE & upstream itzg scripts ----
FROM ${DEBIAN_BASE} AS assets

ARG TARGETARCH
ARG UPSTREAM_VERSION=2026.11.1
ARG UPSTREAM_COMMIT=0699bd8497cb1e3c8e257fecd4320671194c6903
ARG TEMURIN_JRE_URL_AMD64="https://github.com/adoptium/temurin25-binaries/releases/download/jdk-25.0.5.1%2B2/OpenJDK25U-jre_x64_linux_hotspot_25.0.5.1_2.tar.gz"
ARG TEMURIN_JRE_SHA256_AMD64="2edef9e4f81ec5ee426d023336d4cfbd7b4644e99884e7a73a6a867b70b17acf"
ARG TEMURIN_JRE_URL_ARM64="https://github.com/adoptium/temurin25-binaries/releases/download/jdk-25.0.5.1%2B2/OpenJDK25U-jre_aarch64_linux_hotspot_25.0.5.1_2.tar.gz"
ARG TEMURIN_JRE_SHA256_ARM64="c6161dcfb365024fbfbcda265343d562d6f821c78dd8e7aeaeaf294893f6ff8b"
ARG LOG4J_PATCHER_VERSION=1.0.1
ARG LOG4J_PATCHER_SHA256="5ce2ba3000e05c2b361ab0a6b494c611748a5c58f59c2188ca05a207fd8b7d1c"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl dos2unix git \
    && rm -rf /var/lib/apt/lists/*

# Download & SHA-256 verify Eclipse Temurin 25 JRE for the target architecture
RUN set -eux; \
    case "${TARGETARCH}" in \
      amd64) JRE_URL="${TEMURIN_JRE_URL_AMD64}"; JRE_SHA="${TEMURIN_JRE_SHA256_AMD64}" ;; \
      arm64) JRE_URL="${TEMURIN_JRE_URL_ARM64}"; JRE_SHA="${TEMURIN_JRE_SHA256_ARM64}" ;; \
      *) echo "Unsupported TARGETARCH: ${TARGETARCH}" >&2; exit 1 ;; \
    esac; \
    curl -fsSLo /tmp/temurin-jre.tar.gz "${JRE_URL}"; \
    echo "${JRE_SHA}  /tmp/temurin-jre.tar.gz" | sha256sum -c -; \
    mkdir -p /opt/java/openjdk; \
    tar -xzf /tmp/temurin-jre.tar.gz --strip-components=1 -C /opt/java/openjdk; \
    rm -f /tmp/temurin-jre.tar.gz; \
    /opt/java/openjdk/bin/java -version

# Fetch verified upstream itzg/docker-minecraft-server scripts & Log4jPatcher
RUN set -eux; \
    git init /tmp/upstream; \
    git -C /tmp/upstream remote add origin https://github.com/itzg/docker-minecraft-server.git; \
    git -C /tmp/upstream fetch --depth 1 origin "${UPSTREAM_COMMIT}"; \
    git -C /tmp/upstream checkout --detach FETCH_HEAD; \
    test "$(git -C /tmp/upstream rev-parse HEAD)" = "${UPSTREAM_COMMIT}"; \
    mkdir -p /out/image/scripts/auto /out/image/scripts/shims; \
    cp -a /tmp/upstream/scripts/start* /out/image/scripts/; \
    cp -a /tmp/upstream/scripts/auto/* /out/image/scripts/auto/; \
    cp -a /tmp/upstream/scripts/shims/* /out/image/scripts/shims/; \
    cp -a /tmp/upstream/files/* /out/image/; \
    chmod 0755 /out/image/scripts/start* /out/image/scripts/auto/* /out/image/scripts/shims/*; \
    dos2unix /out/image/scripts/start* /out/image/scripts/auto/* /out/image/scripts/shims/*; \
    curl -fsSLo /out/image/Log4jPatcher.jar \
      "https://github.com/CreeperHost/Log4jPatcher/releases/download/v${LOG4J_PATCHER_VERSION}/Log4jPatcher-${LOG4J_PATCHER_VERSION}.jar"; \
    echo "${LOG4J_PATCHER_SHA256}  /out/image/Log4jPatcher.jar" | sha256sum -c -; \
    rm -rf /tmp/upstream

# ---- Stage 4: hardened Debian 13 (trixie) + Eclipse Temurin 25 JRE runtime ----
FROM ${DEBIAN_BASE} AS runtime

ARG UPSTREAM_VERSION=2026.11.1
ARG UPSTREAM_COMMIT=0699bd8497cb1e3c8e257fecd4320671194c6903
ARG TEMURIN_JRE_VERSION=jdk-25.0.5.1+2
ARG MC_HELPER_VERSION=1.78.3
ARG IMAGE_CREATED=""
ARG IMAGE_REVISION=""
ARG IMAGE_SOURCE="https://github.com/dgcosenza/minecraft-server-docker"

LABEL org.opencontainers.image.title="Minecraft Server (Debian 13 / Temurin JRE 25)" \
      org.opencontainers.image.description="Hardened, multi-arch Debian 13 (trixie) Minecraft Java Edition server image with Eclipse Temurin 25 JRE and source-built itzg helpers (no Mojang binaries bundled)." \
      org.opencontainers.image.url="https://hub.docker.com/r/dgcosenza/minecraft-server" \
      org.opencontainers.image.source="${IMAGE_SOURCE}" \
      org.opencontainers.image.documentation="${IMAGE_SOURCE}#readme" \
      org.opencontainers.image.version="${UPSTREAM_VERSION}" \
      org.opencontainers.image.revision="${IMAGE_REVISION}" \
      org.opencontainers.image.created="${IMAGE_CREATED}" \
      org.opencontainers.image.licenses="MIT AND Apache-2.0" \
      org.opencontainers.image.vendor="Daniel G. Cosenza from FNX Labs" \
      org.opencontainers.image.authors="Daniel G. Cosenza from FNX Labs" \
      io.github.dgcosenza.minecraft-server.upstream_version="${UPSTREAM_VERSION}" \
      io.github.dgcosenza.minecraft-server.upstream_commit="${UPSTREAM_COMMIT}" \
      io.github.dgcosenza.minecraft-server.java_version="${TEMURIN_JRE_VERSION}" \
      io.github.dgcosenza.minecraft-server.mc_helper_version="${MC_HELPER_VERSION}"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -eux; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get -y upgrade; \
    apt-get install -y --no-install-recommends \
      bash \
      ca-certificates \
      curl \
      file \
      git \
      iproute2 \
      iputils-ping \
      jq \
      lbzip2 \
      libnuma1 \
      locales \
      net-tools \
      openssl \
      procps \
      rsync \
      tini \
      tzdata \
      unzip \
      util-linux \
      xz-utils \
      zstd; \
    sed -i 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen; \
    locale-gen; \
    groupadd --gid 1000 minecraft; \
    useradd --system --uid 1000 --gid 1000 --home-dir /data --shell /usr/sbin/nologin minecraft; \
    install -d -o 1000 -g 1000 /data; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=assets /opt/java/openjdk /opt/java/openjdk
COPY --from=go-builder /out/mc-monitor /out/mc-server-runner /out/rcon-cli /out/restify /usr/local/bin/
COPY --from=java-builder /src/build/install/mc-image-helper /usr/share/mc-image-helper
COPY --from=assets /out/image /image
COPY --chmod=0755 scripts/gosu-setpriv.sh /usr/local/bin/gosu

RUN set -eux; \
    ln -s /usr/share/mc-image-helper/bin/mc-image-helper /usr/bin/mc-image-helper; \
    ln -s /image/scripts/shims/* /usr/local/bin/; \
    printf '#!/bin/bash\nexec /image/scripts/start "$@"\n' > /start; \
    chmod 0755 /start; \
    printf 'buildtime=%s\nversion=%s\nrevision=%s\n' \
      "${IMAGE_CREATED:-local}" "${UPSTREAM_VERSION}" "${IMAGE_REVISION:-local}" > /etc/image.properties

ENV JAVA_HOME=/opt/java/openjdk \
    JAVA_VERSION="${TEMURIN_JRE_VERSION}" \
    PATH=/opt/java/openjdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    HOME=/data \
    TYPE=VANILLA \
    VERSION=LATEST \
    EULA="" \
    UID=1000 \
    GID=1000

EXPOSE 25565
VOLUME ["/data"]
WORKDIR /data
STOPSIGNAL SIGTERM

USER 1000:1000

ENTRYPOINT ["/usr/bin/tini", "--", "/image/scripts/start"]
HEALTHCHECK --start-period=2m --retries=3 --interval=30s --timeout=10s CMD ["mc-health"]
