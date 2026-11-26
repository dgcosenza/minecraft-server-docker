#!/usr/bin/env python3
"""Resolve latest upstream itzg releases, Eclipse Temurin 25 JRE, Maven patches, and base digests."""
from __future__ import annotations

import json
import os
import pathlib
import re
import urllib.request
import xml.etree.ElementTree as ET


def http_json(url: str, headers: dict[str, str] | None = None) -> dict | list:
    req = urllib.request.Request(url, headers=headers or {})
    with urllib.request.urlopen(req, timeout=30) as resp:
        return json.loads(resp.read().decode("utf-8"))


def gh_api(path: str) -> dict | list:
    token = os.environ.get("GH_TOKEN", "").strip()
    headers = {
        "Accept": "application/vnd.github+json",
        "User-Agent": "dgcosenza-minecraft-server-ci",
    }
    if token:
        headers["Authorization"] = f"Bearer {token}"
    return http_json(f"https://api.github.com/{path.lstrip('/')}", headers=headers)


def resolve_tag_commit(repo: str, tag: str) -> str:
    ref = gh_api(f"repos/{repo}/git/ref/tags/{tag}")
    obj = ref["object"]
    if obj["type"] == "tag":
        tag_obj = gh_api(f"repos/{repo}/git/tags/{obj['sha']}")
        return tag_obj["object"]["sha"]
    return obj["sha"]


def resolve_maven_latest(group: str, artifact: str, prefix: str, fallback: str) -> str:
    try:
        url = f"https://repo1.maven.org/maven2/{group.replace('.', '/')}/{artifact}/maven-metadata.xml"
        req = urllib.request.Request(url, headers={"User-Agent": "dgcosenza-minecraft-server-ci"})
        with urllib.request.urlopen(req, timeout=20) as resp:
            root = ET.fromstring(resp.read())
        candidates = []
        for el in root.findall("./versioning/versions/version"):
            v = (el.text or "").strip()
            if not v.startswith(prefix) or "-" in v:
                continue
            parts = tuple(int(p) for p in v.split(".") if p.isdigit())
            if parts:
                candidates.append((parts, v))
        if candidates:
            candidates.sort()
            return candidates[-1][1]
    except Exception as exc:
        print(f"WARN: Maven lookup failed for {group}:{artifact}: {exc}")
    return fallback


def resolve_hub_digest(repo: str, tag: str) -> str:
    data = http_json(f"https://hub.docker.com/v2/repositories/library/{repo}/tags/{tag}")
    return (data.get("digest") or "").strip()


def resolve_temurin(arch: str) -> tuple[str, str, str]:
    url = (
        f"https://api.adoptium.net/v3/assets/latest/25/hotspot"
        f"?architecture={arch}&image_type=jre&os=linux&vendor=eclipse"
    )
    items = http_json(url, headers={"User-Agent": "dgcosenza-minecraft-server-ci"})
    item = items[0]
    rel = item["release_name"]
    pkg = item["binary"]["package"]
    return rel, pkg["link"], pkg["checksum"]


def main() -> int:
    override_upstream = os.environ.get("OVERRIDE_UPSTREAM", "").strip()
    if override_upstream:
        rel = gh_api(f"repos/itzg/docker-minecraft-server/releases/tags/{override_upstream}")
    else:
        rel = gh_api("repos/itzg/docker-minecraft-server/releases/latest")

    upstream_version = rel["tag_name"]
    upstream_commit = resolve_tag_commit("itzg/docker-minecraft-server", upstream_version)
    release_body = (rel.get("body") or "").strip()

    mc_helper = gh_api("repos/itzg/mc-image-helper/releases/latest")["tag_name"]
    mc_monitor = gh_api("repos/itzg/mc-monitor/releases/latest")["tag_name"]
    mc_runner = gh_api("repos/itzg/mc-server-runner/releases/latest")["tag_name"]
    rcon_cli = gh_api("repos/itzg/rcon-cli/releases/latest")["tag_name"]
    restify = gh_api("repos/itzg/restify/releases/latest")["tag_name"]

    jre_ver_amd64, jre_url_amd64, jre_sha_amd64 = resolve_temurin("x64")
    jre_ver_arm64, jre_url_arm64, jre_sha_arm64 = resolve_temurin("aarch64")
    jre_version = jre_ver_amd64

    micrometer_ver = resolve_maven_latest("io.micrometer", "micrometer-core", "1.16.", "1.16.9")
    bcprov_ver = resolve_maven_latest("org.bouncycastle", "bcprov-jdk18on", "1.", "1.87")
    scala_ver = resolve_maven_latest("org.scala-lang", "scala-library", "2.13.", "2.13.18")
    jackson3_ver = resolve_maven_latest("tools.jackson.core", "jackson-databind", "3.1.", "3.1.9")
    logback_ver = resolve_maven_latest("ch.qos.logback", "logback-core", "1.5.", "1.5.38")
    classgraph_ver = resolve_maven_latest("io.github.classgraph", "classgraph", "4.8.", "4.8.200")
    kotlin_ver = resolve_maven_latest("org.jetbrains.kotlin", "kotlin-stdlib", "1.6.", "1.6.21")

    debian_digest = resolve_hub_digest("debian", "trixie-slim")
    golang_digest = resolve_hub_digest("golang", "1.27-trixie")
    jdk_digest = resolve_hub_digest("eclipse-temurin", "21-jdk")

    debian_base = f"debian:trixie-slim@{debian_digest}" if debian_digest else "debian:trixie-slim"
    golang_image = f"golang:1.27-trixie@{golang_digest}" if golang_digest else "golang:1.27-trixie"
    jdk_image = f"eclipse-temurin:21-jdk@{jdk_digest}" if jdk_digest else "eclipse-temurin:21-jdk"

    prev = {}
    vpath = pathlib.Path("versions.json")
    if vpath.exists():
        try:
            prev = json.loads(vpath.read_text(encoding="utf-8"))
        except Exception:
            prev = {}

    prev_ver = prev.get("upstream_version", "none")
    changed = "yes" if prev_ver != upstream_version else "no"

    changes_lines = [
        "# Upstream Changes",
        "",
        f"- **itzg/docker-minecraft-server:** `{prev_ver}` -> `{upstream_version}` (commit `{upstream_commit[:12]}`)",
        f"- **Upstream version changed:** `{changed}`",
        f"- **Eclipse Temurin 25 JRE:** `{jre_version}` (amd64 & arm64 verified via Adoptium API)",
        f"- **Source-built helpers:** `mc-image-helper {mc_helper}`, `mc-monitor {mc_monitor}`, `mc-server-runner {mc_runner}`, `rcon-cli {rcon_cli}`, `restify {restify}`",
        f"- **Java security overrides:** `micrometer-core {micrometer_ver}`, `bcprov-jdk18on {bcprov_ver}`, `scala-library {scala_ver}`, `tools.jackson.core {jackson3_ver}`, `logback {logback_ver}`, `classgraph {classgraph_ver}`, `kotlin-stdlib {kotlin_ver}`",
    ]
    if release_body:
        changes_lines.append("")
        changes_lines.append("## Upstream Release Notes")
        for line in release_body.splitlines()[:20]:
            cleaned = re.sub(r"https?://\S+", "", line).strip()
            if cleaned:
                changes_lines.append(cleaned)

    pathlib.Path("upstream-changes.md").write_text("\n".join(changes_lines) + "\n", encoding="utf-8")

    outputs = {
        "upstream_version": upstream_version,
        "upstream_commit": upstream_commit,
        "mc_helper_version": mc_helper,
        "mc_monitor_version": mc_monitor,
        "mc_server_runner_version": mc_runner,
        "rcon_cli_version": rcon_cli,
        "restify_version": restify,
        "temurin_jre_version": jre_version,
        "temurin_jre_url_amd64": jre_url_amd64,
        "temurin_jre_sha256_amd64": jre_sha_amd64,
        "temurin_jre_url_arm64": jre_url_arm64,
        "temurin_jre_sha256_arm64": jre_sha_arm64,
        "micrometer_core_version": micrometer_ver,
        "bcprov_version": bcprov_ver,
        "scala_library_version": scala_ver,
        "jackson3_version": jackson3_ver,
        "logback_version": logback_ver,
        "classgraph_version": classgraph_ver,
        "kotlin_version": kotlin_ver,
        "debian_base": debian_base,
        "base_digest": debian_digest,
        "golang_image": golang_image,
        "jdk_builder_image": jdk_image,
    }
    gh_out = os.environ.get("GITHUB_OUTPUT")
    if gh_out:
        with open(gh_out, "a", encoding="utf-8") as fh:
            for k, v in outputs.items():
                fh.write(f"{k}={v}\n")
    for k, v in outputs.items():
        print(f"{k}={v}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
