---
message: "access method \"%s\" does not exist"
slug: access-method-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/amcmds.c:152"
  - "postgres/src/backend/commands/indexcmds.c:235"
  - "postgres/src/backend/commands/indexcmds.c:871"
  - "postgres/src/backend/commands/opclasscmds.c:374"
  - "postgres/src/backend/commands/opclasscmds.c:851"
reproduced: false
---

# `access method "%s" does not exist`

## What it means

A command referred to an access method by name that is not registered in `pg_am`. The placeholder is the name. Access methods (index types like `btree`, `gin`, or table AMs like `heap`) must exist before they can be used.

## When it happens

Running `CREATE INDEX ... USING foo`, `CREATE TABLE ... USING foo`, or `ALTER OPERATOR FAMILY ... USING foo` with an access-method name that is misspelled, belongs to an extension that is not installed, or was dropped.

## How to fix

List available access methods with `SELECT amname FROM pg_am`. Correct the name, or install the extension that provides it (for example `CREATE EXTENSION bloom` for the `bloom` index AM) before using it.

## Example

*Illustrative* — an index on a missing access method.

```sql
CREATE INDEX ON t USING bloom (a);  -- without the bloom extension
```

## Related

- [tablespace does not exist](./tablespace-does-not-exist.md)
- [data type has no default operator class for access method](./data-type-has-no-default-operator-class-for-access-method.md)
