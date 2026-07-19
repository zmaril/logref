---
message: "undefined file type for \"%s\""
slug: undefined-file-type-for
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/file_ops.c:153"
  - "postgres/src/bin/pg_rewind/file_ops.c:180"
reproduced: false
---

# `undefined file type for "%s"`

## What it means

Internal/administrative error. While handling a file, code encountered a directory entry whose type it does not recognize or handle. The placeholder is the path. It usually concerns backup/restore or file-copy routines that only handle regular files and directories.

## When it happens

It fires from server or tool code (for example base-backup file handling) when a filesystem entry is neither a regular file nor a directory it knows how to process — a special file, socket, or device where it did not expect one.

## How to fix

Investigate the named path: something unexpected exists in a directory the server manages or backs up. Remove or relocate the stray special file, and ensure only normal files/directories live under the data or tablespace directories.

## Example

*Illustrative* — an unrecognized filesystem entry during backup.

```text
FATAL:  undefined file type for "/var/lib/pgsql/data/oddfile"
```

## Related

- [tar member has unsafe path name: "%s"](./tar-member-has-unsafe-path-name.md)
- [program "%s" failed](./program-failed.md)
