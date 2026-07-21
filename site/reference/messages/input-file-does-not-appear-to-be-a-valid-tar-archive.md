---
message: "input file does not appear to be a valid tar archive"
slug: input-file-does-not-appear-to-be-a-valid-tar-archive
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:2359"
  - "postgres/src/fe_utils/astreamer_tar.c:300"
reproduced: false
---

# `input file does not appear to be a valid tar archive`

## What it means

A tool that reads a tar-format archive (such as `pg_basebackup` output or a custom-format restore) found data that does not match the tar structure it expected. The file is truncated, not a tar archive, or corrupted.

## When it happens

It arises when restoring or extracting a base backup or archive whose file is damaged, was fetched only partially, was compressed/decompressed incorrectly, or is simply the wrong file.

## How to fix

Confirm you are pointing the tool at the right file and that it transferred completely (compare sizes and checksums against the source). If the archive is compressed, decompress it with the matching tool first. If it is genuinely corrupt, produce a fresh backup.

## Example

*Illustrative* — feeding a non-tar file to a tar reader.

```text
FATAL:  input file does not appear to be a valid tar archive
```

## Related

- [invalid tablespace mapping format must be OLDDIR=NEWDIR](./invalid-tablespace-mapping-format-must-be-olddir-newdir.md)
- [no output directory specified](./no-output-directory-specified.md)
