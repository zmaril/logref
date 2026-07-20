---
message: "unexpected EOF for tape %p: requested %zu bytes, read %zu bytes"
slug: unexpected-eof-for-tape-requested-bytes-read-bytes
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeAgg.c:3130"
  - "postgres/src/backend/executor/nodeAgg.c:3139"
  - "postgres/src/backend/executor/nodeAgg.c:3151"
reproduced: false
---

# `unexpected EOF for tape %p: requested %zu bytes, read %zu bytes`

## What it means

Internal error. External-sort or hash-aggregate spill code reading from a temporary tape hit end of file before it read the number of bytes it expected. The message reports the requested and actual byte counts. It is a consistency check on spilled temporary data.

## When it happens

It should not occur in normal operation. Reaching it points to truncated or corrupt temporary files, a full or failing temporary tablespace, or an internal inconsistency, rather than to your query's logic.

## How to fix

Check the temporary file storage first: ensure the temporary tablespace or the data directory's temp area has space and healthy disks, since a truncated spill file can produce it. If storage is sound, capture the query and byte counts and report it as a possible internal bug.

## Example

*Illustrative* — a short read from a sort tape.

```text
ERROR:  unexpected EOF for tape 0x...: requested 8192 bytes, read 4096 bytes
```

## Related

- [bogus tuple length in backward scan](./bogus-tuple-length-in-backward-scan.md)
- [could not create temporary file](./could-not-create-temporary-file.md)
