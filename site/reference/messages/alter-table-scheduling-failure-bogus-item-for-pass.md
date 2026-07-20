---
message: "ALTER TABLE scheduling failure: bogus item for pass %d"
slug: alter-table-scheduling-failure-bogus-item-for-pass
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:5942"
reproduced: false
---

# `ALTER TABLE scheduling failure: bogus item for pass %d`

## What it means

The internal machinery that orders `ALTER TABLE` sub-commands into execution passes found a work item assigned to a pass it does not belong in, an internal scheduling consistency guard.

## When it happens

It is raised while planning the multi-pass execution of a complex `ALTER TABLE` if a sub-command is mis-tagged for a phase, normally only reachable through a bug.

## How to fix

This is an internal error, not a user-fixable SQL condition. If it appears, capture the exact `ALTER TABLE` statement and report it; splitting the statement into simpler separate `ALTER` commands may avoid the path in the meantime.

## Example

*Illustrative* — a mis-scheduled ALTER TABLE sub-command.

```text
ERROR:  ALTER TABLE scheduling failure: bogus item for pass 2
```

## Related

- [ALTER TABLE scheduling failure: too late for pass](./alter-table-scheduling-failure-too-late-for-pass.md)
- [alter action cannot be performed on relation](./alter-action-cannot-be-performed-on-relation.md)
