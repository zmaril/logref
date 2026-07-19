---
message: "BEFORE trigger's WHEN condition cannot reference NEW generated columns"
slug: before-trigger-s-when-condition-cannot-reference-new-generated-columns
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/trigger.c:662"
  - "postgres/src/backend/commands/trigger.c:670"
reproduced: false
---

# `BEFORE trigger's WHEN condition cannot reference NEW generated columns`

## What it means

A `BEFORE` trigger's `WHEN` condition referenced a generated column through `NEW`. Generated columns are computed after `BEFORE` triggers run, so their `NEW` values are not yet available to a `BEFORE` trigger's `WHEN` clause.

## When it happens

Creating a `BEFORE INSERT` or `BEFORE UPDATE` trigger whose `WHEN (...)` condition reads a `NEW.generated_column`, since that value has not been computed at that point.

## How to fix

Remove the generated-column reference from the `WHEN` condition. Base the condition on the columns the generated value is derived from, or move the logic into an `AFTER` trigger where the computed value is available. A `BEFORE` trigger cannot see `NEW` generated columns.

## Example

*Illustrative* — a BEFORE trigger reading a generated NEW column.

```sql
CREATE TRIGGER t BEFORE UPDATE ON tbl FOR EACH ROW WHEN (NEW.gcol > 0) EXECUTE FUNCTION f();
```

## Related

- [cannot use generated column in partition key](./cannot-use-generated-column-in-partition-key.md)
- [relation cannot have triggers](./relation-cannot-have-triggers.md)
