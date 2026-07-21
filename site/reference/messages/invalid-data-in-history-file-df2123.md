---
message: "invalid data in history file: %s"
slug: invalid-data-in-history-file-df2123
passthrough: false
api: [ereport, pg_log_error]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/backend/access/transam/timeline.c:173"
  - "postgres/src/bin/pg_rewind/timeline.c:86"
reproduced: false
---

# `invalid data in history file: %s`

## What it means

A timeline history file (`NNNNNNNN.history` in the WAL archive or `pg_wal`) contained a line that could not be parsed. History files record timeline switch points during recovery and failover; a malformed one blocks recovery.

## When it happens

It arises during archive recovery or standby startup when Postgres reads a `.history` file whose contents are truncated, corrupted, or hand-edited into an invalid form.

## How to fix

Restore an intact copy of the history file from your archive or the primary. History files are small and append-only; a good copy from the source timeline resolves it. Check the archive command and storage for the corruption source, and never edit these files by hand.

## Example

*Illustrative* — a garbled line in a timeline history file.

```text
FATAL:  invalid data in history file: not-a-valid-line
```

## Related

- [invalid TLI](./invalid-tli.md)
- [invalid WAL location](./invalid-wal-location.md)
