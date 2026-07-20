---
message: "cannot set security label on non-regular columns"
slug: cannot-set-security-label-on-non-regular-columns
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/contrib/sepgsql/relation.c:173"
reproduced: false
---

# `cannot set security label on non-regular columns`

## What it means

A `SECURITY LABEL` from the sepgsql module targeted a non-regular column such as a system or dropped column. Security labels apply only to regular user columns, so the target is rejected.

## When it happens

It occurs when a `SECURITY LABEL ON COLUMN` names a system column or another non-regular column under sepgsql.

## How to fix

Apply security labels only to regular user-defined columns. Choose a normal column of the table for the label.

## Example

*Illustrative* — labeling a non-regular column.

```text
ERROR:  cannot set security label on non-regular columns
```

## Related

- [cannot set security label on relation](./cannot-set-security-label-on-relation.md)
- [cannot set security labels on relations except for tables, sequences or views](./cannot-set-security-labels-on-relations-except-for-tables-sequences-or-views.md)
