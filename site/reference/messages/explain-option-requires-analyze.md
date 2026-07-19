---
message: "EXPLAIN option %s requires ANALYZE"
slug: explain-option-requires-analyze
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/explain_state.c:177"
  - "postgres/src/backend/commands/explain_state.c:189"
  - "postgres/src/backend/commands/explain_state.c:195"
  - "postgres/src/backend/commands/explain_state.c:201"
reproduced: false
---

# `EXPLAIN option %s requires ANALYZE`

## What it means

An `EXPLAIN` option that only makes sense with actual execution was used without `ANALYZE`. The placeholder is the option. Options like `TIMING` and `BUFFERS` report data gathered while running the statement, so they require `ANALYZE`.

## When it happens

Writing `EXPLAIN (TIMING)`, `EXPLAIN (BUFFERS)` (in versions that require it), or a similar run-time option without also specifying `ANALYZE`.

## How to fix

Add `ANALYZE` to actually execute the statement and collect the run-time data: `EXPLAIN (ANALYZE, TIMING) SELECT ...`. Remember `EXPLAIN ANALYZE` runs the statement — wrap data-modifying statements in a transaction you roll back if you do not want the effect.

## Example

*Illustrative* — a run-time option without ANALYZE.

```sql
EXPLAIN (TIMING) SELECT 1;
```

## Related

- [unrecognized value for option](./unrecognized-value-for-option-0dbab1.md)
- [unrecognized option](./unrecognized-option-8eb055.md)
