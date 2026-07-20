---
message: "argument type %s of FieldStore is not a tuple type"
slug: argument-type-of-fieldstore-is-not-a-tuple-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/ruleutils.c:13732"
reproduced: false
---

# `argument type %s of FieldStore is not a tuple type`

## What it means

Expression evaluation reached a FieldStore node (which updates a field of a composite value) whose input is not a composite/tuple type, which a correct plan should never produce — an internal consistency guard.

## When it happens

It is raised during execution when a field-assignment expression is applied to a non-row value, generally through a bug in query construction or an extension building expression nodes.

## How to fix

This is an internal error rather than a user SQL fault. If it recurs, capture the statement and any extensions that build expressions and report it. There is no reliable user-level workaround.

## Example

*Illustrative* — a FieldStore over a non-composite value.

```text
ERROR:  argument type integer of FieldStore is not a tuple type
```

## Related

- [allParameterTypes is not a 1-D Oid array](./allparametertypes-is-not-a-1-d-oid-array.md)
- [array_typanalyze was invoked for non-array type](./array-typanalyze-was-invoked-for-non-array-type.md)
