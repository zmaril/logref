---
message: "%s requires = operator to yield boolean"
slug: requires-operator-to-yield-boolean
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:1115"
  - "postgres/src/backend/parser/parse_expr.c:3114"
reproduced: false
---

# `%s requires = operator to yield boolean`

## What it means

A construct that depends on an equality (`=`) operator found that the operator for the involved type does not return boolean. The placeholder names the context. Equality used this way must yield a boolean result.

## When it happens

It arises in features that call a type's `=` operator internally — for example certain `DISTINCT`/grouping or membership operations — when the operator resolved for the type has a non-boolean result type, usually from a malformed custom operator or operator class.

## How to fix

Ensure the type's equality operator returns boolean. For custom types, define `=` with a boolean result and register it correctly in the operator class. Do not overload `=` with a non-boolean return for a type used in these contexts.

## Example

*Illustrative* — an equality operator that does not return boolean.

```text
ERROR:  ROW() requires = operator to yield boolean
```

## Related

- [postfix operators are not supported](./postfix-operators-are-not-supported.md)
- [subscript type %s is not supported](./subscript-type-is-not-supported.md)
