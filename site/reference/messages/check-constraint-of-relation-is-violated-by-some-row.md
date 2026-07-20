---
message: "check constraint \"%s\" of relation \"%s\" is violated by some row"
slug: check-constraint-of-relation-is-violated-by-some-row
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CHECK_VIOLATION
    code: "23514"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:6614"
  - "postgres/src/backend/commands/tablecmds.c:22930"
reproduced: false
---

# `check constraint "%s" of relation "%s" is violated by some row`

## What it means

Adding or validating a `CHECK` constraint failed because at least one existing row does not satisfy it. The placeholders are the constraint name and the relation. Postgres scanned the table and found data that the new constraint would reject.

## When it happens

`ALTER TABLE ... ADD CONSTRAINT ... CHECK (...)`, or `VALIDATE CONSTRAINT` on a previously `NOT VALID` check constraint, against a table that already holds rows breaking the condition.

## How to fix

Find and fix the offending rows before adding the constraint — run the check predicate as a `SELECT ... WHERE NOT (condition)` to list them, then correct or delete them. Alternatively add the constraint as `NOT VALID` to enforce it going forward, and clean up the historical rows before validating.

## Example

*Illustrative* — existing rows violate a new check.

```sql
ALTER TABLE t ADD CONSTRAINT positive CHECK (qty > 0);
-- ERROR:  check constraint "positive" of relation "t" is violated by some row
```

## Related

- [column of relation contains null values](./column-of-relation-contains-null-values.md)
- [child table has different definition for check constraint](./child-table-has-different-definition-for-check-constraint.md)
