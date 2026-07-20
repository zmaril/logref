---
message: "both subquery and values RTEs in INSERT"
slug: both-subquery-and-values-rtes-in-insert
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/ruleutils.c:7345"
reproduced: false
---

# `both subquery and values RTEs in INSERT`

## What it means

The rewriter found an `INSERT` whose range table contains both a subquery source and a `VALUES` source, which its internal representation does not allow at once. An `INSERT` draws rows from one or the other. It is an internal guard.

## When it happens

It is a can't-happen check in query rewriting and does not arise from ordinary `INSERT` statements.

## How to fix

There is no user action for normal SQL. If it appears, capture the `INSERT` statement together with any rules or extensions that rewrite it and report it as a possible bug.

## Example

*Illustrative* — the rewriter guard.

```text
ERROR:  both subquery and values RTEs in INSERT
```

## Related

- [bogus resno in targetlist](./bogus-resno-in-targetlist.md)
- [begintransactionblock unexpected state](./begintransactionblock-unexpected-state.md)
