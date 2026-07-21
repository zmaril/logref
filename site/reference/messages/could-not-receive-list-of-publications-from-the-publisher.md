---
message: "could not receive list of publications from the publisher: %s"
slug: could-not-receive-list-of-publications-from-the-publisher
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:593"
reproduced: false
---

# `could not receive list of publications from the publisher: %s`

## What it means

While setting up or refreshing a subscription, the subscriber asked the publisher for its list of publications and did not get a usable answer. The trailing text is the publisher's reply.

## When it happens

It fires during `CREATE SUBSCRIPTION` or `ALTER SUBSCRIPTION ... REFRESH PUBLICATION`, when the subscriber connects to the publisher to validate the named publications and the query fails or the connection drops.

## How to fix

Check the connection string in the subscription and confirm the publisher is reachable and accepting replication connections. Verify the named publications exist on the publisher. Look at the publisher's log for a refused or interrupted connection, and confirm the replication role has the needed privileges.

## Example

*Illustrative* — the publisher's publication list was not received.

```text
ERROR:  could not receive list of publications from the publisher: connection to server was lost
```

## Related

- [could not receive list of replicated sequences from the publisher](./could-not-receive-list-of-replicated-sequences-from-the-publisher.md)
- [could not start initial contents copy for table](./could-not-start-initial-contents-copy-for-table.md)
