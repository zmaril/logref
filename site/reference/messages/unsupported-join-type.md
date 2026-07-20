---
message: "unsupported join type %d"
slug: unsupported-join-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/postgres_fdw/deparse.c:1693"
  - "postgres/contrib/postgres_fdw/postgres_fdw.c:6904"
reproduced: false
---

# `unsupported join type %d`

## What it means

Internal error. Planner or deparse code met a join-type code (inner, left, full, semi, anti, and so on) that the current path does not handle.

## When it happens

It fires where a join type is switched on and the value is outside the set that path supports — for example a deparser or specialized planner routine reached with an unexpected join type.

## How to fix

This is an internal guard. If a real query triggers it, capture the query and report it as a reproducible bug; for a foreign join, disabling join pushdown for that query works around it.

## Example

*Illustrative* — an unsupported join type.

```text
ERROR:  unsupported join type 5
```

## Related

- [unsupported join alias expression](./unsupported-join-alias-expression.md)
- [unrecognized node type in jointree: %d](./unrecognized-node-type-in-jointree.md)
