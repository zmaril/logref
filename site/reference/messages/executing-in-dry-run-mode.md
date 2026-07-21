---
message: "executing in dry-run mode"
slug: executing-in-dry-run-mode
passthrough: false
api: [pg_log_info]
level: [INFO]
call_sites:
  - "postgres/src/bin/pg_archivecleanup/pg_archivecleanup.c:380"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:2518"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:247"
  - "postgres/src/bin/pg_rewind/pg_rewind.c:306"
  - "postgres/src/bin/scripts/vacuumdb.c:312"
reproduced: false
---

# `executing in dry-run mode`

## What it means

A tool is running in dry-run mode: it reports what it would do without making changes. The message (here from `pg_archivecleanup`) confirms that no files will actually be removed or modified during this run. It is informational.

## When it happens

Running a maintenance tool with its dry-run/`-n` flag, so it computes and prints the actions it would take but does not perform them.

## Is this a problem?

This is expected output of dry-run mode and not a problem. Review the reported actions; when satisfied, re-run without the dry-run flag to apply them.

## Example

*Illustrative* — a dry-run notice.

```text
INFO:  executing in dry-run mode
```

## Related

- [reading](./reading.md)
- [duration: ms](./duration-ms-65550d.md)
