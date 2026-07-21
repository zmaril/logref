---
message: "cannot set security label on relation \"%s\""
slug: cannot-set-security-label-on-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/seclabel.c:202"
reproduced: false
---

# `cannot set security label on relation "%s"`

## What it means

A `SECURITY LABEL` targeted a relation whose kind does not accept labels. The relation is of a type that cannot carry a security label. The placeholder is the relation name.

## When it happens

It occurs when `SECURITY LABEL ON` names a relation kind the label provider does not support.

## How to fix

Apply security labels only to supported relation kinds for your provider. Consult the provider's documentation (for example sepgsql) for which object types accept labels.

## Example

*Illustrative* — labeling an unsupported relation.

```text
ERROR:  cannot set security label on relation "my_obj"
```

## Related

- [cannot set security label on non-regular columns](./cannot-set-security-label-on-non-regular-columns.md)
- [cannot set security labels on relations except for tables, sequences or views](./cannot-set-security-labels-on-relations-except-for-tables-sequences-or-views.md)
