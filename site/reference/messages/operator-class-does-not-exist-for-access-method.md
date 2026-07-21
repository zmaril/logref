---
message: "operator class \"%s\" does not exist for access method \"%s\""
slug: operator-class-does-not-exist-for-access-method
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:2342"
  - "postgres/src/backend/commands/indexcmds.c:2350"
  - "postgres/src/backend/commands/opclasscmds.c:203"
reproduced: true
---

# `operator class "%s" does not exist for access method "%s"`

## What it means

An index or constraint definition named an operator class that does not exist for the chosen access method. Operator classes are specific to an access method and a data type, and no class by that name is registered for this method.

## When it happens

Creating an index with an explicit `USING method (column opclass)` where the operator-class name is misspelled, belongs to a different access method, or comes from an extension that is not installed.

## How to fix

Use an operator-class name that exists for the access method. List available classes with `\dAc` in psql or query `pg_opclass`, and confirm any extension that provides the class is installed. Omitting the explicit class lets Postgres pick the default class for the column type.

## Example

*Reproduced* — captured from `reproducers/scenarios/29_func_index_extension_ddl.sql`.

```sql
CREATE INDEX ON repro.child USING btree (amount nonexistent_opclass);
```

Produces:

```text
ERROR:  operator class "nonexistent_opclass" does not exist for access method "btree"
```

## Related

- [operator class of access method is missing support function](./operator-class-of-access-method-is-missing-support-function.md)
- [invalid opclass definition](./invalid-opclass-definition.md)
