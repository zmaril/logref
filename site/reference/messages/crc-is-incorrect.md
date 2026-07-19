---
message: "%s: CRC is incorrect"
slug: crc-is-incorrect
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:636"
reproduced: false
---

# `%s: CRC is incorrect`

## What it means

`pg_combinebackup` found that a file's stored checksum did not match its computed one. The leading placeholder is the file. A mismatched CRC means the file's contents differ from what the manifest recorded.

## When it happens

It fires while `pg_combinebackup` verifies the input backups it is combining, when a file fails its checksum — a corrupted or altered backup file.

## How to fix

Treat the input backup as damaged. Re-take or re-copy the affected backup from a trustworthy source, since a CRC mismatch means the data does not match its manifest. Do not combine backups that fail verification; the result would be unreliable.

## Example

*Illustrative* — a backup file failed its checksum.

```text
pg_combinebackup: error: "base/1/1259": CRC is incorrect
```

## Related

- [could not write file, wrote N of M (manifest)](./could-not-write-file-wrote-of-fb0408.md)
- [data type checks failed](./data-type-checks-failed.md)
