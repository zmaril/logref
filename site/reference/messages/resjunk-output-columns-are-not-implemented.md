---
message: "resjunk output columns are not implemented"
slug: resjunk-output-columns-are-not-implemented
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/plan/planner.c:6062"
  - "postgres/src/backend/optimizer/plan/planner.c:6067"
reproduced: false
---

# `resjunk output columns are not implemented`

## What it means

Internal error. A code path produced or expected `resjunk` (hidden, planner-internal) output columns in a place that does not support them. `resjunk` columns carry sort keys, row identities, and similar internals that are normally stripped before results reach the client.

## When it happens

It fires from executor/planner glue where a target list unexpectedly contains junk columns for an operation that cannot handle them. Ordinary queries do not raise it.

## How to fix

This is an internal consistency guard. If a real query triggers it, capture the statement and any custom function or extension involved and report it as a reproducible bug.

## Example

*Illustrative* — junk output columns reaching an unsupported path.

```text
ERROR:  resjunk output columns are not implemented
```

## Related

- [system-column update is not supported](./system-column-update-is-not-supported.md)
- [ORDER/GROUP BY expression not found in targetlist](./order-group-by-expression-not-found-in-targetlist.md)
