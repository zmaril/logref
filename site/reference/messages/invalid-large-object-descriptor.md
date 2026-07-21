---
message: "invalid large-object descriptor: %d"
slug: invalid-large-object-descriptor
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/libpq/be-fsstubs.c:131"
  - "postgres/src/backend/libpq/be-fsstubs.c:160"
  - "postgres/src/backend/libpq/be-fsstubs.c:188"
  - "postgres/src/backend/libpq/be-fsstubs.c:214"
  - "postgres/src/backend/libpq/be-fsstubs.c:239"
  - "postgres/src/backend/libpq/be-fsstubs.c:281"
  - "postgres/src/backend/libpq/be-fsstubs.c:304"
  - "postgres/src/backend/libpq/be-fsstubs.c:563"
reproduced: true
---

# `invalid large-object descriptor: %d`

## What it means

A large-object function was called with a descriptor (an integer handle from `lo_open`) that is not open in the current transaction. The placeholder is the bad descriptor. Large-object read/write/seek operations require a valid, currently-open descriptor.

## When it happens

Using a large-object descriptor after it was closed, after the transaction that opened it ended, or a descriptor number that was never returned by `lo_open`. Large-object descriptors are transaction-scoped, so reusing one across transactions fails.

## How to fix

Open the large object with `lo_open` inside the same transaction where you read/write it, and use the descriptor it returns. Do not reuse descriptors across transactions or after `lo_close`. Check that the open succeeded and you are passing the right handle.

## Example

*Reproduced* — captured from `reproducers/scenarios/22_system_admin_funcs.sql`.

```sql
SELECT loread(-1, -1);
```

Produces:

```text
ERROR:  invalid large-object descriptor: -1
```

## Related

- [cache lookup failed for relation](./cache-lookup-failed-for-relation-0e5774.md)
- [invalid attribute number](./invalid-attribute-number.md)
