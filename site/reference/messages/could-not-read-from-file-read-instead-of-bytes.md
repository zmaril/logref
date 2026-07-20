---
message: "could not read from file \"%s\": read %d instead of %d bytes"
slug: could-not-read-from-file-read-instead-of-bytes
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/reorderbuffer.c:5397"
reproduced: false
---

# `could not read from file "%s": read %d instead of %d bytes`

## What it means

Logical decoding read from a spill file — where it stages large in-progress transactions on disk — and received a different number of bytes than expected. The counts show what was read against what was needed. The spill file is not as long as the decoder recorded.

## When it happens

It fires during logical decoding of a large transaction, when a read of a spilled changes file returns the wrong length — usually a truncated or removed spill file, or an I/O problem on the temporary storage.

## How to fix

This points at a damaged or missing decoding spill file. Make sure the storage under the data directory (where logical-decoding temporary files live) is healthy and has free space, and that nothing outside Postgres deletes those files. If it recurs on healthy storage, capture the log and report a reproducible case.

## Example

*Illustrative* — a spill file read returned the wrong length.

```text
ERROR:  could not read from file "pg_replslot/sub/xid-1234.spill": read 512 instead of 8192 bytes
```

## Related

- [could not read from file set: read only of bytes](./could-not-read-from-file-set-read-only-of-bytes.md)
- [could not read from file at offset: read too few bytes](./could-not-read-from-file-at-offset-read-too-few-bytes.md)
