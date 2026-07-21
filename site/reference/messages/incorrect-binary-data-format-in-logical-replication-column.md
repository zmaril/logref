---
message: "incorrect binary data format in logical replication column %d"
slug: incorrect-binary-data-format-in-logical-replication-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_BINARY_REPRESENTATION
    code: "22P03"
call_sites:
  - "postgres/src/backend/replication/logical/worker.c:1083"
  - "postgres/src/backend/replication/logical/worker.c:1202"
reproduced: false
---

# `incorrect binary data format in logical replication column %d`

## What it means

A logical replication apply worker received a column value in binary format that it could not decode with the column type's binary input function. The placeholder is the column number in the replicated tuple.

## When it happens

It arises on a subscriber whose subscription uses `binary = true` when the publisher and subscriber disagree on a type's binary representation — typically a type version or build mismatch, a custom type whose binary format differs, or an extension type present on one side only.

## How to fix

Recreate or alter the subscription to use text format (`ALTER SUBSCRIPTION ... SET (binary = false)`), which is portable across builds, or make the type definitions match on both sides. Binary transfer requires the exact same on-disk binary format for the type on publisher and subscriber.

## Example

*Illustrative* — a subscription reading a type whose binary format differs from the publisher.

```text
ERROR:  incorrect binary data format in logical replication column 2
```

## Related

- [invalid transaction ID in streamed replication transaction](./invalid-transaction-id-in-streamed-replication-transaction.md)
- [invalid response from primary server](./invalid-response-from-primary-server.md)
