---
message: "bogus resno %d in targetlist"
slug: bogus-resno-in-targetlist
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/rewrite/rewriteHandler.c:863"
reproduced: false
---

# `bogus resno %d in targetlist`

## What it means

A plan or parse tree held a target-list entry whose result number is out of range. The placeholder is the offending number. Target-list result numbers index output columns and must fall within the list. It is an internal guard.

## When it happens

It is a can't-happen check in planner or rewriter code and does not arise from ordinary SQL.

## How to fix

There is no user action for normal queries. If it appears, capture the query and any views, rules, or extensions involved and report it as a possible bug.

## Example

*Illustrative* — a bad result number.

```text
ERROR:  bogus resno 9 in targetlist
```

## Related

- [bogus rowcompare index qualification](./bogus-rowcompare-index-qualification.md)
- [badly formatted node string](./badly-formatted-node-string.md)
