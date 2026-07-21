---
message: "could not fetch table WHERE clause info for table \"%s.%s\" from publisher: %s"
slug: could-not-fetch-table-where-clause-info-for-table-from-publisher
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/tablesync.c:1029"
reproduced: false
---

# `could not fetch table WHERE clause info for table "%s.%s" from publisher: %s`

## What it means

A logical-replication table-sync worker could not read a table's row-filter `WHERE` clause from the publisher. The `%s` values name the table and give the connection error.

## When it happens

It happens during initial table synchronization when the subscriber queries the publisher for a table's publication row filter and the connection or query fails.

## How to fix

Check connectivity to the publisher and its log for the failing query, and confirm the publication still includes the table. Let the sync worker retry once the publisher is reachable.

## Example

*Illustrative* — row-filter fetch failing mid-sync.

```text
ERROR:  could not fetch table WHERE clause info for table "public.orders" from publisher: server closed the connection unexpectedly
```

## Related

- [could not fetch column list info for table from publisher](./could-not-fetch-column-list-info-for-table-from-publisher.md)
- [could not fetch sequence information from the publisher](./could-not-fetch-sequence-information-from-the-publisher.md)
