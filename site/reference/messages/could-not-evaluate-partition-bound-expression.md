---
message: "could not evaluate partition bound expression"
slug: could-not-evaluate-partition-bound-expression
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:5197"
reproduced: false
---

# `could not evaluate partition bound expression`

## What it means

PostgreSQL could not evaluate an expression used as a partition bound to a constant. This is an internal guard: by the time it runs, partition bounds should already be reduced to constants.

## When it happens

It fires during `CREATE TABLE ... PARTITION OF ... FOR VALUES` processing when a bound expression does not evaluate to a constant as expected. Ordinary constant bounds do not reach it.

## How to fix

Use plain constant values for partition bounds. Bounds must be immutable constants, not expressions that depend on runtime state. If a genuinely constant bound triggers this, note the exact statement and report a reproducible case.

## Example

*Illustrative* — a partition bound that does not reduce to a constant.

```text
ERROR:  could not evaluate partition bound expression
```

## Related

- [could not determine which collation to use for partition expression](./could-not-determine-which-collation-to-use-for-partition-expression.md)
- [could not find inherited attribute of relation](./could-not-find-inherited-attribute-of-relation.md)
