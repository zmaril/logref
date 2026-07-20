---
message: "attribute \"%s\" of relation \"%s\" does not match parent's type"
slug: attribute-of-relation-does-not-match-parent-s-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_COLUMN_DEFINITION
    code: "42611"
call_sites:
  - "postgres/src/backend/optimizer/util/appendinfo.c:164"
reproduced: false
---

# `attribute "%s" of relation "%s" does not match parent's type`

## What it means

A child table's column has a different data type than the corresponding column in its parent, which inheritance and partitioning forbid. The placeholders name the column and the relation.

## When it happens

It occurs during `CREATE TABLE ... INHERITS`, `ATTACH PARTITION`, or `ALTER TABLE ... INHERIT` when a child column's type does not match the parent's.

## How to fix

Redefine the child column with the parent's exact type before attaching or inheriting. Corresponding columns must line up by name, type, and collation for the relation to join the hierarchy.

## Example

*Illustrative* — a type mismatch on attach.

```text
ERROR:  attribute "amount" of relation "child" does not match parent's type
```

## Related

- [attribute of relation does not match parent's collation](./attribute-of-relation-does-not-match-parent-s-collation.md)
- [attribute of type has wrong type](./attribute-of-type-has-wrong-type.md)
