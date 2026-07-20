---
message: "could not receive list of replicated sequences from the publisher: %s"
slug: could-not-receive-list-of-replicated-sequences-from-the-publisher
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONNECTION_FAILURE
    code: "08006"
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:3238"
reproduced: false
---

# `could not receive list of replicated sequences from the publisher: %s`

## What it means

The subscriber asked the publisher for the sequences its publications replicate and the request failed. The server flags this as a connection failure and includes the underlying reply.

## When it happens

It fires while a subscription synchronizes sequence data, when the subscriber's query to the publisher for the replicated-sequence list cannot complete.

## How to fix

Confirm the publisher is up and the replication connection is stable, then retry the operation. Check the publisher's log for a dropped connection and confirm the replication role can read the relevant catalogs. A network interruption mid-request is the common cause.

## Example

*Illustrative* — the sequence list request failed.

```text
ERROR:  could not receive list of replicated sequences from the publisher: server closed the connection unexpectedly
```

## Related

- [could not receive list of publications from the publisher](./could-not-receive-list-of-publications-from-the-publisher.md)
- [could not start initial contents copy for table](./could-not-start-initial-contents-copy-for-table.md)
