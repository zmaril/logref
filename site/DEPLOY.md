# Deploying the LogRef site to Cloudflare Pages

The site is a pile of static files. `bun run build` reads every markdown page in
`reference/messages/` and writes a self-contained bundle into `dist/`: one HTML
page per message, a search landing page, the client search bundle, a JSON index,
and the stylesheet. Cloudflare Pages just serves that directory.

## Build the bundle

```sh
cd site
bun install
bun run build   # writes dist/
```

`dist/` is gitignored — it is regenerated from source on every deploy, so there
is nothing to commit.

## One-time credentials

Deploying needs two values from the Cloudflare dashboard, exported as
environment variables:

| Variable | Where it comes from | Notes |
|---|---|---|
| `CLOUDFLARE_API_TOKEN` | My Profile then API Tokens then Create Token | Give it the **Cloudflare Pages: Edit** permission. |
| `CLOUDFLARE_ACCOUNT_ID` | Any domain's Overview page, or Workers and Pages | The 32-character account identifier. |

```sh
export CLOUDFLARE_API_TOKEN=your-token
export CLOUDFLARE_ACCOUNT_ID=your-account-id
```

## Deploy

From `site/`, after building:

```sh
bunx wrangler pages deploy dist --project-name logref
```

The first run offers to create the `logref` Pages project; accept it. Wrangler
prints the deployed `https://logref.pages.dev` URL (and a per-deploy preview URL)
when it finishes. Re-running the same command ships a new version.

## Continuous deploys (optional)

Instead of deploying by hand, connect the GitHub repo in the Pages dashboard and
set:

- **Build command:** `cd site && bun install && bun run build`
- **Build output directory:** `site/dist`
- **Root directory:** repository root

Pages then rebuilds and redeploys on every push to the production branch.

## Status as of this branch

Not yet deployed. The sandbox that built this branch has no Cloudflare
credentials (`CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID` are unset) and
`wrangler whoami` reports it is not authenticated, so the deploy step above must
be run by someone who has them.
