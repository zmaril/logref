---
message: "cannot commute non-binary-operator clause"
slug: cannot-commute-non-binary-operator-clause
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/util/clauses.c:2416"
reproduced: false
---

# `cannot commute non-binary-operator clause`

## What it means

An internal planner routine was asked to commute an operator clause — swap its two sides — but the clause does not have exactly two operands. Commuting only applies to binary operators, so this is a consistency error in clause handling.

## When it happens

It is a can't-happen guard in the optimizer. It would only surface from a bug in planner code or an extension that constructs operator clauses.

## How to fix

There is no user-level fix in SQL. If it appears, capture the query and any planner-related extension in use and report it, since well-formed clauses should never reach this guard.

## Example

*Illustrative* — the internal commute guard.

```text
ERROR:  cannot commute non-binary-operator clause
```

## Related

- [cannot cope with variable-free clause](./cannot-cope-with-variable-free-clause.md)
- [cannot copy a one-shot cached plan](./cannot-copy-a-one-shot-cached-plan.md)
