---
message: "\"%s\" is a composite type"
slug: is-a-composite-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:1832"
  - "postgres/src/backend/commands/tablecmds.c:16860"
  - "postgres/src/backend/commands/tablecmds.c:20415"
reproduced: true
---

# `"%s" is a composite type`

## What it means

A command expected an ordinary relation or a different object kind, but the named object is a composite type. Composite types describe a row shape and are not valid targets for operations that act on tables, indexes, or other relations.

## When it happens

Applying a command such as `GRANT`, `ALTER TABLE`, or an index or trigger operation to a name that resolves to a standalone composite type rather than a table. It can also arise when a table's implicit row type is used where a table was expected.

## How to fix

Point the command at the correct object kind. If you meant to change the type, use `ALTER TYPE`. If you meant a table, check the name and schema, since a composite type and a table can share neither storage nor the operations that act on stored rows.

## Example

*Reproduced* — captured from `reproducers/scenarios/46_grant_revoke_privtypes.sql`.

```sql
GRANT SELECT ON acl46.ct TO PUBLIC;
```

Produces:

```text
ERROR:  "ct" is a composite type
```

## Related

- [is a table's row type](./is-a-table-s-row-type.md)
- [is not a composite type](./is-not-a-composite-type.md)
