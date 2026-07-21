---
message: "could not find file \"%s\" in archive"
slug: could-not-find-file-in-archive
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_tar.c:318"
reproduced: false
---

# `could not find file "%s" in archive`

## What it means

`pg_restore` looked for a named member file inside a tar-format archive and could not find it. The `%s` names the file. The archive does not contain the expected member.

## When it happens

It happens while restoring from a tar-format dump when an expected component is missing, usually because the archive is incomplete or corrupted.

## How to fix

Suspect a damaged or incomplete archive. Verify the tar file's integrity, re-fetch or regenerate the dump, and retry the restore.

## Example

*Illustrative* — a missing member in a tar-format archive.

```text
pg_restore: fatal: could not find file "3456.dat" in archive
```

## Related

- [could not find block ID in archive (possibly corrupt archive)](./could-not-find-block-id-in-archive-possibly-corrupt-archive.md)
- [could not find file](./could-not-find-file.md)
