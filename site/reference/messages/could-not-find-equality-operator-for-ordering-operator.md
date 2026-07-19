---
message: "could not find equality operator for ordering operator %u"
slug: could-not-find-equality-operator-for-ordering-operator
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/plan/planagg.c:166"
  - "postgres/src/backend/optimizer/plan/planner.c:8811"
reproduced: false
---

# `could not find equality operator for ordering operator %u`

## What it means

Internal error. The planner had an ordering operator (used for a sort or `ORDER BY`) and needed the matching equality operator from the same operator family, but could not find one. The placeholder is the operator OID. The operator family is missing expected equality support.

## When it happens

It should not occur through ordinary SQL with standard types. Reaching it points to an operator-family definition lacking the equality operator the planner expects — typically with a custom operator class.

## How to fix

If a custom ordering operator or operator class is involved, ensure its operator family includes the corresponding equality operator. For built-in types, capture the query and report it. Rewriting the query to avoid the problematic ordering can sidestep it temporarily.

## Example

*Illustrative* — emitted internally during planning.

```text
ERROR:  could not find equality operator for ordering operator 12345
```

## Related

- [could not find compatible hash operator for operator](./could-not-find-compatible-hash-operator-for-operator.md)
- [could not find opfamilies for equality operator](./could-not-find-opfamilies-for-equality-operator.md)
