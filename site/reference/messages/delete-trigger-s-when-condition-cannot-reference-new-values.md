---
message: "DELETE trigger's WHEN condition cannot reference NEW values"
slug: delete-trigger-s-when-condition-cannot-reference-new-values
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/trigger.c:648"
reproduced: false
---

# `DELETE trigger's WHEN condition cannot reference NEW values`

## What it means

A trigger's `WHEN` condition referenced `NEW` on a trigger fired by `DELETE`. A `DELETE` has no new row, so `NEW` is meaningless there. Only `OLD` is available for a delete trigger.

## When it happens

It fires from `CREATE TRIGGER` when the `WHEN (...)` clause of a trigger listening for `DELETE` mentions a `NEW.*` column.

## How to fix

Reference only `OLD` in the `WHEN` condition of a `DELETE` trigger. If you need to test the new row, the trigger must fire on `INSERT` or `UPDATE`. Split the trigger by event if it must handle deletes and updates differently.

## Example

*Illustrative* — `NEW` in a `DELETE` trigger condition.

```sql
CREATE TRIGGER trg BEFORE DELETE ON t
  FOR EACH ROW WHEN (NEW.x > 0) EXECUTE FUNCTION f();
-- DELETE trigger's WHEN condition cannot reference NEW values
```

## Related

- [DO ALSO rules are not supported for COPY](./do-also-rules-are-not-supported-for-copy.md)
- [DEFAULT is not allowed in this context](./default-is-not-allowed-in-this-context.md)
