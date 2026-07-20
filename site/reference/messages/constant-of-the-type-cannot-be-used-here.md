---
message: "constant of the type %s cannot be used here"
slug: constant-of-the-type-cannot-be-used-here
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/catalog/dependency.c:1951"
  - "postgres/src/backend/catalog/dependency.c:1962"
reproduced: false
---

# `constant of the type %s cannot be used here`

## What it means

A dependency-tracking operation encountered a constant of a type that is not permitted in that context. The placeholder is the type. Certain internal or pseudo-types cannot appear as constants where the operation expects an ordinary value.

## When it happens

Recording or resolving a dependency involving a constant of an unsupported type — often reached indirectly through DDL that embeds an expression using an internal-only type.

## How to fix

Rework the expression so it does not embed a constant of the unsupported type. Use a concrete, storable type for values that participate in stored definitions. If this surfaced from a specific DDL statement, simplify the expression it stores.

## Example

*Illustrative* — an unsupported constant type in a stored expression.

```text
ERROR:  constant of the type internal cannot be used here
```

## Related

- [cannot use type in RETURNING clause of](./cannot-use-type-in-returning-clause-of.md)
- [cannot drop because it is required by the database system](./cannot-drop-because-it-is-required-by-the-database-system.md)
