---
message: "archive file \"%s\" already exists"
slug: archive-file-already-exists
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/contrib/basic_archive/basic_archive.c:178"
reproduced: false
---

# `archive file "%s" already exists`

## What it means

A tool tried to create an archive file at a path where a file of that name already exists, and it will not overwrite it.

## When it happens

It occurs with tools such as `pg_dump` (writing an archive) or during WAL archiving when the destination file is already present.

## How to fix

Choose a different output path, remove or rename the existing file if it is safe to do so, or let the tool write to a fresh location. For WAL archiving, an already-existing target usually means a previous archive attempt or a misconfigured `archive_command`; ensure the command does not overwrite and returns success only when the file is safely stored.

## Example

*Illustrative* — writing over an existing archive file.

```text
ERROR:  archive file "backup.dump" already exists
```

## Related

- [archive location does not exist](./archive-location-does-not-exist.md)
- [archives must precede manifest](./archives-must-precede-manifest.md)
