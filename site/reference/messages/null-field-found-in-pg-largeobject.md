---
message: "null field found in pg_largeobject"
slug: null-field-found-in-pg-largeobject
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/large_object/inv_api.c:374"
  - "postgres/src/backend/storage/large_object/inv_api.c:496"
  - "postgres/src/backend/storage/large_object/inv_api.c:622"
  - "postgres/src/backend/storage/large_object/inv_api.c:806"
reproduced: false
---

# `null field found in pg_largeobject`

## What it means

Internal error. Reading a large object's data, the server found a NULL in a column of `pg_largeobject` that must never be NULL (the page number or the data bytes). The large-object storage layout guarantees those fields are always set, so a NULL there signals catalog or heap corruption in `pg_largeobject`.

## When it happens

It does not arise from ordinary large-object use. It points to corruption of the `pg_largeobject` table — from hardware faults, a crash with disabled fsync, or direct tampering — rather than to anything in the API call.

## How to fix

Treat it as corruption. Identify the affected large object OID, restore `pg_largeobject` (or the object) from a known-good backup, and run hardware/storage checks. `pg_dump`/`pg_restore` of the large object from backup is the usual recovery. Report reproducible cases that are not explained by storage faults.

## Example

*Illustrative* — corruption surfaced while reading a large object.

```text
ERROR:  null field found in pg_largeobject
```

## Related

- [large object does not exist](./large-object-does-not-exist.md)
- [corrupted line pointer offset size](./corrupted-line-pointer-offset-size-bdc6c1.md)
