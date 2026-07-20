---
message: "cannot happen"
slug: cannot-happen
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/rewrite/rewriteHandler.c:1227"
reproduced: false
---

# `cannot happen`

## What it means

A defensive guard in the query rewriter fired with the literal label "cannot happen". It marks a branch the developers believe is unreachable, and reaching it means an assumption in the rewriter was violated.

## When it happens

It is reached only if the rewriter's internal state is inconsistent — for example an unexpected node shape while processing rules. It reflects a coding issue or catalog inconsistency rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the statement, the rules involved, and a reproducer if possible, then report it, since this branch should never be reached.

## Example

*Illustrative* — an unreachable rewriter branch reached.

```text
ERROR:  cannot happen
```

## Related

- [cannot handle qualified ON SELECT rule](./cannot-handle-qualified-on-select-rule.md)
- [cannot have empty item list after parsing success](./cannot-have-empty-item-list-after-parsing-success.md)
