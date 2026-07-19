---
message: "cannot alter type of a column used in a trigger definition"
slug: cannot-alter-type-of-a-column-used-in-a-trigger-definition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:15699"
reproduced: false
---

# `cannot alter type of a column used in a trigger definition`

## What it means

An `ALTER TABLE ... ALTER COLUMN ... TYPE` was blocked because a trigger definition references the column — for example in a `WHEN` condition or a column list on the trigger. The trigger depends on the column's current type.

## When it happens

It occurs when the column being retyped is named in a trigger's `WHEN` clause or `UPDATE OF` column list.

## How to fix

Drop the trigger, alter the column type, then recreate the trigger against the new type. Postgres does not rewrite trigger conditions when a referenced column changes type.

## Example

*Illustrative* — a column named in a trigger condition.

```text
ERROR:  cannot alter type of a column used in a trigger definition
```

## Related

- [cannot alter type of a column used in a policy definition](./cannot-alter-type-of-a-column-used-in-a-policy-definition.md)
- [cannot alter type of a column used by a generated column](./cannot-alter-type-of-a-column-used-by-a-generated-column.md)
