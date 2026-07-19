---
message: "could not fetch table info for table \"%s.%s\" from publisher: %s"
slug: could-not-fetch-table-info-for-table-from-publisher
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONNECTION_FAILURE
    code: "08006"
call_sites:
  - "postgres/src/backend/replication/logical/tablesync.c:757"
  - "postgres/src/backend/replication/logical/tablesync.c:916"
reproduced: false
---

# `could not fetch table info for table "%s.%s" from publisher: %s`

## What it means

A logical-replication subscriber could not retrieve schema information for a table from the publisher. The placeholders are the schema-qualified table and the underlying reason. Table synchronization needs the publisher's column and key metadata, and that query failed.

## When it happens

Starting or refreshing a subscription's table sync when the publisher connection drops, the table is missing or not in the publication on the publisher, or privileges are insufficient.

## How to fix

Check the detail for the cause. Ensure the publisher is reachable, the table exists there and is part of the publication, and the subscription's role can read its metadata. Fix the connectivity, publication membership, or privilege issue, then let the sync retry.

## Example

*Illustrative* — a subscriber unable to read table info.

```text
ERROR:  could not fetch table info for table "public.orders" from publisher: ERROR:  permission denied for table orders
```

## Related

- [could not drop replication slot on publisher](./could-not-drop-replication-slot-on-publisher.md)
- [could not connect to database](./could-not-connect-to-database-ec9b7c.md)
