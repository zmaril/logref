---
message: "cannot parse archive \"%s\""
slug: cannot-parse-archive
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:1119"
reproduced: false
---

# `cannot parse archive "%s"`

## What it means

`pg_basebackup` could not parse a server-sent archive stream. The tool received tar data it could not interpret while streaming or reconstructing the backup. The placeholder is the archive name.

## When it happens

It occurs during a base backup when the archive stream is malformed or truncated — often from a network interruption, a protocol mismatch, or a corrupted transfer.

## How to fix

Retry the backup on a stable connection, and confirm the client and server versions are compatible. If it recurs, capture the server log alongside the client error and check for a broken transport or a version mismatch.

## Example

*Illustrative* — an unparseable archive stream.

```text
pg_basebackup: error: cannot parse archive "base.tar"
```

## Related

- [cannot inject manifest into a compressed tar file](./cannot-inject-manifest-into-a-compressed-tar-file.md)
- [cannot restore from compressed archive](./cannot-restore-from-compressed-archive.md)
