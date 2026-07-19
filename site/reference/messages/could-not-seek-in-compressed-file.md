---
message: "could not seek in compressed file \"%s\": %m"
slug: could-not-seek-in-compressed-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:343"
reproduced: false
---

# `could not seek in compressed file "%s": %m`

## What it means

`pg_receivewal` could not reposition within a compressed WAL file. The placeholder is the file and the trailing text is the operating-system error. Seeking is needed to find where writing should continue in a partial file.

## When it happens

It fires when `pg_receivewal` opens an existing compressed segment to resume and cannot seek within it — an I/O error, or a file that is not a valid compressed segment.

## How to fix

Read the OS error. An I/O failure points at the storage holding the target directory. If a compressed file in the directory is truncated or not a valid archive, move it aside so the tool can start a fresh segment. Confirm the target directory is writable and healthy, then rerun.

## Example

*Illustrative* — a seek in a compressed segment failed.

```text
pg_receivewal: error: could not seek in compressed file "000000010000000000000009.gz.partial": Input/output error
```

## Related

- [could not write to compressed file](./could-not-write-to-compressed-file.md)
- [could not seek in file to offset](./could-not-seek-in-file-to-offset.md)
