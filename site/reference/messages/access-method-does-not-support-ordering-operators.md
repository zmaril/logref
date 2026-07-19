---
message: "access method \"%s\" does not support ordering operators"
slug: access-method-does-not-support-ordering-operators
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/opclasscmds.c:1189"
reproduced: false
---

# `access method "%s" does not support ordering operators`

## What it means

An operator class was defined with ordering operators (for nearest-neighbor or distance-ordered scans), but the access method it belongs to cannot use ordering operators.

## When it happens

It occurs in `CREATE OPERATOR CLASS`/`ALTER OPERATOR FAMILY` when `ORDER BY` operators are declared for a method that does not support ordered (KNN-style) scans.

## How to fix

Only declare ordering operators for access methods that support them, such as GiST and SP-GiST for nearest-neighbor search. Remove the ordering-operator members from the operator class for methods that do not implement ordered scans.

## Example

*Illustrative* — ordering operators declared for an unsupported method.

```text
ERROR:  access method "hash" does not support ordering operators
```

## Related

- [access method does not support ASC/DESC options](./access-method-does-not-support-asc-desc-options.md)
- [associated data types must be specified for index support function](./associated-data-types-must-be-specified-for-index-support-function.md)
