---
message: "could not write %d bytes to log file \"%s\": %m"
slug: could-not-write-bytes-to-log-file
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:572"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:584"
reproduced: false
---

# `could not write %d bytes to log file "%s": %m`

## What it means

`pg_recvlogical` could not write received bytes to its output log file. The `%d` is the byte count and the `%s` is the path, followed by the operating-system error. The decoded output was not fully written.

## When it happens

The output file's filesystem was full or read-only, or an I/O error occurred, while `pg_recvlogical` wrote decoded changes to the file.

## How to fix

Read the trailing error. Ensure the output path has free space and is writable, then restart `pg_recvlogical`; it resumes from the last confirmed position.

## Example

*Illustrative* — the output file ran out of space.

```text
pg_recvlogical: error: could not write 512 bytes to log file "out.txt": No space left on device
```

## Related

- [could not write to output file](./could-not-write-to-output-file.md)
- [could not write COPY data](./could-not-write-copy-data.md)
