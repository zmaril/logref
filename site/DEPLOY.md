# Deploying the LogRef site to Fly.io

The site is a pile of static files. `bun run build` reads every markdown page in
`reference/messages/` and writes a self-contained bundle into `dist/`: one HTML
page per message, a search landing page, the client search bundle, a JSON index,
and the stylesheet.

Fly.io runs containers rather than a static-file host, so the bundle ships
inside an image: the [`Dockerfile`](./Dockerfile) builds `dist/` with Bun in one
stage and serves it with nginx in the next. [`fly.toml`](./fly.toml) wires that
image to a machine that listens on port 80 and scales to zero when idle.

## Build the bundle

```sh
cd site
bun install
bun run build   # writes dist/
```

`dist/` is gitignored — it is regenerated from source inside the image on every
deploy, so there is nothing to commit. You only need this step to preview
locally; `fly deploy` runs the same build inside the container.

## Preview the container locally (optional)

If you have Docker, you can run exactly what Fly will run:

```sh
cd site
docker build -t logref-site .
docker run --rm -p 8080:80 logref-site
# then open http://localhost:8080
```

## One-time app creation

The app name in `fly.toml` is `logref`. Fly app names are globally unique, so if
that one is taken, choose another (and update `app` in `fly.toml`, or pass
`--app <name>` to the commands below). Create the app once, without deploying:

```sh
cd site
fly launch --no-deploy   # reuses the existing fly.toml; creates the app
# or, equivalently:
fly apps create logref
```

Install the CLI first if you do not have it: `curl -L https://fly.io/install.sh | sh`,
then `fly auth login`.

## Deploy

From `site/`:

```sh
fly deploy
```

Fly builds the image, pushes it, and starts the machine. When it finishes the
site is live at `https://logref.fly.dev` (or `https://<your-app>.fly.dev` if you
renamed it).

## Non-interactive and CI deploys

For a deploy without an interactive login — a script or a CI job — authenticate
with a deploy token instead of `fly auth login`. Create one with
`fly tokens create deploy` (or in the Fly dashboard under the app's **Tokens**),
and expose it as `FLY_API_TOKEN`. `flyctl` reads that variable automatically:

```sh
export FLY_API_TOKEN=your-fly-deploy-token
fly deploy --app logref --remote-only
```

`--remote-only` builds the image on Fly's builders, so the CI runner needs no
local Docker daemon. Keep the token in the CI secret store, never in the repo.

## Status as of this branch

Not yet deployed. The sandbox that built this branch has no Fly credentials
(`FLY_API_TOKEN` is unset and `flyctl` is not installed), so the app-creation and
`fly deploy` steps above must be run by someone who is authenticated to Fly.
