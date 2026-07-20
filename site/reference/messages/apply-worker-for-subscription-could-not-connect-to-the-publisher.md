---
message: "apply worker for subscription \"%s\" could not connect to the publisher: %s"
slug: apply-worker-for-subscription-could-not-connect-to-the-publisher
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONNECTION_FAILURE
    code: "08006"
call_sites:
  - "postgres/src/backend/replication/logical/worker.c:5726"
reproduced: false
---

# `apply worker for subscription "%s" could not connect to the publisher: %s`

## What it means

The logical-replication apply worker for a subscription failed to establish a connection to the publisher, so it cannot receive changes.

## When it happens

It occurs when a subscription's apply worker starts or retries and the connection to the publisher fails — wrong `CONNECTION` string, network or firewall issue, publisher down, or authentication rejected.

## How to fix

Check the publisher connection: verify the subscription's `CONNECTION` details, that the publisher is reachable and accepting replication connections (`pg_hba.conf` with `replication` or database rules), and that the role has the needed privileges. The trailing detail in the message names the specific connection failure; fix that and the worker reconnects automatically.

## Example

*Illustrative* — an apply worker unable to reach the publisher.

```text
ERROR:  apply worker for subscription "s" could not connect to the publisher: connection refused
```

## Related

- [all replication slots are in use](./all-replication-slots-are-in-use.md)
- [stopping the subscriber](./stopping-the-subscriber.md)
