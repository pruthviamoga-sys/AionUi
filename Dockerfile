FROM oven/bun:1
WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends libicu-dev ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*

COPY . .
RUN bun install --ignore-scripts

# Renderer build (same command as the repo's "package" script, no Electron launch)
RUN bun run package

# Fetch the pinned aioncore backend binary from GitHub releases
RUN bun scripts/prepareAioncore.js

ENV NODE_ENV=production
ENV AIONUI_HOST=0.0.0.0
ENV AIONUI_ALLOW_REMOTE=1
ENV AIONUI_PORT=3000
ENV AIONUI_DATA_DIR=/data
ENV AIONUI_OPEN_BROWSER=0

VOLUME ["/data"]
EXPOSE 3000

CMD ["bun", "scripts/webui.ts"]
