---
message: "constraint with OID %u does not exist"
slug: constraint-with-oid-does-not-exist
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:2528"
reproduced: false
---

# `constraint with OID %u does not exist`

## What it means

Internal code looked up a constraint by OID and found none. The referenced constraint OID does not correspond to any row in `pg_constraint`. This is an internal lookup guard.

## When it happens

It fires from object-address resolution or dependency handling when a constraint OID has already been dropped or never existed.

## How to fix

This usually reflects a race with a concurrent drop or an inconsistency rather than a user mistake. Retry the operation; if it persists, inspect the object being processed and check for catalog inconsistency.

## Example

*Illustrative* — a lookup of a missing constraint OID.

```text
ERROR:  constraint with OID 16493 does not exist
```

## Related

- [constraint does not exist](./constraint-does-not-exist.md)
- [constraint is not of a known type](./constraint-is-not-of-a-known-type.md)
