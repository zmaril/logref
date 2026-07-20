---
message: "relation \"%s\" would be inherited from more than once"
slug: relation-would-be-inherited-from-more-than-once
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_TABLE
    code: "42P07"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:928"
  - "postgres/src/backend/commands/tablecmds.c:18116"
reproduced: false
---

# `relation "%s" would be inherited from more than once`

## What it means

A `CREATE TABLE ... INHERITS (...)` (or a merge of inheritance parents) listed the same parent table more than once, directly or through overlapping ancestry. The placeholder is the relation name. A table cannot inherit from the same parent twice.

## When it happens

It arises when the inheritance list repeats a parent, or when two listed parents share a common ancestor that would be inherited through both paths.

## How to fix

Remove the duplication so each ancestor is inherited exactly once. Drop the repeated parent from the `INHERITS` list, or restructure the hierarchy to avoid the diamond that causes the double inheritance.

## Example

*Illustrative* — inheriting the same parent twice.

```text
ERROR:  relation "base" would be inherited from more than once
```

## Related

- [relation %u has non-inherited constraint "%s"](./relation-has-non-inherited-constraint.md)
- [relation "%s" already exists](./relation-already-exists.md)
