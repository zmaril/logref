---
message: "could not parse contents of file \"%s\""
slug: could-not-parse-contents-of-file
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONFIG_FILE_ERROR
    code: "F0000"
call_sites:
  - "postgres/src/backend/utils/misc/guc.c:4686"
reproduced: false
---

# `could not parse contents of file "%s"`

## What it means

The server read a configuration data file it maintains and could not parse its contents. The `%s` value names the file. Some settings are persisted to auxiliary files the server rewrites and reads back.

## When it happens

It fires while loading a persisted configuration file (for example `postgresql.auto.conf` written by `ALTER SYSTEM`), when its contents are malformed — usually because the file was hand-edited incorrectly or truncated.

## How to fix

Restore the file to valid syntax. For `postgresql.auto.conf`, prefer editing it only through `ALTER SYSTEM`; if it is already broken, correct or clear it (it is safe to reset to empty) and reload. The named file tells you which one to fix.

## Example

*Illustrative* — a malformed configuration file.

```text
ERROR:  could not parse contents of file "postgresql.auto.conf"
```

## Related

- [could not parse reloptions array](./could-not-parse-reloptions-array.md)
- [could not parse version file](./could-not-parse-version-file.md)
