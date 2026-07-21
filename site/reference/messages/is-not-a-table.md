---
message: "\"%s\" is not a table"
slug: is-not-a-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/contrib/pgrowlocks/pgrowlocks.c:95"
  - "postgres/src/backend/catalog/objectaddress.c:1475"
  - "postgres/src/backend/commands/policy.c:103"
  - "postgres/src/backend/commands/policy.c:383"
  - "postgres/src/backend/commands/tablecmds.c:2458"
  - "postgres/src/backend/commands/tablecmds.c:15080"
  - "postgres/src/backend/parser/parse_utilcmd.c:3535"
reproduced: true
---

# `"%s" is not a table`

## What it means

An operation that requires an ordinary table was applied to an object that is not one — a view, index, sequence, composite type, or foreign table. The placeholder is the object name. The command only works on plain tables (or a specific relkind) and the target is a different kind.

## When it happens

Applying table-only DDL or a table-only function to a view or other relation — for example a row-level security policy on a view, or an inspection function that requires a heap table given an index. Sometimes a name resolves to an unexpected object kind.

## How to fix

Point the operation at an actual table, or use the command appropriate to the object's kind (for example `CREATE OR REPLACE VIEW` for views). Check the object with `\d name` to see its type. If you expected a table, a name collision or a view of the same name may be the issue.

## Example

*Reproduced* — captured from `reproducers/scenarios/31_createtable_view_trigger.sql`.

```sql
TRUNCATE repro.child_v;
```

Produces:

```text
ERROR:  "child_v" is not a table
```

## Related

- [is not a sequence](./is-not-a-sequence.md)
- [only heap AM is supported](./only-heap-am-is-supported.md)
