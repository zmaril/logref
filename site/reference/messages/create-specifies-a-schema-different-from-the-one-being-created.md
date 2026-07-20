---
message: "CREATE specifies a schema (%s) different from the one being created (%s)"
slug: create-specifies-a-schema-different-from-the-one-being-created
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_SCHEMA_DEFINITION
    code: "42P15"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:4582"
  - "postgres/src/backend/parser/parse_utilcmd.c:4616"
reproduced: false
---

# `CREATE specifies a schema (%s) different from the one being created (%s)`

## What it means

A `CREATE SCHEMA` statement contained a nested object whose explicit schema qualifier names a schema other than the one being created. The two `%s` values are the qualifier and the schema name. The nested object cannot live in a different schema than the enclosing `CREATE SCHEMA`.

## When it happens

Writing `CREATE SCHEMA foo CREATE TABLE bar.t (...)` where `bar` differs from `foo`. All objects inside a `CREATE SCHEMA` must belong to that schema.

## How to fix

Remove the conflicting schema qualifier from the nested object, or leave it unqualified so it inherits the schema being created. Create objects in other schemas with separate statements.

## Example

*Illustrative* — a nested object naming a different schema.

```text
ERROR:  CREATE specifies a schema (bar) different from the one being created (foo)
```

## Related

- [extension does not support SET SCHEMA](./extension-does-not-support-set-schema.md)
- [current user cannot be dropped](./current-user-cannot-be-dropped.md)
