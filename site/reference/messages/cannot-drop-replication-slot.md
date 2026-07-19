---
message: "cannot drop replication slot \"%s\""
slug: cannot-drop-replication-slot
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/replication/slot.c:924"
reproduced: false
---

# `cannot drop replication slot "%s"`

## What it means

A `pg_drop_replication_slot` call or equivalent could not drop the named slot because it is in a state that blocks removal — for example it is currently active on a connection. The placeholder is the slot name.

## When it happens

It occurs when dropping a slot that a walsender or subscription is actively using, or that is otherwise not free to be removed.

## How to fix

Disconnect the consumer using the slot — stop the subscription or terminate the walsender — then drop it. A slot can be dropped only when no session holds it active.

## Example

*Illustrative* — dropping an active slot.

```text
ERROR:  cannot drop replication slot "s"
```

## Related

- [cannot copy replication slot](./cannot-copy-replication-slot.md)
- [cannot drop extension because it is being modified](./cannot-drop-extension-because-it-is-being-modified.md)
