---
message: "statement trigger's WHEN condition cannot reference column values"
slug: statement-trigger-s-when-condition-cannot-reference-column-values
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/trigger.c:630"
  - "postgres/src/backend/commands/trigger.c:643"
reproduced: false
---

# `statement trigger's WHEN condition cannot reference column values`

## What it means

A statement-level trigger was defined with a `WHEN` condition that references column values (`OLD.col`/`NEW.col`). Statement-level triggers fire once per statement, not per row, so there are no individual row values for the condition to reference.

## When it happens

It arises from `CREATE TRIGGER ... FOR EACH STATEMENT ... WHEN (...)` whose condition uses `OLD`/`NEW` column references that only make sense for row-level triggers.

## How to fix

Remove column references from a statement trigger's `WHEN`, or make the trigger `FOR EACH ROW` if it genuinely needs per-row values. A statement trigger's `WHEN` may only use expressions that do not depend on individual rows.

## Example

*Illustrative* — a statement trigger WHEN using NEW.col.

```text
ERROR:  statement trigger's WHEN condition cannot reference column values
```

## Related

- [trigger "%s" for relation "%s" already exists](./trigger-for-relation-already-exists.md)
- [relation "%s" cannot have rules](./relation-cannot-have-rules.md)
