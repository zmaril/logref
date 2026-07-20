---
message: "expandTableLikeClause called on untransformed LIKE clause"
slug: expandtablelikeclause-called-on-untransformed-like-clause
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:1362"
reproduced: false
---

# `expandTableLikeClause called on untransformed LIKE clause`

## What it means

An internal invariant in the utility-command parser. The routine that expands a `CREATE TABLE ... (LIKE source ...)` clause was called before the clause had been transformed into its analyzed form, so it stops.

## When it happens

It fires during `CREATE TABLE ... (LIKE ...)` processing if the internal command sequence runs out of order. In normal operation the `LIKE` clause is transformed before expansion, so this cannot happen.

## How to fix

This is an internal "can't happen" guard, not a user-facing condition. If you hit it from a plain `CREATE TABLE ... (LIKE ...)`, capture the statement and report it as a bug. There is no configuration workaround.

## Example

*Illustrative* — the message as logged.

```
ERROR:  expandTableLikeClause called on untransformed LIKE clause
```

## Related

- [executor could not find named tuplestore](./executor-could-not-find-named-tuplestore.md)
- [expected just one rule action](./expected-just-one-rule-action.md)
