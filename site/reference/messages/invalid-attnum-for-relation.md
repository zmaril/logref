---
message: "invalid attnum %d for relation \"%s\""
slug: invalid-attnum-for-relation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/ruleutils.c:8297"
  - "postgres/src/backend/utils/adt/ruleutils.c:8360"
reproduced: false
---

# `invalid attnum %d for relation "%s"`

## What it means

Internal error. An attribute number does not correspond to a real column of the named relation. The placeholders are the attribute number and the relation name.

## When it happens

It fires from catalog and planner code that resolves a column position against a specific relation and finds it out of range. Ordinary queries do not surface it; it points to stale metadata or an internal inconsistency.

## How to fix

This is a can't-happen guard. If it coincides with concurrent `ALTER TABLE` that added or dropped columns, retry. If it recurs, capture the statement and the relation's `\d+` output and report a reproducible case.

## Example

*Illustrative* — a column position outside a relation's columns.

```text
ERROR:  invalid attnum 12 for relation "my_table"
```

## Related

- [invalid attnum](./invalid-attnum.md)
- [invalid column number](./invalid-column-number.md)
