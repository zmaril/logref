---
message: "invalid response from primary server"
slug: invalid-response-from-primary-server
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/replication/libpqwalreceiver/libpqwalreceiver.c:448"
  - "postgres/src/backend/replication/libpqwalreceiver/libpqwalreceiver.c:762"
reproduced: false
---

# `invalid response from primary server`

## What it means

A standby or a client-side replication consumer received a reply from the primary that does not fit the replication protocol. The exchange cannot continue, so the operation fails.

## When it happens

It arises during streaming replication, `pg_basebackup`, or logical replication setup when the upstream sends something unexpected — often a version mismatch, a connection routed to the wrong server, or a proxy interfering with the replication stream.

## How to fix

Confirm `primary_conninfo` (or the tool's connection) points at a real Postgres primary of a compatible major version, and that no proxy rewrites the replication protocol. Check the primary's log for a matching error, and verify replication is permitted for the role.

## Example

*Illustrative* — an unexpected reply on the replication connection.

```text
ERROR:  invalid response from primary server
```

## Related

- [invalid transaction ID in streamed replication transaction](./invalid-transaction-id-in-streamed-replication-transaction.md)
- [invalid connection string syntax](./invalid-connection-string-syntax.md)
