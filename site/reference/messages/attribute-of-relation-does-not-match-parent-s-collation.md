---
message: "attribute \"%s\" of relation \"%s\" does not match parent's collation"
slug: attribute-of-relation-does-not-match-parent-s-collation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_COLUMN_DEFINITION
    code: "42611"
call_sites:
  - "postgres/src/backend/optimizer/util/appendinfo.c:169"
reproduced: false
---

# `attribute "%s" of relation "%s" does not match parent's collation`

## What it means

A child table's column has a different collation than the matching column in its parent, but inheritance and partitioning require the collations to agree. The placeholders name the column and the relation.

## When it happens

It occurs during `CREATE TABLE ... INHERITS`, `ATTACH PARTITION`, or `ALTER TABLE ... INHERIT` when a child column's collation differs from the parent's.

## How to fix

Define the child column with the same collation as the parent, or adjust one side so they agree, then retry the attach or inherit. Every corresponding column pair must match in type and collation.

## Example

*Illustrative* — a collation mismatch on attach.

```text
ERROR:  attribute "name" of relation "child" does not match parent's collation
```

## Related

- [attribute of relation does not match parent's type](./attribute-of-relation-does-not-match-parent-s-type.md)
- [attribute does not exist](./attribute-does-not-exist.md)
