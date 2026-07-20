---
message: "extended query protocol not supported in a replication connection"
slug: extended-query-protocol-not-supported-in-a-replication-connection
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/tcop/postgres.c:5226"
reproduced: false
---

# `extended query protocol not supported in a replication connection`

## What it means

A client opened a replication connection (one started with the `replication` option) and then tried to use the extended query protocol — the Parse/Bind/Execute message flow used for prepared statements and parameterized queries. Replication connections only accept the simple query protocol and replication commands.

## When it happens

It fires when a driver issues a parameterized or prepared query over a connection made for physical or logical replication, rather than using replication commands or simple queries.

## How to fix

Do not run application queries over a replication connection. Use a normal (non-replication) connection for parameterized and prepared statements. On a replication connection, use only replication commands such as `IDENTIFY_SYSTEM`, `START_REPLICATION`, or simple `SELECT` statements without the extended protocol. Some drivers require disabling prepared-statement or parameterized modes for replication connections.

## Example

*Illustrative* — the message as logged.

```
ERROR:  extended query protocol not supported in a replication connection
```

## Related

- [expected a physical replication slot, got type instead](./expected-a-physical-replication-slot-got-type-instead.md)
- [error while shutting down streaming COPY](./error-while-shutting-down-streaming-copy.md)
