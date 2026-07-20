---
message: "could not alter replication slot \"%s\": %s"
slug: could-not-alter-replication-slot
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/replication/libpqwalreceiver/libpqwalreceiver.c:1050"
reproduced: false
---

# `could not alter replication slot "%s": %s`

## What it means

A walreceiver's attempt to alter a replication slot on the upstream server failed. The message includes the upstream reason. The slot could not be reconfigured, so the operation does not proceed.

## When it happens

It happens on a subscriber or standby when `ALTER_REPLICATION_SLOT` sent to the publisher fails, for example due to an incompatible upstream version or a slot that is in use or missing.

## How to fix

Read the upstream reason in the message. Verify the slot exists and is not in conflicting use, and that the publisher version supports the alteration requested. Correct the slot state on the upstream server and retry.

## Example

*Illustrative* — a failed replication-slot alteration.

```text
ERROR:  could not alter replication slot "sub1": ...
```

## Related

- [consider renaming this publication before continuing](./consider-renaming-this-publication-before-continuing.md)
- [connection to database failed](./connection-to-database-failed-ed5fa7.md)
