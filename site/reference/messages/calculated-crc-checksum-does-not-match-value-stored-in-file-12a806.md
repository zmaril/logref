---
message: "calculated CRC checksum does not match value stored in file \"%s\""
slug: calculated-crc-checksum-does-not-match-value-stored-in-file-12a806
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATA_CORRUPTED
    code: "XX001"
call_sites:
  - "postgres/src/backend/access/transam/twophase.c:1401"
reproduced: false
---

# `calculated CRC checksum does not match value stored in file "%s"`

## What it means

A file that carries a CRC checksum failed verification: the checksum computed over its contents does not equal the value recorded in the file. The placeholder is the file name. This indicates the file was altered or damaged after it was written.

## When it happens

It occurs when reading a checksummed file such as a backup manifest, a state file, or another CRC-protected artifact that has since been corrupted, truncated, or edited.

## How to fix

Treat the file as untrustworthy. Re-obtain it from its source — re-copy the backup, regenerate the file — and verify the transfer. If it was produced locally and is damaged, storage or hardware problems are worth investigating.

## Example

*Illustrative* — a CRC mismatch on a file.

```text
ERROR:  calculated CRC checksum does not match value stored in file "backup_manifest"
```

## Related

- [byte ordering mismatch](./byte-ordering-mismatch.md)
- [can only reopen input archives](./can-only-reopen-input-archives.md)
