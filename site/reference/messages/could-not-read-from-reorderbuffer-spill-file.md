---
message: "could not read from reorderbuffer spill file: %m"
slug: could-not-read-from-reorderbuffer-spill-file
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/reorderbuffer.c:4626"
  - "postgres/src/backend/replication/logical/reorderbuffer.c:4651"
reproduced: false
---

# `could not read from reorderbuffer spill file: %m`

## What it means

Logical decoding could not read from a reorder-buffer spill file. The `%m` is the operating-system error. Large in-progress transactions spill to these files, and this one could not be read back.

## When it happens

An I/O error on the spill area, or the temp file was removed or the filesystem lost it, while decoding replayed a large transaction. It fires on the publisher side of logical replication.

## How to fix

Read the trailing error and check the spill location (under the data directory's `pg_replslot`) for space and I/O health. Ensure nothing external removes files there. Restart decoding once storage is sound.

## Example

*Illustrative* — an I/O error on a spill file.

```text
ERROR:  could not read from reorderbuffer spill file: Input/output error
```

## Related

- [could not read from reorderbuffer spill file: read instead of bytes](./could-not-read-from-reorderbuffer-spill-file-read-instead-of-bytes.md)
- [could not parse filename](./could-not-parse-filename.md)
