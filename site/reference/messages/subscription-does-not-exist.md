---
message: "subscription \"%s\" does not exist"
slug: subscription-does-not-exist
passthrough: false
api: [elog, ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:1600"
  - "postgres/src/backend/commands/subscriptioncmds.c:2542"
  - "postgres/src/backend/commands/subscriptioncmds.c:2964"
  - "postgres/src/backend/replication/logical/worker.c:6186"
  - "postgres/src/backend/utils/cache/lsyscache.c:4043"
reproduced: false
---

# `subscription "%s" does not exist`

## What it means

A command referenced a logical replication subscription by name that does not exist. The placeholder is the subscription name. Subscriptions live in `pg_subscription`; naming one that was never created or has been dropped produces this.

## When it happens

Running `ALTER SUBSCRIPTION`, `DROP SUBSCRIPTION`, or querying subscription state with a name that is misspelled, belongs to another database, or has already been dropped.

## How to fix

List subscriptions with `\dRs` in psql or `SELECT subname FROM pg_subscription` (subscriptions are per-database — connect to the right one). Correct the name, or use `DROP SUBSCRIPTION IF EXISTS` when a missing subscription should be tolerated.

## Example

*Illustrative* — altering a nonexistent subscription.

```sql
ALTER SUBSCRIPTION missing_sub ENABLE;
```

## Related

- [replication slot does not exist](./replication-slot-does-not-exist.md)
- [server does not exist](./server-does-not-exist.md)
