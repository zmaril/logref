---
message: "DECLARE CURSOR WITH HOLD ... %s is not supported"
slug: declare-cursor-with-hold-is-not-supported
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/analyze.c:3410"
reproduced: false
---

# `DECLARE CURSOR WITH HOLD ... %s is not supported`

## What it means

A `DECLARE CURSOR ... WITH HOLD` was combined with a feature that held cursors do not support. The placeholder names the unsupported element. A `WITH HOLD` cursor survives its transaction, and some query features cannot be preserved across that boundary. The server reports it as an unsupported feature.

## When it happens

It happens when a `WITH HOLD` cursor is declared over a query that uses something incompatible with holding — for example certain volatile or transaction-bound constructs the message names.

## How to fix

Either drop `WITH HOLD` and use the cursor within a single transaction, or remove the unsupported feature from the query so it can be held. The message's placeholder tells you which construct is not supported with a held cursor.

## Example

*Illustrative* — a held cursor over an unsupported construct.

```text
ERROR:  DECLARE CURSOR WITH HOLD ... FOR UPDATE is not supported
```

## Related

- [DECLARE CURSOR must not contain data-modifying statements in WITH](./declare-cursor-must-not-contain-data-modifying-statements-in-with.md)
- [cursor is held from a previous transaction](./cursor-is-held-from-a-previous-transaction.md)
