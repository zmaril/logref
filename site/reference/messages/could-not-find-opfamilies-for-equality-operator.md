---
message: "could not find opfamilies for equality operator %u"
slug: could-not-find-opfamilies-for-equality-operator
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/path/pathkeys.c:231"
  - "postgres/src/backend/optimizer/plan/initsplan.c:1060"
reproduced: false
---

# `could not find opfamilies for equality operator %u`

## What it means

Internal error. The planner tried to find the operator families that provide a given equality operator and found none. The placeholder is the operator OID. Equality-based planning (grouping, hashing, merge joins) needs that operator-family linkage, which was missing.

## When it happens

It should not occur through ordinary SQL with standard types. Reaching it points to an operator-family definition that does not register the equality operator the planner expects — usually a custom operator class.

## How to fix

If a custom operator class is involved, ensure its operator family lists the equality operator. For built-in types, capture the query and report it. Adjusting the query to avoid the affected grouping or join is a temporary workaround.

## Example

*Illustrative* — emitted internally during planning.

```text
ERROR:  could not find opfamilies for equality operator 12345
```

## Related

- [could not find equality operator for ordering operator](./could-not-find-equality-operator-for-ordering-operator.md)
- [could not find compatible hash operator for operator](./could-not-find-compatible-hash-operator-for-operator.md)
