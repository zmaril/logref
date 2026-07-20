---
message: "expected a physical replication slot, got type \"%s\" instead"
slug: expected-a-physical-replication-slot-got-type-instead
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/streamutil.c:543"
reproduced: false
---

# `expected a physical replication slot, got type "%s" instead`

## What it means

`pg_basebackup` (or a related streaming tool) was told to use a replication slot that turned out to be a logical slot, not a physical one. Base backups and physical streaming require a physical slot. The placeholder is the slot's actual type.

## When it happens

It fires when `pg_basebackup --slot` (or `pg_receivewal --slot`) names a slot that exists but was created as a logical replication slot.

## How to fix

Point the tool at a physical replication slot, or create one with `pg_create_physical_replication_slot('name')` (or let `pg_basebackup --create-slot` make it). Logical slots are for logical decoding and cannot back a physical base backup or WAL stream.

## Example

*Illustrative* — the message as logged.

```
expected a physical replication slot, got type "logical" instead
```

## Related

- [expected 0 logical replication slots but found](./expected-0-logical-replication-slots-but-found.md)
- [extended query protocol not supported in a replication connection](./extended-query-protocol-not-supported-in-a-replication-connection.md)
