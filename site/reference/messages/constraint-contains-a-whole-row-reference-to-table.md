---
message: "Constraint \"%s\" contains a whole-row reference to table \"%s\"."
slug: constraint-contains-a-whole-row-reference-to-table
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:23113"
reproduced: false
---

# `Constraint "%s" contains a whole-row reference to table "%s".`

## What it means

A constraint definition referenced a whole-row value of a table (the table name used as a value) in a context where that is not allowed. This detail message accompanies an internal check on constraint expressions.

## When it happens

It fires during table processing when a check or other constraint expression contains a whole-row reference that the operation cannot handle.

## How to fix

Rewrite the constraint to reference specific columns instead of the whole row. Whole-row references in constraints are not supported here; list the columns you actually need.

## Example

*Illustrative* — a constraint using a whole-row reference.

```text
DETAIL:  Constraint "chk" contains a whole-row reference to table "t".
```

## Related

- [constraints cannot have index expressions](./constraints-cannot-have-index-expressions.md)
- [constraint must be PRIMARY, UNIQUE or EXCLUDE](./constraint-must-be-primary-unique-or-exclude.md)
