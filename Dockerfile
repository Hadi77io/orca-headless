FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
ARG ORCA_VERSION=1.4.240

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl bash xvfb xauth dbus-x11 jq procps util-linux tini \
      git openssh-client fonts-dejavu-core \
      libgtk-3-0t64 libnss3 libasound2t64 libdrm2 libgbm1 libxkbcommon0 \
      libatk1.0-0t64 libatk-bridge2.0-0t64 libatspi2.0-0t64 libcups2t64 \
      libxcomposite1 libxdamage1 libxfixes3 libxrandr2 libxss1 libxtst6 \
      libpango-1.0-0 libcairo2 libx11-xcb1 libxcb-dri3-0 libexpat1 \
    && rm -rf /var/lib/apt/lists/*

# Extract the AppImage at build time: no FUSE inside containers.
RUN curl -fsSL -o /tmp/orca.AppImage \
      "https://github.com/stablyai/orca/releases/download/v${ORCA_VERSION}/orca-linux.AppImage" \
    && chmod +x /tmp/orca.AppImage \
    && cd /opt && /tmp/orca.AppImage --appimage-extract >/dev/null \
    && mv /opt/squashfs-root /opt/orca \
    && rm -f /tmp/orca.AppImage

RUN useradd -m -u 1001 -s /bin/bash orca \
    && mkdir -p /home/orca/.config /home/orca/.cache \
    && chown -R orca:orca /home/orca

COPY entrypoint.sh /usr/local/bin/orca-entrypoint
RUN chmod +x /usr/local/bin/orca-entrypoint

USER orca
ENV HOME=/home/orca \
    XDG_CONFIG_HOME=/home/orca/.config \
    XDG_CACHE_HOME=/home/orca/.cache \
    ORCA_PORT=6768
WORKDIR /home/orca
EXPOSE 6768
ENTRYPOINT ["/usr/bin/tini","--","/usr/local/bin/orca-entrypoint"]
