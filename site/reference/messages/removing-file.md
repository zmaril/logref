---
message: "removing file \"%s\""
slug: removing-file
passthrough: false
api: [elog, ereport, pg_log_debug]
level: [DEBUG, DEBUG2]
call_sites:
  - "postgres/src/backend/access/transam/slru.c:1568"
  - "postgres/src/backend/backup/walsummary.c:255"
  - "postgres/src/backend/storage/ipc/dsm.c:347"
  - "postgres/src/bin/pg_archivecleanup/pg_archivecleanup.c:161"
reproduced: false
---

# `removing file "%s"`

## What it means

A debug-level log line recording that the server is removing a file — a WAL segment, an SLRU segment, a temporary file, or similar — as part of normal cleanup. The placeholder is the path. It appears only at `DEBUG` levels and is a trace of routine housekeeping, not a problem.

## When it happens

Background maintenance removing files it no longer needs: WAL/SLRU segment recycling, temporary file cleanup, and similar, logged when the relevant `log_min_messages`/debug level is raised high enough to show `DEBUG` output.

## Is this a problem?

Nothing to do — it is informational tracing visible only at debug verbosity. If you did not intend to see debug output, lower `log_min_messages` back to a normal level (`warning`/`notice`) to quiet it.

## Example

*Illustrative* — a routine cleanup trace.

```text
DEBUG:  removing file "pg_wal/000000010000000000000001"
```

## Related

- [could not remove symbolic link](./could-not-remove-symbolic-link.md)
- [could not find WAL file](./could-not-find-wal-file.md)
