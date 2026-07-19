---
message: "could not fetch column list info for table \"%s.%s\" from publisher: %s"
slug: could-not-fetch-column-list-info-for-table-from-publisher
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONNECTION_FAILURE
    code: "08006"
call_sites:
  - "postgres/src/backend/replication/logical/tablesync.c:835"
reproduced: false
---

# `could not fetch column list info for table "%s.%s" from publisher: %s`

## What it means

A logical-replication table-sync worker could not read the published column list for a table from the publisher. The `%s` values name the table and give the connection error.

## When it happens

It happens during initial table synchronization when the subscriber queries the publisher for a table's replicated columns and the connection or query fails — often a dropped or unstable publisher connection.

## How to fix

Check connectivity to the publisher and the publisher's log for the failing query. Confirm the publication still includes the table and the connecting role has access, then let the sync worker retry.

## Example

*Illustrative* — column-list fetch failing mid-sync.

```text
ERROR:  could not fetch column list info for table "public.orders" from publisher: server closed the connection unexpectedly
```

## Related

- [could not fetch table WHERE clause info for table from publisher](./could-not-fetch-table-where-clause-info-for-table-from-publisher.md)
- [could not fetch sequence information from the publisher](./could-not-fetch-sequence-information-from-the-publisher.md)
