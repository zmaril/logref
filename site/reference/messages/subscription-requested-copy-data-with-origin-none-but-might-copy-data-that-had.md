---
message: "subscription \"%s\" requested copy_data with origin = NONE but might copy data that had a different origin"
slug: subscription-requested-copy-data-with-origin-none-but-might-copy-data-that-had
passthrough: false
api: [ereport]
level: [WARNING]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:3150"
  - "postgres/src/backend/commands/subscriptioncmds.c:3270"
reproduced: false
---

# `subscription "%s" requested copy_data with origin = NONE but might copy data that had a different origin`

## What it means

A subscription asked to copy initial data with `origin = NONE`, which is meant to exclude replicated (forwarded) data, but the publisher may hold rows that originally came from elsewhere, so the copy could still bring in data of a different origin.

## When it happens

It is emitted at WARNING when a subscription is created or refreshed with `origin = none` in a topology where the publisher is itself a subscriber, so origin information cannot be fully honored during the initial copy.

## Is this a problem?

This warns of a potential for duplicated or looped data in bidirectional or cascaded replication. Verify your replication topology, and if you must avoid copying forwarded rows, arrange the initial data load so only locally-originated data is present, or use `copy_data = false` and seed the tables another way.

## Example

*Illustrative* — creating a subscription with origin = none against a cascading publisher.

```sql
CREATE SUBSCRIPTION s CONNECTION '...' PUBLICATION p WITH (origin = none);
-- WARNING:  subscription "s" requested copy_data with origin = NONE but might copy data ...
```

## Related

- [stopping the subscriber](./stopping-the-subscriber.md)
- [apply worker for subscription could not connect to the publisher](./apply-worker-for-subscription-could-not-connect-to-the-publisher.md)
