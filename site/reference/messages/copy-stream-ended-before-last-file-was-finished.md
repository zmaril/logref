---
message: "COPY stream ended before last file was finished"
slug: copy-stream-ended-before-last-file-was-finished
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/fe_utils/astreamer_tar.c:361"
reproduced: false
---

# `COPY stream ended before last file was finished`

## What it means

A tar stream being read (for a backup or restore) ended before the current file's data was complete. The stream was truncated mid-file, so the operation cannot finish.

## When it happens

It happens in tools that read a tar-format stream (such as `pg_basebackup` restore paths) when the connection or input ends prematurely.

## How to fix

Re-run the transfer and ensure the stream completes without interruption. Check for network drops, disk-full conditions on the destination, or a source that stopped sending. A truncated stream cannot be used as-is.

## Example

*Illustrative* — a truncated tar stream.

```text
pg_basebackup: error: COPY stream ended before last file was finished
```

## Related

- [corrupt tar header found in expected computed file position](./corrupt-tar-header-found-in-expected-computed-file-position.md)
- [could not close compressed file](./could-not-close-compressed-file.md)
