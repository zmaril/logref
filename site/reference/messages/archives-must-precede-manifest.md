---
message: "archives must precede manifest"
slug: archives-must-precede-manifest
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:1345"
reproduced: false
---

# `archives must precede manifest`

## What it means

A tool reading a backup found the manifest before all of the archive members it describes, but the format requires the archives to come first, so the input is out of order or malformed.

## When it happens

It is raised as fatal by tools that read a streamed backup (such as `pg_verifybackup` or a combine step) when the manifest appears ahead of the archive data it summarizes.

## How to fix

This indicates a damaged or improperly assembled backup stream rather than a user command error. Re-take or re-fetch the backup so its members are in the correct order, and verify the transport did not reorder or truncate the stream.

## Example

*Illustrative* — a manifest appearing before its archives.

```text
FATAL:  archives must precede manifest
```

## Related

- [actual file length does not match expected](./actual-file-length-does-not-match-expected.md)
- [archive file already exists](./archive-file-already-exists.md)
