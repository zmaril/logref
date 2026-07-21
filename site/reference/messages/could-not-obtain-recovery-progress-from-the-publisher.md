---
message: "could not obtain recovery progress from the publisher: %s"
slug: could-not-obtain-recovery-progress-from-the-publisher
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONNECTION_FAILURE
    code: "08006"
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:3312"
reproduced: false
---

# `could not obtain recovery progress from the publisher: %s`

## What it means

While creating a subscription with a slot-synchronization or copy step, the subscriber asked the publisher for its recovery progress and the connection or query failed. Without it the subscriber cannot confirm where to begin.

## When it happens

It happens on the subscriber during subscription setup, when the connection to the publisher fails while reading recovery progress — usually a network problem, wrong connection string, or a publisher that is unreachable.

## How to fix

Check the subscription's `CONNECTION` string and that the publisher is reachable and accepting the replication connection. Fix the connectivity or credentials and retry the subscription operation.

## Example

*Illustrative* — the subscriber could not reach the publisher.

```text
ERROR:  could not obtain recovery progress from the publisher: connection to server failed
```

## Related

- [could not obtain recovery progress](./could-not-obtain-recovery-progress.md)
- [could not obtain publisher settings](./could-not-obtain-publisher-settings.md)
