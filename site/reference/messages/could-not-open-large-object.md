---
message: "could not open large object %u: %s"
slug: could-not-open-large-object
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:1528"
  - "postgres/src/bin/pg_dump/pg_dump.c:4158"
reproduced: false
---

# `could not open large object %u: %s`

## What it means

`pg_dump` could not open a large object it needed to dump. The `%u` is the large object's OID and the `%s` is the server error. The dump cannot include that object's data.

## When it happens

The large object was removed concurrently with the dump, or the dumping role lost access to it. It fires while `pg_dump` streams large-object contents.

## How to fix

Read the server error. If large objects are being modified during the dump, run against a quiescent source or a snapshot. Confirm the dumping role can read the large objects.

## Example

*Illustrative* — a large object dropped during the dump.

```text
pg_dump: error: could not open large object 24576: ERROR:  large object 24576 does not exist
```

## Related

- [could not find tuple for large object](./could-not-find-tuple-for-large-object.md)
- [could not open input file](./could-not-open-input-file-d824fe.md)
