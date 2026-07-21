---
message: "expected action 'N', 'O' or 'K', got %c"
slug: expected-action-n-o-or-k-got
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/proto.c:500"
reproduced: false
---

# `expected action 'N', 'O' or 'K', got %c`

## What it means

An internal guard in logical-replication protocol decoding. The subscriber expected one of the tuple-action bytes `N`, `O`, or `K` (new, old, or key tuple) and read a different byte. The placeholder is the byte it saw.

## When it happens

It fires on a logical-replication subscriber when the message stream does not follow the expected protocol shape, typically from a version mismatch between publisher and subscriber or a corrupted or truncated message.

## How to fix

Confirm publisher and subscriber run compatible versions and that the replication connection is not corrupting data. Restart the subscription to re-read from a clean point. Report it with the surrounding context if it happens between matched, healthy versions.

## Example

*Illustrative* — the message as logged.

```
ERROR:  expected action 'N', 'O' or 'K', got X
```

## Related

- [expected action 'N', got](./expected-action-n-got.md)
- [expected action 'O' or 'K', got](./expected-action-o-or-k-got.md)
