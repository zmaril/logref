---
message: "could not create archive status file \"%s\": %s"
slug: could-not-create-archive-status-file-29a4bc
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/receivelog.c:66"
reproduced: false
---

# `could not create archive status file "%s": %s`

## What it means

`pg_basebackup`'s WAL receiver could not create an archive-status file for a completed WAL segment. The `%s` gives the reason. These marker files record which segments are ready.

## When it happens

It happens while streaming WAL to a target directory when creating a `.done` status file fails, usually from a full destination filesystem or a permissions problem.

## How to fix

Check free space and permissions on the target WAL directory. Resolve the storage problem and rerun; the affected segment's status could not be recorded.

## Example

*Illustrative* — a status file that cannot be created.

```text
pg_basebackup: error: could not create archive status file "...": No space left on device
```

## Related

- [could not create timeline history file](./could-not-create-timeline-history-file.md)
- [could not create compressed file](./could-not-create-compressed-file.md)
