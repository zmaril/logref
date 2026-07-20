---
message: "could not start initial contents copy for table \"%s.%s\": %s"
slug: could-not-start-initial-contents-copy-for-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONNECTION_FAILURE
    code: "08006"
call_sites:
  - "postgres/src/backend/replication/logical/tablesync.c:1196"
reproduced: false
---

# `could not start initial contents copy for table "%s.%s": %s`

## What it means

A logical replication table synchronization worker could not begin the initial copy of a table's contents from the publisher. The placeholders are the schema and table, and the trailing text is the reason. The server flags this as a connection failure.

## When it happens

It fires while a subscription performs its initial data sync for a table, when the worker's attempt to start the copy from the publisher fails — a broken connection, a publisher problem, or a permissions issue on the source.

## How to fix

Check the subscriber-to-publisher connection and the publisher's log. Confirm the replication role can read the table and that the publisher is up. The worker retries, so a transient network problem may clear on its own; a persistent failure needs the connection or permission cause addressed.

## Example

*Illustrative* — the initial copy could not start.

```text
ERROR:  could not start initial contents copy for table "public.orders": connection to server was lost
```

## Related

- [could not receive list of publications from the publisher](./could-not-receive-list-of-publications-from-the-publisher.md)
- [could not send data to shared-memory queue](./could-not-send-data-to-shared-memory-queue.md)
