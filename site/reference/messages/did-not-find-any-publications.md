---
message: "Did not find any publications."
slug: did-not-find-any-publications
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:6707"
reproduced: false
---

# `Did not find any publications.`

## What it means

A psql `\dRp` command found no publications to list. This is psql reporting an empty result, not a server error.

## When it happens

It fires when `\dRp` runs on a database with no publications defined.

## How to fix

Nothing is wrong. If you expected publications, confirm you are on the right database and create them with `CREATE PUBLICATION`.

## Example

*Illustrative* — no publications to show.

```text
\dRp
-- Did not find any publications.
```

## Related

- [Did not find any publication named](./did-not-find-any-publication-named.md)
- [Did not find any extensions](./did-not-find-any-extensions.md)
