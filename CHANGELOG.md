# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

Maintained by **Daniel G. Cosenza from FNX Labs**.

## [Unreleased]

<!-- changelog:auto -->

## [2026.11.1] — 2026-11-27

### Automated Daily Build
- Verified components: Base OS `Debian 13.8 (trixie-slim)`, Java Runtime `Eclipse Temurin jdk-25.0.5.1+2 (JRE)`, itzg/docker-minecraft-server `2026.11.1`, itzg/mc-image-helper `1.80.0 (source-built, patched deps)`, itzg/mc-monitor `1.21.1 (source-built)`, itzg/mc-server-runner `1.18.0 (source-built)`, itzg/rcon-cli `1.9.0 (source-built)`, itzg/restify `1.7.22 (source-built)`.
- Architectures verified: `linux/amd64, linux/arm64` (native smoke tests + Dive efficiency gate).
- Upstream changes:
  - **itzg/docker-minecraft-server:** `2026.11.1` -> `2026.11.1` (commit `0699bd8497cb`)
  - **Upstream version changed:** `no`
  - **Eclipse Temurin 25 JRE:** `jdk-25.0.5.1+2` (amd64 & arm64 verified via Adoptium API)
  - **Source-built helpers:** `mc-image-helper 1.80.0`, `mc-monitor 1.21.1`, `mc-server-runner 1.18.0`, `rcon-cli 1.9.0`, `restify 1.7.22`
  - **Java security overrides:** `micrometer-core 1.16.9`, `bcprov-jdk18on 1.87`, `scala-library 2.13.18`, `tools.jackson.core 3.1.9`, `logback 1.5.38`, `classgraph 4.8.200`, `kotli...
- Vulnerability gate: **0 fixable findings of any severity** in Trivy and Grype (SBOM scan) (22 upstream-unfixed).
- Published multi-arch digest (Docker Hub + GHCR): `dgcosenza/minecraft-server@sha256:8664fce8f8a98292ce318dcd5b2536c1712a755717f3c6b8e93a32cd6e8ab90c` (Cosign OIDC signed + SPDX/CycloneDX SBOM + SLSA L3 provenance).

---

## [2026.11.1] — 2026-11-26

### Automated Daily Build
- Verified components: Base OS `Debian 13.8 (trixie-slim)`, Java Runtime `Eclipse Temurin jdk-25.0.5.1+2 (JRE)`, itzg/docker-minecraft-server `2026.11.1`, itzg/mc-image-helper `1.80.0 (source-built, patched deps)`, itzg/mc-monitor `1.21.1 (source-built)`, itzg/mc-server-runner `1.18.0 (source-built)`, itzg/rcon-cli `1.9.0 (source-built)`, itzg/restify `1.7.22 (source-built)`.
- Architectures verified: `linux/amd64, linux/arm64` (native smoke tests + Dive efficiency gate).
- Upstream changes:
  - **itzg/docker-minecraft-server:** `2026.11.1` -> `2026.11.1` (commit `0699bd8497cb`)
  - **Upstream version changed:** `no`
  - **Eclipse Temurin 25 JRE:** `jdk-25.0.5.1+2` (amd64 & arm64 verified via Adoptium API)
  - **Source-built helpers:** `mc-image-helper 1.80.0`, `mc-monitor 1.21.1`, `mc-server-runner 1.18.0`, `rcon-cli 1.9.0`, `restify 1.7.22`
  - **Java security overrides:** `micrometer-core 1.16.9`, `bcprov-jdk18on 1.87`, `scala-library 2.13.18`, `tools.jackson.core 3.1.9`, `logback 1.5.38`, `classgraph 4.8.200`, `kotli...
- Vulnerability gate: **0 fixable findings of any severity** in Trivy and Grype (SBOM scan) (22 upstream-unfixed).
- Published multi-arch digest (Docker Hub + GHCR): `dgcosenza/minecraft-server@sha256:fc9ebc96c02cf623c08f04abdca6cc7694fd1520f5e82594b5631edea7ce4c22` (Cosign OIDC signed + SPDX/CycloneDX SBOM + SLSA L3 provenance).
---

## [2026.11.1] — 2026-11-25

### Automated Daily Build
- Verified components: Base OS `Debian 13.8 (trixie-slim)`, Java Runtime `Eclipse Temurin jdk-25.0.5.1+2 (JRE)`, itzg/docker-minecraft-server `2026.11.1`, itzg/mc-image-helper `1.80.0 (source-built, patched deps)`, itzg/mc-monitor `1.21.0 (source-built)`, itzg/mc-server-runner `1.17.0 (source-built)`, itzg/rcon-cli `1.9.0 (source-built)`, itzg/restify `1.7.22 (source-built)`.
- Architectures verified: `linux/amd64, linux/arm64` (native smoke tests + Dive efficiency gate).
- Upstream changes:
  - **itzg/docker-minecraft-server:** `2026.11.1` -> `2026.11.1` (commit `0699bd8497cb`)
  - **Upstream version changed:** `no`
  - **Eclipse Temurin 25 JRE:** `jdk-25.0.5.1+2` (amd64 & arm64 verified via Adoptium API)
  - **Source-built helpers:** `mc-image-helper 1.80.0`, `mc-monitor 1.21.0`, `mc-server-runner 1.17.0`, `rcon-cli 1.9.0`, `restify 1.7.22`
  - **Java security overrides:** `micrometer-core 1.16.9`, `bcprov-jdk18on 1.87`, `scala-library 2.13.18`, `tools.jackson.core 3.1.9`
- Vulnerability gate: **0 fixable Critical/High** in Trivy and Grype (SBOM scan) (22 upstream-unfixed).
- Published multi-arch digest (Docker Hub + GHCR): `dgcosenza/minecraft-server@sha256:7481fe3e29a08c1c157c358a6f52629ff34538cbc1eded7f3fb99970010fc6bb` (Cosign OIDC signed + SPDX/CycloneDX SBOM + SLSA L3 provenance).
---

---

## [2026.11.1] — 2026-11-25

### Added
- Initial hardened, multi-arch (`linux/amd64`, `linux/arm64`) **Debian 13 (`trixie-slim`)** + **Eclipse Temurin 25 JRE** container image for Minecraft Java Edition servers, drop-in compatible with `itzg/minecraft-server`.
- Multi-stage source builds of `itzg/mc-monitor`, `itzg/mc-server-runner`, `itzg/rcon-cli`, and `itzg/restify` using patched Go 1.27 (`golang:1.27-trixie`) and updated `golang.org/x/*` dependencies.
- Multi-stage source build of `itzg/mc-image-helper` with Gradle dependency security overrides (`micrometer-core`, `bcprov-jdk18on`, `scala-library 2.13.x`, `tools.jackson.core`).
- Rootless-by-default execution (`USER 1000:1000`, `minecraft`), `tini` PID 1 supervisor, zero-Go `setpriv`-based `/usr/local/bin/gosu` compatibility shim, and read-only rootfs compatibility.
- Automated 7-step daily CI pipeline with Hadolint, Gitleaks, Dive efficiency gate, Syft SPDX/CycloneDX SBOMs, Trivy + Grype hard gates, native `amd64`/`arm64` smoke tests, dual-registry publishing (GHCR + Docker Hub), Cosign keyless OIDC signing/attestations, SLSA Build L3 provenance, and signed GitHub Releases.

### Security
- Eliminated 41 fixable Critical/High vulnerabilities present in upstream `itzg/minecraft-server:latest` (26 in prebuilt `gosu`, 13 in `mc-image-helper` Java libraries, 1 in `mc-monitor`, 1 in `rcon-cli`); verified 0 fixable Critical/High in Trivy and Grype.
- Verified zero Mojang server JARs are bundled in published image layers (strict EULA compliance).
