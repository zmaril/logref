---
message: "reading \"%s\""
slug: reading
passthrough: false
api: [pg_log_debug]
level: [DEBUG]
call_sites:
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:543"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:631"
  - "postgres/src/bin/pg_verifybackup/pg_verifybackup.c:775"
  - "postgres/src/bin/pg_verifybackup/pg_verifybackup.c:1022"
  - "postgres/src/bin/pg_waldump/archive_waldump.c:699"
reproduced: false
---

# `reading "%s"`

## What it means

A progress/debug line naming a file the tool is currently reading. The placeholder is the path. It comes from tools like `pg_combinebackup` at `DEBUG` level to trace which inputs are being processed. It is purely informational.

## When it happens

Running a tool with debug logging enabled, as it works through its input files and reports each one it opens for reading.

## Is this a problem?

This is normal trace output, not a problem. Use it to follow the tool's progress. Lower the verbosity if you do not want these lines.

## Example

*Illustrative* — a debug trace line.

```text
DEBUG:  reading "backup_manifest"
```

## Related

- [executing in dry-run mode](./executing-in-dry-run-mode.md)
- [duration: ms](./duration-ms-65550d.md)
