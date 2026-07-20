---
message: "expected action 'N', got %c"
slug: expected-action-n-got
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/proto.c:516"
reproduced: false
---

# `expected action 'N', got %c`

## What it means

An internal guard in logical-replication protocol decoding. The subscriber expected a tuple-action byte of `N` (a new tuple) at this point in the message stream and read a different byte. The placeholder is the byte it saw.

## When it happens

It fires on a logical-replication subscriber (or a logical-decoding consumer) when the byte stream from the publisher does not match the expected protocol sequence. It usually means a protocol-version mismatch or a corrupted or truncated replication message.

## How to fix

This is a protocol-level invariant, not a user setting. Check that publisher and subscriber run compatible PostgreSQL versions and that the network did not corrupt the stream. Restarting the subscription re-reads the stream cleanly. If it recurs between matched versions, capture the context and report it as a possible bug.

## Example

*Illustrative* — the message as logged.

```
ERROR:  expected action 'N', got X
```

## Related

- [expected action 'N', 'O' or 'K', got](./expected-action-n-o-or-k-got.md)
- [expected action 'O' or 'K', got](./expected-action-o-or-k-got.md)
