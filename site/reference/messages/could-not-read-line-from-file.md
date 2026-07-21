---
message: "could not read line %d from file \"%s\": %m"
slug: could-not-read-line-from-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/option.c:526"
reproduced: false
---

# `could not read line %d from file "%s": %m`

## What it means

`pg_upgrade` failed to read an expected line from one of its internal work files. The first placeholder is the line number, the second the file, and the trailing text is the operating-system error.

## When it happens

It fires mid-upgrade while `pg_upgrade` reads back a list it wrote earlier (for example a mapping of databases or relations), if that file is shorter than expected or unreadable.

## How to fix

This points at a damaged or truncated work file in the upgrade's output directory, often from a disk-full condition or an interrupted run. Clear the previous attempt, make sure the working directory has room, and rerun `pg_upgrade` from a clean state. Keep the log if it recurs on a healthy filesystem.

## Example

*Illustrative* — a work file ended before the expected line.

```text
pg_upgrade: error: could not read line 42 from file "pg_upgrade_dump_globals.sql": end of file
```

## Related

- [could not read input file](./could-not-read-input-file.md)
- [could not synchronize file](./could-not-synchronize-file.md)
