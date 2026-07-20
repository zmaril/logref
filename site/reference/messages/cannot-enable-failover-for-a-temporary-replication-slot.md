---
message: "cannot enable failover for a temporary replication slot"
slug: cannot-enable-failover-for-a-temporary-replication-slot
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/replication/slot.c:418"
  - "postgres/src/backend/replication/slot.c:992"
reproduced: false
---

# `cannot enable failover for a temporary replication slot`

## What it means

A command tried to set the failover property on a temporary replication slot. The failover feature keeps a slot available after a standby is promoted, which only makes sense for a persistent slot; temporary slots vanish at session end and cannot participate.

## When it happens

Creating or altering a temporary replication slot with `failover = true`, or enabling failover on a slot that was created as temporary.

## How to fix

Create the slot as persistent (not temporary) if it needs the failover property. Failover slots must survive beyond a single session, so drop the temporary attribute when you need failover behavior.

## Example

*Illustrative* — failover on a temporary slot.

```text
ERROR:  cannot enable failover for a temporary replication slot
```

## Related

- [cannot use physical replication slot for logical decoding](./cannot-use-physical-replication-slot-for-logical-decoding.md)
- [cannot perform logical decoding without an acquired slot](./cannot-perform-logical-decoding-without-an-acquired-slot.md)
