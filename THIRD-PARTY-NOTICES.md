# Third-Party Notices

This container image packaging repository is maintained by **Daniel G. Cosenza from FNX Labs** under the MIT License (see `LICENSE`).

The published container image incorporates the following open-source upstream components (no proprietary Mojang/Minecraft server binaries are bundled; end users explicitly accept the Minecraft EULA via `EULA=TRUE` so the Minecraft server JAR is fetched at container startup):

1. **itzg/docker-minecraft-server** (startup scripts and configuration templates)
   - Upstream: https://github.com/itzg/docker-minecraft-server
   - License: Apache License 2.0 (`Apache-2.0`)

2. **itzg/mc-image-helper** (built from source with security-patched Java dependencies)
   - Upstream: https://github.com/itzg/mc-image-helper
   - License: MIT License (`MIT`)

3. **itzg/mc-monitor** (built from source)
   - Upstream: https://github.com/itzg/mc-monitor
   - License: MIT License (`MIT`)

4. **itzg/mc-server-runner**, **itzg/rcon-cli**, **itzg/restify** (built from source)
   - Upstream: https://github.com/itzg/mc-server-runner, https://github.com/itzg/rcon-cli, https://github.com/itzg/restify
   - License: Apache License 2.0 (`Apache-2.0`)

5. **Eclipse Temurin 25 JRE (Adoptium)**
   - Upstream: https://adoptium.net/
   - License: GNU General Public License v2.0 with the Classpath Exception (`GPL-2.0-with-classpath-exception`)

6. **CreeperHost/Log4jPatcher**
   - Upstream: https://github.com/CreeperHost/Log4jPatcher
   - License: MIT License (`MIT`)

7. **Debian 13 (`trixie-slim`) Base System & Packages** (`tini`, `util-linux`, `curl`, `git`, `jq`, `openssl`, `rsync`, etc.)
   - Upstream: https://www.debian.org/
   - Licenses: Respective free and open-source licenses documented in `/usr/share/doc/*/copyright` inside the image.

8. **Minecraft Java Edition Server (runtime-fetched, NOT bundled)**
   - Upstream: Mojang AB / Microsoft Corporation
   - License: Proprietary — governed by the [Minecraft End User License Agreement (EULA)](https://www.minecraft.net/en-us/eula).
