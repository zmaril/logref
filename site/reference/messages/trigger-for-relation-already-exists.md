---
message: "trigger \"%s\" for relation \"%s\" already exists"
slug: trigger-for-relation-already-exists
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/commands/trigger.c:778"
  - "postgres/src/backend/commands/trigger.c:1638"
reproduced: false
---

# `trigger "%s" for relation "%s" already exists`

## What it means

A `CREATE TRIGGER` named a trigger that already exists on the target relation. The placeholders are the trigger name and the relation. Trigger names must be unique per relation.

## When it happens

It arises when creating a trigger whose name is already used on that table — a re-run migration, or a naming collision.

## How to fix

Use a different trigger name, or replace the existing one with `CREATE OR REPLACE TRIGGER` (where supported). Drop the old trigger with `DROP TRIGGER name ON relation` first if redefining it, and guard migrations against re-creating it.

## Example

*Illustrative* — creating a trigger that already exists.

```text
ERROR:  trigger "audit_ins" for relation "orders" already exists
```

## Related

- [rule "%s" for relation "%s" already exists](./rule-for-relation-already-exists.md)
- [policy "%s" for table "%s" already exists](./policy-for-table-already-exists.md)
