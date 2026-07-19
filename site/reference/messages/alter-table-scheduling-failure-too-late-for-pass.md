---
message: "ALTER TABLE scheduling failure: too late for pass %d"
slug: alter-table-scheduling-failure-too-late-for-pass
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:5922"
reproduced: false
---

# `ALTER TABLE scheduling failure: too late for pass %d`

## What it means

The internal `ALTER TABLE` scheduler was asked to add work to an execution pass that had already run, which its ordering rules do not permit — an internal consistency guard.

## When it happens

It is raised while executing a multi-pass `ALTER TABLE` if a sub-command tries to enqueue work for an earlier phase than the one in progress, normally only through a bug.

## How to fix

This is an internal error rather than a user SQL fault. If you hit it, capture the full `ALTER TABLE` statement and report it; breaking the statement into separate simpler `ALTER` commands may avoid the path meanwhile.

## Example

*Illustrative* — work enqueued for a pass that already ran.

```text
ERROR:  ALTER TABLE scheduling failure: too late for pass 1
```

## Related

- [ALTER TABLE scheduling failure: bogus item for pass](./alter-table-scheduling-failure-bogus-item-for-pass.md)
- [alter action cannot be performed on relation](./alter-action-cannot-be-performed-on-relation.md)
