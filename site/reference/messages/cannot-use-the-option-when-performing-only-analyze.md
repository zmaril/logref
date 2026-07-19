---
message: "cannot use the \"%s\" option when performing only analyze"
slug: cannot-use-the-option-when-performing-only-analyze
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/scripts/vacuumdb.c:250"
  - "postgres/src/bin/scripts/vacuumdb.c:253"
  - "postgres/src/bin/scripts/vacuumdb.c:256"
  - "postgres/src/bin/scripts/vacuumdb.c:259"
  - "postgres/src/bin/scripts/vacuumdb.c:262"
  - "postgres/src/bin/scripts/vacuumdb.c:265"
  - "postgres/src/bin/scripts/vacuumdb.c:268"
  - "postgres/src/bin/scripts/vacuumdb.c:271"
  - "postgres/src/bin/scripts/vacuumdb.c:281"
reproduced: false
---

# `cannot use the "%s" option when performing only analyze`

## What it means

`vacuumdb` was given an option that only applies to vacuuming, together with `--analyze-only`. The placeholder is the option. `--analyze-only` runs `ANALYZE` without vacuuming, so vacuum-specific flags (like `--full` or `--freeze`) are meaningless and rejected.

## When it happens

Running `vacuumdb --analyze-only` while also passing a vacuum-only flag such as `--full`, `--freeze`, or `--disable-page-skipping`. The two intents conflict.

## How to fix

Drop the vacuum-only option, or drop `--analyze-only` if you actually want to vacuum. Decide whether you are analyzing (statistics only) or vacuuming (space reclamation), and keep only the options for that mode.

## Example

*Illustrative* — a vacuum-only flag with analyze-only.

```sh
vacuumdb --analyze-only --full mydb
```

Produces:

```text
vacuumdb: error: cannot use the "full" option when performing only analyze
```

## Related

- [cannot use the option on server versions older than PostgreSQL %s](./cannot-use-the-option-on-server-versions-older-than-postgresql.md)
- [conflicting or redundant options](./conflicting-or-redundant-options.md)
