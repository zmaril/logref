---
message: "wrong pg_constraint entry for trigger \"%s\" on table \"%s\""
slug: wrong-pg-constraint-entry-for-trigger-on-table
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/ri_triggers.c:2393"
  - "postgres/src/backend/utils/adt/ri_triggers.c:2400"
reproduced: false
---

# `wrong pg_constraint entry for trigger "%s" on table "%s"`

## What it means

Internal error, or a corrupt catalog. A trigger claims to implement a constraint, but the matching `pg_constraint` row for that trigger and table could not be found or does not line up.

## When it happens

It fires when constraint-trigger bookkeeping and the constraint catalog disagree — a sign of an inconsistent catalog rather than of ordinary DML.

## How to fix

This is a guard over catalog consistency. If it appears during normal foreign-key or constraint activity, the catalog may be damaged; capture the table and constraint and report it, and check for a prior crash or storage fault.

## Example

*Illustrative* — a mismatched constraint-trigger entry.

```text
ERROR:  wrong pg_constraint entry for trigger "fk_check" on table "orders"
```

## Related

- [unrecognized FK action type: %d](./unrecognized-fk-action-type.md)
- [missing lock for relation "%s" (OID %u, relkind %c) @ TID (%u,%u)](./missing-lock-for-relation-oid-relkind-tid.md)
