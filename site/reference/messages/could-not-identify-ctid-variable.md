---
message: "could not identify CTID variable"
slug: could-not-identify-ctid-variable
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeTidrangescan.c:75"
  - "postgres/src/backend/executor/nodeTidscan.c:97"
reproduced: false
---

# `could not identify CTID variable`

## What it means

Internal error in the TID-scan executor. A `ctid` scan expected a `ctid` column reference (Var) on one side of its comparison and did not find one. It is a plan-shape consistency check.

## When it happens

It fires inside a TID or TID-range scan whose comparison did not reference the relation's `ctid` as expected. Ordinary queries do not trigger it.

## How to fix

This is a can't-happen guard. Record the query filtering on `ctid` and report it as a bug with reproduction steps.

## Example

*Illustrative* — a TID scan comparison lacked its ctid Var.

```text
ERROR:  could not identify CTID variable
```

## Related

- [could not identify CTID expression](./could-not-identify-ctid-expression.md)
- [failed to fetch the target tuple](./failed-to-fetch-the-target-tuple.md)
