---
message: "could not close file \"%s\": %s"
slug: could-not-close-file-62a3f1
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/receivelog.c:227"
  - "postgres/src/bin/pg_basebackup/receivelog.c:317"
  - "postgres/src/bin/pg_basebackup/receivelog.c:694"
reproduced: false
---

# `could not close file "%s": %s`

## What it means

A client-side tool (here in the base-backup/streaming path) got an error when closing a file it had written. The placeholders are the file path and the OS error. A failed `close()` can mean buffered data was not flushed to disk — so the file may be incomplete — which is why it is reported rather than ignored.

## When it happens

An I/O error surfaced at close time: a full or failing disk, a network filesystem hiccup, or the file being removed underneath the tool while it was open.

## How to fix

Read the appended OS error. Check the destination filesystem for space and health (`df`, dmesg/OS logs), and re-run the operation so the file is written cleanly. Treat any file whose close failed as suspect and regenerate it. Persistent failures point to a storage problem to fix at the OS level.

## Example

*Illustrative* — a failed file close during backup.

```text
pg_basebackup: error: could not close file "base.tar": No space left on device
```

## Related

- [could not open output file](./could-not-open-output-file-202c64.md)
- [could not read file read of](./could-not-read-file-read-of-2ed767.md)
