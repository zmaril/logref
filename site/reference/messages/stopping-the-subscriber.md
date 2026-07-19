---
message: "stopping the subscriber"
slug: stopping-the-subscriber
passthrough: false
api: [pg_log_info]
level: [INFO]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:2670"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:2705"
reproduced: false
---

# `stopping the subscriber`

## What it means

The `pg_createsubscriber` tool is shutting down the target server it started, as part of converting a physical standby into a logical subscriber.

## When it happens

It is printed at INFO during the tool's workflow, between the steps where it configures the target and hands it back in its final state.

## Is this a problem?

This is normal progress output from `pg_createsubscriber`, not a problem. No action is needed. If the tool fails, the error that follows is the thing to investigate.

## Example

*Illustrative* — the tool stopping its target mid-conversion.

```text
INFO:  stopping the subscriber
```

## Related

- [subscription requested copy_data with origin = NONE](./subscription-requested-copy-data-with-origin-none-but-might-copy-data-that-had.md)
- [apply worker for subscription could not connect to the publisher](./apply-worker-for-subscription-could-not-connect-to-the-publisher.md)
