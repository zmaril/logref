---
message: "commutator operator %s is already the commutator of operator %u"
slug: commutator-operator-is-already-the-commutator-of-operator-df7aa1
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/catalog/pg_operator.c:742"
reproduced: false
---

# `commutator operator %s is already the commutator of operator %u`

## What it means

A commutator linkage step found that the named commutator operator is already the commutator of another operator (identified here by OID). The link cannot be reassigned.

## When it happens

It happens during operator creation or catalog linkage when a `COMMUTATOR` target is already paired with a different operator.

## How to fix

Correct the `COMMUTATOR` clause so it does not reuse an operator already linked elsewhere. If reworking operator families, drop the conflicting operators first and recreate the pair cleanly.

## Example

*Illustrative* — a commutator already linked to another operator.

```text
ERROR:  commutator operator = is already the commutator of operator 12345
```

## Related

- [commutator operator is already the commutator of operator](./commutator-operator-is-already-the-commutator-of-operator-6c35b7.md)
- [composite data types are not binary-compatible](./composite-data-types-are-not-binary-compatible.md)
