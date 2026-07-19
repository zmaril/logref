---
message: "unrecognized strategy: %d"
slug: unrecognized-strategy
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/geo_spgist.c:691"
  - "postgres/src/backend/utils/adt/geo_spgist.c:831"
reproduced: false
---

# `unrecognized strategy: %d`

## What it means

Internal error. Index or operator-class code met a strategy code outside the set it recognizes while dispatching an operation.

## When it happens

It fires where a strategy value is switched on and it is not a known case. A correctly declared operator class does not produce it.

## How to fix

This is an internal guard. A custom or corrupt operator class can provoke it; verify the operator-class definition and report a reproducible case with the class and query.

## Example

*Illustrative* — an unrecognized strategy.

```text
ERROR:  unrecognized strategy: 9
```

## Related

- [unexpected strategy number %d](./unexpected-strategy-number.md)
- [unexpected operator %u](./unexpected-operator.md)
