---
message: "allParameterTypes is not a 1-D Oid array"
slug: allparametertypes-is-not-a-1-d-oid-array
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/pg_proc.c:181"
reproduced: false
---

# `allParameterTypes is not a 1-D Oid array`

## What it means

A function's catalog entry stored its `allParameterTypes` field as something other than a one-dimensional array of OIDs, so the parameter-type list could not be read — a catalog-shape guard.

## When it happens

It is raised when reading `pg_proc.proallargtypes` and finding it is not the expected one-dimensional `oid[]`, which points at a corrupted or hand-modified catalog row.

## How to fix

This indicates a damaged or improperly modified system catalog rather than a user query error. Do not modify `pg_proc` directly. Investigate catalog corruption, restore from a known-good backup if needed, and recreate the affected function through normal DDL.

## Example

*Illustrative* — a malformed proallargtypes value.

```text
ERROR:  allParameterTypes is not a 1-D Oid array
```

## Related

- [AllocateDesc kind not recognized](./allocatedesc-kind-not-recognized.md)
- [argument type of FieldStore is not a tuple type](./argument-type-of-fieldstore-is-not-a-tuple-type.md)
