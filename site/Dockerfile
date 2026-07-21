# The LogRef reference site as a container: compile the Rust scanner to wasm,
# build the static bundle with Bun, then serve it with nginx.
#
# The build context is the REPO ROOT (the wasm stage needs crates/ + Cargo.lock),
# so build with `docker build -f site/Dockerfile .` from the repo root — see
# DEPLOY.md and the root .dockerignore.

# Stage 1 — the wasm scanner: cargo (wasm32) + the pinned wasm-bindgen CLI.
FROM rust:1-alpine AS wasm
RUN apk add --no-cache musl-dev bash curl
# Must match the wasm-bindgen crate version in Cargo.lock (the CLI refuses a
# module built against a different version). Prebuilt musl binary when the
# builder is x86_64; cargo install fallback otherwise.
ARG WASM_BINDGEN_VERSION=0.2.126
RUN rustup target add wasm32-unknown-unknown && \
    { [ "$(uname -m)" = "x86_64" ] && \
      curl -sSfL "https://github.com/wasm-bindgen/wasm-bindgen/releases/download/${WASM_BINDGEN_VERSION}/wasm-bindgen-${WASM_BINDGEN_VERSION}-x86_64-unknown-linux-musl.tar.gz" \
        | tar -xz --strip-components=1 -C /usr/local/bin \
          "wasm-bindgen-${WASM_BINDGEN_VERSION}-x86_64-unknown-linux-musl/wasm-bindgen" ; } || \
    cargo install wasm-bindgen-cli --version "${WASM_BINDGEN_VERSION}" --locked
WORKDIR /repo
COPY Cargo.toml Cargo.lock ./
COPY crates ./crates
COPY scripts/build-wasm-web.sh ./scripts/build-wasm-web.sh
RUN mkdir -p site/src && bash scripts/build-wasm-web.sh

# Stage 2 — generate the static bundle into /repo/site/dist with Bun.
FROM oven/bun:1-alpine AS build
WORKDIR /repo/site
# Copy the manifest first so the install layer caches independently of source.
# The generator has no third-party dependencies today; the install step keeps
# working if one is ever added.
COPY site/package.json ./
RUN bun install
COPY site .
COPY --from=wasm /repo/site/src/wasm ./src/wasm
RUN bun run build

# Stage 3 — serve the bundle as static files with nginx on port 80.
FROM nginx:alpine
COPY site/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /repo/site/dist /usr/share/nginx/html
EXPOSE 80
