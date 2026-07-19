---
message: "relation with OID %u does not exist"
slug: relation-with-oid-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_TABLE
    code: "42P01"
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:3269"
  - "postgres/src/backend/catalog/aclchk.c:3332"
  - "postgres/src/backend/catalog/aclchk.c:4011"
reproduced: false
---

# `relation with OID %u does not exist`

## What it means

Code referenced a relation by its object identifier, and no relation with that identifier exists. Unlike a name lookup, this comes from an internal or catalog-level reference that carries the numeric identifier directly.

## When it happens

A relation was dropped concurrently while another session held a reference to its identifier, or a catalog or privilege operation referenced a stale relation identifier. It can surface during access-control checks or dependency processing on an object that vanished.

## How to fix

Usually the referenced relation was dropped out from under the operation; retry after refreshing whatever produced the identifier. If it recurs for a stable object, it may indicate catalog inconsistency worth investigating, but the common case is a concurrently dropped relation.

## Example

*Illustrative* — a reference to a dropped relation's identifier.

```text
ERROR:  relation with OID 16472 does not exist
```

## Related

- [attribute of relation does not exist](./attribute-of-relation-does-not-exist.md)
- [attribute of relation with oid does not exist](./attribute-of-relation-with-oid-does-not-exist.md)
