---
message: "commutator operator %s is already the commutator of operator %s"
slug: commutator-operator-is-already-the-commutator-of-operator-6c35b7
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/catalog/pg_operator.c:737"
reproduced: false
---

# `commutator operator %s is already the commutator of operator %s`

## What it means

A `CREATE OPERATOR` (or operator linkage step) tried to name a commutator that is already registered as the commutator of a different operator. An operator's commutator link cannot be reassigned this way.

## When it happens

It happens when defining an operator whose `COMMUTATOR` clause points at an operator already commutator-linked to another operator.

## How to fix

Remove or correct the `COMMUTATOR` clause. Commutator pairs are established once; if you are rebuilding operators, drop and recreate them so the links are consistent, and ensure each commutator is paired with only one operator.

## Example

*Illustrative* — reusing an already-linked commutator.

```text
ERROR:  commutator operator = is already the commutator of operator <>
```

## Related

- [commutator operator is already the commutator of operator](./commutator-operator-is-already-the-commutator-of-operator-df7aa1.md)
- [composite data types are not binary-compatible](./composite-data-types-are-not-binary-compatible.md)
