---
message: "could not find JoinExpr for whole-row reference"
slug: could-not-find-joinexpr-for-whole-row-reference
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/parser/parse_relation.c:1140"
reproduced: false
---

# `could not find JoinExpr for whole-row reference`

## What it means

The parser or planner could not find the join expression backing a whole-row reference to a join. This is an internal invariant: a whole-row reference to a join should map to a known `JoinExpr`.

## When it happens

It fires while resolving a whole-row `Var` (such as `join_alias.*` used as a single value) when the underlying join expression cannot be located. Ordinary queries do not reach it.

## How to fix

This is an internal error. If a specific query with a whole-row reference to a joined alias triggers it, note the exact statement and report a reproducible case.

## Example

*Illustrative* — an unmatched whole-row join reference.

```text
ERROR:  could not find JoinExpr for whole-row reference
```

## Related

- [could not find join node](./could-not-find-join-node.md)
- [could not find replacement targetlist entry for attno](./could-not-find-replacement-targetlist-entry-for-attno.md)
