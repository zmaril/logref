---
message: "attribute %d of relation with OID %u does not exist"
slug: attribute-of-relation-with-oid-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_COLUMN
    code: "42703"
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:3212"
  - "postgres/src/backend/catalog/aclchk.c:3231"
reproduced: false
---

# `attribute %d of relation with OID %u does not exist`

## What it means

Code referenced a column by attribute number on a relation identified by its object identifier, and that relation has no such column. The reference carries the numeric identifiers directly, so it comes from a catalog-level or privilege operation rather than a name lookup.

## When it happens

A column was dropped concurrently while another operation referenced it by number, or a privilege or dependency operation referenced a stale attribute of a relation. It can surface during access-control checks on a column that no longer exists.

## How to fix

Usually the referenced column was dropped out from under the operation; retry after refreshing whatever produced the reference. If it recurs for a stable column, it may point to catalog inconsistency worth investigating, but the common case is a concurrently dropped column.

## Example

*Illustrative* — a reference to a dropped column by number.

```text
ERROR:  attribute 3 of relation with OID 16472 does not exist
```

## Related

- [relation with oid does not exist](./relation-with-oid-does-not-exist.md)
- [attribute has wrong type](./attribute-has-wrong-type.md)
