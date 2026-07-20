---
message: "unexpected ON CONFLICT specification: %d"
slug: unexpected-on-conflict-specification
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/postgres_fdw/postgres_fdw.c:2087"
  - "postgres/contrib/postgres_fdw/postgres_fdw.c:2429"
reproduced: false
---

# `unexpected ON CONFLICT specification: %d`

## What it means

Internal error. Executor or planner code handling `INSERT ... ON CONFLICT` was given a conflict-action code that is neither the nothing nor the update case.

## When it happens

It fires when the on-conflict action carried in the plan is outside the defined set. A parsed `ON CONFLICT` clause never yields it; it signals an internal inconsistency.

## How to fix

This is an internal consistency guard. If a real `ON CONFLICT` statement triggers it, capture the statement and report it as a reproducible bug.

## Example

*Illustrative* — an out-of-range on-conflict action.

```text
ERROR:  unexpected ON CONFLICT specification: 3
```

## Related

- [unexpected operation: %d](./unexpected-operation.md)
- [unexpected statement subtype: %d](./unexpected-statement-subtype.md)
