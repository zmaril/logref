---
message: "invalid transaction ID in streamed replication transaction"
slug: invalid-transaction-id-in-streamed-replication-transaction
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/replication/logical/worker.c:814"
  - "postgres/src/backend/replication/logical/worker.c:1766"
reproduced: false
---

# `invalid transaction ID in streamed replication transaction`

## What it means

During streaming of a large in-progress transaction over logical replication, the apply side received a transaction id that does not match the streamed transaction it is assembling. The protocol expectation is violated, so apply stops.

## When it happens

It arises on a logical replication subscriber applying streamed (spilled) transactions when the stream's transaction id is out of sequence — usually a protocol mismatch, a version difference, or a corrupted replication stream.

## How to fix

Check that publisher and subscriber major versions are compatible for streaming logical replication, and review both servers' logs for the underlying cause. If the stream is corrupted, the subscription may need to be dropped and recreated to resynchronize.

## Example

*Illustrative* — an out-of-sequence xid in a streamed transaction.

```text
ERROR:  invalid transaction ID in streamed replication transaction
```

## Related

- [invalid response from primary server](./invalid-response-from-primary-server.md)
- [incorrect binary data format in logical replication column](./incorrect-binary-data-format-in-logical-replication-column.md)
