---
message: "could not fetch sequence information from the publisher: %s"
slug: could-not-fetch-sequence-information-from-the-publisher
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONNECTION_FAILURE
    code: "08006"
call_sites:
  - "postgres/src/backend/replication/logical/sequencesync.c:531"
reproduced: false
---

# `could not fetch sequence information from the publisher: %s`

## What it means

A logical-replication worker could not read sequence information from the publisher. The `%s` gives the connection error. The subscriber could not learn the published sequence state.

## When it happens

It happens during sequence synchronization for a subscription when the query to the publisher fails, usually from a dropped or unstable publisher connection.

## How to fix

Check connectivity to the publisher and its log. Confirm the publication includes the sequences and the connecting role has access, then let the worker retry.

## Example

*Illustrative* — sequence-info fetch failing.

```text
ERROR:  could not fetch sequence information from the publisher: server closed the connection unexpectedly
```

## Related

- [could not fetch column list info for table from publisher](./could-not-fetch-column-list-info-for-table-from-publisher.md)
- [could not fetch table WHERE clause info for table from publisher](./could-not-fetch-table-where-clause-info-for-table-from-publisher.md)
