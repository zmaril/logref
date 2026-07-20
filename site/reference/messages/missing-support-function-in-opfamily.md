---
message: "missing support function %d(%u,%u) in opfamily %u"
slug: missing-support-function-in-opfamily
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/execExpr.c:2107"
  - "postgres/src/backend/executor/nodeIndexscan.c:1387"
  - "postgres/src/backend/executor/nodeMergejoin.c:256"
  - "postgres/src/backend/utils/cache/typcache.c:1044"
  - "postgres/src/backend/utils/sort/sortsupport.c:118"
  - "postgres/src/backend/utils/sort/sortsupport.c:204"
reproduced: false
---

# `missing support function %d(%u,%u) in opfamily %u`

## What it means

The executor needed a specific access-method support function — identified by its support number and the pair of type OIDs — from an operator family, and the family does not provide one. The placeholders are the support number, the left and right type OIDs, and the operator-family OID.

## When it happens

Using an index or an operation that relies on an operator family which is incompletely defined — most often a custom or extension-provided operator class that declares operators but omits a required support function for some type combination.

## How to fix

Locate the operator family named by the OID (`SELECT oid, opfname FROM pg_opfamily WHERE oid = ...`) and add the missing support function with `ALTER OPERATOR FAMILY ... ADD FUNCTION`. If the family comes from an extension, this is an extension bug — report it to its author.

## Example

*Illustrative* — an incomplete operator family used at run time.

```text
ERROR:  missing support function 1(23,23) in opfamily 4033
```

## Related

- [operator family of access method contains function with invalid support number](./operator-family-of-access-method-contains-function-with-invalid-support-number.md)
- [data type has no default operator class for access method](./data-type-has-no-default-operator-class-for-access-method.md)
