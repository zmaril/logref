---
message: "syntax error in history file: %s"
slug: syntax-error-in-history-file
passthrough: false
api: [ereport, pg_log_error]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/backend/access/transam/timeline.c:163"
  - "postgres/src/backend/access/transam/timeline.c:168"
  - "postgres/src/bin/pg_rewind/timeline.c:74"
  - "postgres/src/bin/pg_rewind/timeline.c:80"
reproduced: false
---

# `syntax error in history file: %s`

## What it means

Postgres could not parse a timeline history file. The placeholder is the offending content. Each timeline created by point-in-time recovery or promotion has a `.history` file in the WAL directory listing the parent timelines and switch points; a malformed line means that file is corrupt or was hand-edited incorrectly.

## When it happens

Starting recovery or a standby that must read a timeline's history, when the `NNNNNNNN.history` file (in `pg_wal` or the archive) has a garbled or truncated line — from a bad copy during archive setup, a partial write, or manual editing.

## How to fix

Inspect the named history file in the archive and the standby's `pg_wal`. It is a small text file (`<timeline>\t<LSN>\t<reason>` per line); fix or restore the corrupt line from a good copy of the same timeline history. If the archive is the source of truth, re-fetch the file from there. Make sure archiving copies history files intact.

## Example

*Illustrative* — a corrupt timeline history line.

```text
FATAL:  syntax error in history file: garbage
```

## Related

- [could not find WAL file](./could-not-find-wal-file.md)
- [could not find a valid record after](./could-not-find-a-valid-record-after-dd2f88.md)
