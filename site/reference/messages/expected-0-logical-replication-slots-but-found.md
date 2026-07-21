---
message: "expected 0 logical replication slots but found %d"
slug: expected-0-logical-replication-slots-but-found
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/check.c:2104"
reproduced: false
---

# `expected 0 logical replication slots but found %d`

## What it means

`pg_upgrade` checked the old cluster for logical replication slots and found some when it required none. The placeholder is how many it found. Logical slots cannot be carried across an upgrade by the copy of the data directory alone.

## When it happens

It fires during the `pg_upgrade` compatibility check on an old cluster that still has logical replication slots, when the target version or options do not support migrating them.

## How to fix

Drop the logical replication slots on the old cluster before upgrading (`pg_drop_replication_slot()` for each, after confirming no subscriber still needs them), then re-run `pg_upgrade`. Recreate the slots and re-establish subscriptions on the new cluster afterward. On versions that support slot migration, follow that version's documented procedure instead of dropping them.

## Example

*Illustrative* — the message as logged.

```
expected 0 logical replication slots but found 2
```

## Related

- [exiting from slot synchronization because same name slot already exists on the standby](./exiting-from-slot-synchronization-because-same-name-slot-already-exists-on-the.md)
- [expected a physical replication slot, got type instead](./expected-a-physical-replication-slot-got-type-instead.md)
