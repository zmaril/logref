# The LogRef reference site as a container: build the static bundle with Bun,
# then serve it with nginx. The build context is this `site/` directory (see
# fly.toml's `[build]` and .dockerignore), so every path below is relative to
# `site/`.

# Stage 1 — generate the static bundle into /app/dist with Bun.
FROM oven/bun:1-alpine AS build
WORKDIR /app
# Copy the manifest first so the install layer caches independently of source.
# The generator has no third-party dependencies today; the install step keeps
# working if one is ever added.
COPY package.json ./
RUN bun install
COPY . .
RUN bun run build

# Stage 2 — serve /app/dist as static files with nginx on port 80.
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
