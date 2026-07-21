---
message: "cannot update column \"%s\" because it is used in FOR PORTION OF"
slug: cannot-update-column-because-it-is-used-in-for-portion-of
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/analyze.c:2996"
reproduced: false
---

# `cannot update column "%s" because it is used in FOR PORTION OF`

## What it means

An `UPDATE ... FOR PORTION OF` statement also tried to set the column that names the application-time period range. That column defines the portion being updated, so it cannot be assigned a new value in the same statement.

## When it happens

It occurs with temporal `UPDATE ... FOR PORTION OF period_column FROM ... TO ...` when the `SET` list includes the period column itself.

## How to fix

Remove the period column from the `SET` list. Let `FOR PORTION OF` control the time range and update only the other columns.

## Example

*Illustrative* — assigning the FOR PORTION OF column.

```sql
UPDATE t FOR PORTION OF valid_at FROM d1 TO d2 SET valid_at = ...;
-- ERROR:  cannot update column "valid_at" because it is used in FOR PORTION OF
```

## Related

- [cannot use generated column in FOR PORTION OF](./cannot-use-generated-column-in-for-portion-of.md)
- [cannot use system column in MERGE WHEN condition](./cannot-use-system-column-in-merge-when-condition.md)
