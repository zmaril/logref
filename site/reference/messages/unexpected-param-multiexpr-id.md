---
message: "unexpected PARAM_MULTIEXPR ID: %d"
slug: unexpected-param-multiexpr-id
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/plan/setrefs.c:2187"
  - "postgres/src/backend/optimizer/plan/setrefs.c:2190"
reproduced: false
---

# `unexpected PARAM_MULTIEXPR ID: %d`

## What it means

Internal error. The executor evaluating a multi-column assignment (a `PARAM_MULTIEXPR` from an `UPDATE ... SET (a,b) = (...)`) found a sub-parameter index outside the expected range.

## When it happens

It fires when the internal id linking a multi-assignment's outputs to its slots does not line up. A well-formed multi-column update does not produce it.

## How to fix

This is an internal guard. If a real multi-column `UPDATE` triggers it, capture the statement and report it as a reproducible planner bug.

## Example

*Illustrative* — a bad multi-expression parameter id.

```text
ERROR:  unexpected PARAM_MULTIEXPR ID: 131073
```

## Related

- [unexpected parse analysis result](./unexpected-parse-analysis-result.md)
- [wrong number of tlist entries](./wrong-number-of-tlist-entries.md)
