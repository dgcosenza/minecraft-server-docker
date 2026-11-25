# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

Maintained by **Daniel G. Cosenza from FNX Labs**.

## [Unreleased]

<!-- changelog:auto -->

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
