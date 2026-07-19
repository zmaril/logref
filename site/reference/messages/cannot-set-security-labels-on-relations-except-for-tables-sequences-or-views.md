---
message: "cannot set security labels on relations except for tables, sequences or views"
slug: cannot-set-security-labels-on-relations-except-for-tables-sequences-or-views
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/contrib/sepgsql/relation.c:578"
reproduced: false
---

# `cannot set security labels on relations except for tables, sequences or views`

## What it means

The sepgsql module was asked to label a relation that is not a table, sequence, or view. Under sepgsql, security labels on relations are limited to those three kinds, so any other relation is rejected.

## When it happens

It occurs when a `SECURITY LABEL ON` under sepgsql targets a relation kind outside tables, sequences, and views — for example an index or a composite type.

## How to fix

Label only tables, sequences, or views under sepgsql. Choose one of the supported relation kinds for the security label.

## Example

*Illustrative* — labeling an unsupported relation kind.

```text
ERROR:  cannot set security labels on relations except for tables, sequences or views
```

## Related

- [cannot set security label on relation](./cannot-set-security-label-on-relation.md)
- [cannot set security label on non-regular columns](./cannot-set-security-label-on-non-regular-columns.md)
