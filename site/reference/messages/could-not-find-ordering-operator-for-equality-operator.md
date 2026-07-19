---
message: "could not find ordering operator for equality operator %u"
slug: could-not-find-ordering-operator-for-equality-operator
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/plan/planner.c:8846"
reproduced: false
---

# `could not find ordering operator for equality operator %u`

## What it means

The planner needed an ordering operator to go with an equality operator (given by OID) and could not find one. This is an internal guard reached when a sort-based plan requires an ordering the operator family does not provide.

## When it happens

It fires while the planner builds a sort or grouping step and the equality operator has no matching ordering (less-than) operator. Built-in types provide one, so reaching it usually involves a custom operator class.

## How to fix

If a custom type or operator class is involved, make sure it defines an ordering (`<`) operator alongside equality in a btree operator class. The planner needs it to sort. Complete the operator-class definition and retry.

## Example

*Illustrative* — an equality operator with no ordering operator.

```text
ERROR:  could not find ordering operator for equality operator 91234
```

## Related

- [could not find commutator for operator](./could-not-find-commutator-for-operator.md)
- [could not find equality strategy for index operator family for type](./could-not-find-equality-strategy-for-index-operator-family-for-type.md)
