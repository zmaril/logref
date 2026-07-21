---
message: "access method \"%s\" already exists"
slug: access-method-already-exists
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/commands/amcmds.c:69"
reproduced: false
---

# `access method "%s" already exists`

## What it means

A `CREATE ACCESS METHOD` named an access method that already exists in the database, and access-method names must be unique.

## When it happens

It occurs when creating an index or table access method whose name is already taken, often because an extension providing it is already installed.

## How to fix

Use a different name, or drop the existing access method first if you mean to replace it. If it comes from an extension, you usually do not need to create it again — check `pg_am` for the existing entry.

## Example

*Illustrative* — recreating an existing access method.

```sql
CREATE ACCESS METHOD bloom TYPE INDEX HANDLER blhandler;  -- already exists
```

## Related

- [access method does not support included columns](./access-method-does-not-support-included-columns.md)
- [aggregate name is not unique](./aggregate-name-is-not-unique.md)
