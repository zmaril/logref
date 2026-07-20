---
message: "check constraint name \"%s\" appears multiple times but with different expressions"
slug: check-constraint-name-appears-multiple-times-but-with-different-expressions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:3283"
reproduced: false
---

# `check constraint name "%s" appears multiple times but with different expressions`

## What it means

A table definition or an inheritance merge produced two `CHECK` constraints with the same name but different conditions. Constraints that share a name must be identical, so the conflicting definitions are rejected.

## When it happens

It occurs on `CREATE TABLE` with duplicate named checks, or when a child inherits or merges constraints of the same name from parents that define them differently.

## How to fix

Give each distinct check a unique name, or make the same-named checks share one expression. When inheriting, align the parents' constraint definitions so a shared name means a shared condition.

## Example

*Illustrative* — same name, different conditions.

```text
ERROR:  check constraint name "c" appears multiple times but with different expressions
```

## Related

- [check constraint already exists](./check-constraint-already-exists.md)
- [check constraints for domains cannot be marked NO INHERIT](./check-constraints-for-domains-cannot-be-marked-no-inherit.md)
