---
message: "expected action 'O' or 'K', got %c"
slug: expected-action-o-or-k-got
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/proto.c:572"
reproduced: false
---

# `expected action 'O' or 'K', got %c`

## What it means

An internal guard in logical-replication protocol decoding. Handling an `UPDATE` or `DELETE`, the subscriber expected an old-tuple (`O`) or key (`K`) action byte and read a different byte. The placeholder is the byte it saw.

## When it happens

It fires on a logical-replication subscriber when the byte stream does not match the expected protocol sequence for the old/key tuple of a change, usually a version mismatch or a corrupted or truncated message.

## How to fix

Verify publisher and subscriber versions are compatible and the connection is healthy. Restart the subscription to resynchronize. If it persists between matched versions, capture the details and report it.

## Example

*Illustrative* — the message as logged.

```
ERROR:  expected action 'O' or 'K', got X
```

## Related

- [expected action 'N', got](./expected-action-n-got.md)
- [expected action 'N', 'O' or 'K', got](./expected-action-n-o-or-k-got.md)
