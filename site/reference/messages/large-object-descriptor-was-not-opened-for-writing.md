---
message: "large object descriptor %d was not opened for writing"
slug: large-object-descriptor-was-not-opened-for-writing
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/libpq/be-fsstubs.c:195"
  - "postgres/src/backend/libpq/be-fsstubs.c:570"
reproduced: false
---

# `large object descriptor %d was not opened for writing`

## What it means

A write to a large object was attempted through a descriptor that was opened read-only. The placeholder is the descriptor number. Writing requires the descriptor to have been opened with write mode.

## When it happens

It arises from `lo_write`/`lo_truncate` (or the `loread`/`lowrite` layer) when the large object was opened with `lo_open(oid, INV_READ)` instead of including `INV_WRITE`.

## How to fix

Open the large object with write access — pass a mode that includes `INV_WRITE` (for read/write, `INV_READ | INV_WRITE`, the value `0x60000`) to `lo_open` before writing. Reopen the object with the correct mode.

## Example

*Illustrative* — writing through a read-only descriptor.

```sql
SELECT lowrite(lo_open(16385, 262144), 'x');  -- opened read-only
```

## Related

- [invalid OID for large object](./invalid-oid-for-large-object-a856c1.md)
- [must be owner of large object](./must-be-owner-of-large-object.md)
