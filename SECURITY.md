# Security Policy

Maintained by **Daniel G. Cosenza from FNX Labs**.

## Supported Versions

Only the latest daily build (`latest`) receives security updates. Immutable date-stamped tags (`<version>-YYYYMMDD`) are frozen for reproducibility.

## Vulnerability Scanning & Gates

- **Preflight**: Hadolint (blocking on warning+), Gitleaks full-history secret scanning, and public-content/attribution checks run on every push and pull request.
- **Trivy** (OS + Go + Java libraries): SARIF uploaded to GitHub Code Scanning; table and JSON reports retained for 90 days; **blocking hard gate** on any fixable `CRITICAL` or `HIGH` finding.
- **Grype** (scanning Syft SPDX SBOM): **blocking hard gate** (`--only-fixed --fail-on high`); table report retained for 90 days.
- **SBOM & Provenance**: SPDX-JSON and CycloneDX-JSON SBOMs per architecture attached as Cosign keyless OIDC attestations alongside SLSA Build L3 provenance.
- **Runtime Integrity**: Eclipse Temurin 25 JRE tarballs and `Log4jPatcher.jar` are strictly SHA-256 verified at build time. Go helper binaries and `mc-image-helper` are compiled from pinned official source tags with patched toolchains and dependencies. No proprietary Mojang server binaries are bundled.

## Reporting a Vulnerability

**Do not open a public issue** for security vulnerabilities.

Report privately through GitHub Security Advisories: open the repository's **Security** tab or submit a private advisory directly at [dgcosenza/minecraft-server-docker Security Advisories](https://github.com/dgcosenza/minecraft-server-docker/security/advisories/new).

For upstream script issues, see [itzg/docker-minecraft-server Security Policy](https://github.com/itzg/docker-minecraft-server/security/policy).
