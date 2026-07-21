---
message: "configuration file \"%s\" contains errors"
slug: configuration-file-contains-errors
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONFIG_FILE_ERROR
    code: "F0000"
call_sites:
  - "postgres/src/backend/utils/misc/guc.c:608"
reproduced: false
---

# `configuration file "%s" contains errors`

## What it means

A configuration file (such as `postgresql.conf`) was parsed and one or more settings in it were invalid, so the file as a whole was not applied. Individual problems are logged separately; this message reports that the file failed overall.

## When it happens

It happens at server start or on `pg_reload_conf()`/`SIGHUP` when the configuration file has syntax errors or invalid parameter values.

## How to fix

Read the accompanying log lines that name the specific bad settings, correct them in the configuration file, and reload. Use `postgres --check` or a test reload to validate before relying on it.

## Example

*Illustrative* — a config file that failed to parse.

```text
ERROR:  configuration file "/etc/postgresql.conf" contains errors
```

## Related

- [configuration column does not exist](./configuration-column-does-not-exist.md)
- [could not change directory to](./could-not-change-directory-to-41f86e.md)
