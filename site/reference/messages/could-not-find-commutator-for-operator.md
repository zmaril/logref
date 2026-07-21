---
message: "could not find commutator for operator %u"
slug: could-not-find-commutator-for-operator
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/util/clauses.c:2421"
reproduced: false
---

# `could not find commutator for operator %u`

## What it means

The planner needed the commutator of an operator (given by OID) and the operator's catalog entry does not name one. This is an internal guard reached when a required commutator is missing.

## When it happens

It fires while the planner reorders an operator expression that requires a commutator. Built-in operators declare their commutators, so reaching it usually involves a custom operator with an incomplete definition.

## How to fix

If a custom operator is involved, define its `COMMUTATOR` in the `CREATE OPERATOR` statement. The planner needs it to swap the operands. Fix the operator definition and retry.

## Example

*Illustrative* — an operator with no declared commutator.

```text
ERROR:  could not find commutator for operator 91234
```

## Related

- [could not find ordering operator for equality operator](./could-not-find-ordering-operator-for-equality-operator.md)
- [could not find equality strategy for index operator family for type](./could-not-find-equality-strategy-for-index-operator-family-for-type.md)
