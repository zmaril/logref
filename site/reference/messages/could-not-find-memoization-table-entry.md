---
message: "could not find memoization table entry"
slug: could-not-find-memoization-table-entry
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeMemoize.c:485"
reproduced: false
---

# `could not find memoization table entry`

## What it means

The executor's Memoize node looked for an entry in its result cache and could not find one it expected. This is an internal consistency check in the Memoize plan node.

## When it happens

It fires while a Memoize node serves cached inner-side results during a nested-loop join. Reaching it points at an internal problem rather than anything in the query.

## How to fix

This is an internal error. As a workaround you can disable memoization for the session (`SET enable_memoize = off`) to keep the query running. Note the query and report a reproducible case.

## Example

*Illustrative* — a missing Memoize cache entry.

```text
ERROR:  could not find memoization table entry
```

## Related

- [could not find plan for CteScan referencing plan ID](./could-not-find-plan-for-ctescan-referencing-plan-id.md)
- [could not find RelOptInfo for given relids](./could-not-find-reloptinfo-for-given-relids.md)
