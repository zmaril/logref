---
message: "Did not find any extensions."
slug: did-not-find-any-extensions
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:6351"
reproduced: false
---

# `Did not find any extensions.`

## What it means

A psql `\dx` command found no installed extensions to list. This is psql reporting an empty result set, not a server error.

## When it happens

It fires when `\dx` is run on a database that has no extensions installed.

## How to fix

Nothing is wrong. If you expected extensions, confirm you are connected to the right database — extensions are per-database — and install what you need with `CREATE EXTENSION`.

## Example

*Illustrative* — an empty extension list.

```text
\dx
-- Did not find any extensions.
```

## Related

- [Did not find any extension named](./did-not-find-any-extension-named.md)
- [Did not find any settings](./did-not-find-any-settings.md)
