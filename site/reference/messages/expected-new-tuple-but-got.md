---
message: "expected new tuple but got %d"
slug: expected-new-tuple-but-got
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/proto.c:438"
reproduced: false
---

# `expected new tuple but got %d`

## What it means

An internal guard in logical-replication decoding. Processing a change message, the subscriber expected a new-tuple field and instead read a different field code. The placeholder is the code it saw.

## When it happens

It fires on a logical-replication subscriber when the replication message stream does not match the expected sequence for a change, usually a version mismatch between publisher and subscriber or a corrupted message.

## How to fix

Confirm publisher and subscriber run compatible versions and the connection is not corrupting data. Restart the subscription to re-read from a clean point. If it recurs between matched, healthy versions, capture the context and report it.

## Example

*Illustrative* — the message as logged.

```
ERROR:  expected new tuple but got 2
```

## Related

- [expected action 'N', got](./expected-action-n-got.md)
- [expected action 'O' or 'K', got](./expected-action-o-or-k-got.md)
