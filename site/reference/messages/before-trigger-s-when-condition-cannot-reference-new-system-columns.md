---
message: "BEFORE trigger's WHEN condition cannot reference NEW system columns"
slug: before-trigger-s-when-condition-cannot-reference-new-system-columns
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/trigger.c:653"
reproduced: false
---

# `BEFORE trigger's WHEN condition cannot reference NEW system columns`

## What it means

A `BEFORE` trigger's `WHEN` condition referenced a system column of the `NEW` row, which is not allowed. System columns of `NEW` are not yet meaningful before the row is inserted or updated.

## When it happens

It occurs at `CREATE TRIGGER` time for a `BEFORE INSERT`/`UPDATE` trigger whose `WHEN (...)` clause reads a `NEW` system column such as `ctid` or `xmin`.

## How to fix

Remove the `NEW` system-column reference from the `WHEN` clause. Reference user columns of `NEW`, or move logic that needs system columns into the trigger function body or an `AFTER` trigger where those values exist.

## Example

*Illustrative* — a NEW system column in a WHEN clause.

```sql
CREATE TRIGGER t BEFORE UPDATE ON x
  FOR EACH ROW WHEN (NEW.ctid IS NOT NULL) EXECUTE FUNCTION f();
```

## Related

- [before_stmt_triggers_fired called outside of query](./before-stmt-triggers-fired-called-outside-of-query.md)
- [both default and generation expression specified for column of table](./both-default-and-generation-expression-specified-for-column-of-table.md)
