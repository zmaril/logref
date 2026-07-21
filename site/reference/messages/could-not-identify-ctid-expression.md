---
message: "could not identify CTID expression"
slug: could-not-identify-ctid-expression
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeTidrangescan.c:120"
  - "postgres/src/backend/executor/nodeTidscan.c:117"
reproduced: false
---

# `could not identify CTID expression`

## What it means

Internal error in the TID-scan executor. The plan should have supplied a `ctid` comparison expression to drive a tuple-ID scan, and none matched. It is a consistency check inside the planner/executor contract, not a user condition.

## When it happens

It fires inside a TID or TID-range scan node whose qualifier list did not contain the expected `ctid` expression. Ordinary queries do not reach it.

## How to fix

This is a can't-happen guard. If you see it, capture the query (especially any that filters on `ctid`) and report it with a reproducible case.

## Example

*Illustrative* — a TID scan reached execution without its ctid qual.

```text
ERROR:  could not identify CTID expression
```

## Related

- [could not identify CTID variable](./could-not-identify-ctid-variable.md)
- [failed to fetch the target tuple](./failed-to-fetch-the-target-tuple.md)
