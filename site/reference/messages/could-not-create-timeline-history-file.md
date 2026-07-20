---
message: "could not create timeline history file \"%s\": %s"
slug: could-not-create-timeline-history-file
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/receivelog.c:297"
reproduced: false
---

# `could not create timeline history file "%s": %s`

## What it means

`pg_basebackup`'s WAL receiver could not create the timeline history file for the timeline it is following. The `%s` gives the reason. This file records the branch points of a timeline.

## When it happens

It happens while streaming WAL to a target directory when creating the `.history` file fails, usually from a full destination filesystem or a permissions problem.

## How to fix

Check free space and permissions on the target directory, then rerun. The timeline history could not be recorded, so the destination is incomplete.

## Example

*Illustrative* — a history file that cannot be created.

```text
pg_basebackup: error: could not create timeline history file "00000002.history": No space left on device
```

## Related

- [could not create archive status file](./could-not-create-archive-status-file-29a4bc.md)
- [could not create compressed file](./could-not-create-compressed-file.md)
