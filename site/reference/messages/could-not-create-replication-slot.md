---
message: "could not create replication slot \"%s\": %s"
slug: could-not-create-replication-slot
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/replication/libpqwalreceiver/libpqwalreceiver.c:998"
reproduced: false
---

# `could not create replication slot "%s": %s`

## What it means

A walreceiver could not create the replication slot it requested on the upstream server. The `%s` gives the server's reply. The slot the subscriber or standby needs was not created.

## When it happens

It happens during logical or physical replication setup when the upstream rejects the slot request — for example the slot name is taken, or `max_replication_slots` is exhausted upstream.

## How to fix

Check the attached reply. Raise `max_replication_slots` on the upstream if it is full, or choose a slot name that is not already in use. Confirm the connecting role has replication privileges.

## Example

*Illustrative* — a slot request rejected upstream.

```text
ERROR:  could not create replication slot "sub_slot": ERROR:  all replication slots are in use
```

## Related

- [could not create replication slot: got rows and fields, expected rows and fields](./could-not-create-replication-slot-got-rows-and-fields-expected-rows-and-fields.md)
- [could not copy replication slot](./could-not-copy-replication-slot.md)
