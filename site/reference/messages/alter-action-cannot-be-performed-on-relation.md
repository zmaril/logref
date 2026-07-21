---
message: "ALTER action %s cannot be performed on relation \"%s\""
slug: alter-action-cannot-be-performed-on-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:6908"
reproduced: false
---

# `ALTER action %s cannot be performed on relation "%s"`

## What it means

An `ALTER` sub-command was applied to a relation whose kind does not support that action — for example a table-only change attempted on a view, or an index-only change attempted on a table.

## When it happens

It occurs when an `ALTER TABLE`/`ALTER ...` action is directed at a relation of the wrong kind for that action.

## How to fix

Confirm the relation's kind with `\d` and use the `ALTER` command appropriate to it (`ALTER VIEW`, `ALTER INDEX`, `ALTER MATERIALIZED VIEW`, and so on). Not every sub-command applies to every relation kind; choose one the target supports.

## Example

*Illustrative* — a table-only alter applied to the wrong relation kind.

```text
ERROR:  ALTER action ALTER COLUMN TYPE cannot be performed on relation "v"
```

## Related

- [alter system is not allowed in this environment](./alter-system-is-not-allowed-in-this-environment.md)
- [alter table / drop expression is not supported for virtual generated columns](./alter-table-drop-expression-is-not-supported-for-virtual-generated-columns.md)
