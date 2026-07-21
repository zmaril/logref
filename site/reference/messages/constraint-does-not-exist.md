---
message: "constraint \"%s\" does not exist"
slug: constraint-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/trigger.c:5994"
reproduced: false
---

# `constraint "%s" does not exist`

## What it means

A statement referenced a constraint by name that the target table does not have. The named constraint could not be found.

## When it happens

It happens on `ALTER TABLE ... DROP CONSTRAINT`, trigger management, or similar commands that name a constraint which is misspelled, already dropped, or on a different table.

## How to fix

Use the correct constraint name, or add `IF EXISTS` where supported to make a drop a no-op. List the table's constraints with `\d table` to find the right name.

## Example

*Illustrative* — dropping a nonexistent constraint.

```sql
ALTER TABLE t DROP CONSTRAINT missing_chk;
-- ERROR:  constraint "missing_chk" does not exist
```

## Related

- [constraint of relation is not a foreign key constraint](./constraint-of-relation-is-not-a-foreign-key-constraint.md)
- [constraint with OID does not exist](./constraint-with-oid-does-not-exist.md)
