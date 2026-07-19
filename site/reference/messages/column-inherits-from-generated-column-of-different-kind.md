---
message: "column \"%s\" inherits from generated column of different kind"
slug: column-inherits-from-generated-column-of-different-kind
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
  - symbol: ERRCODE_INVALID_COLUMN_DEFINITION
    code: "42611"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:3159"
  - "postgres/src/backend/commands/tablecmds.c:3453"
  - "postgres/src/backend/commands/tablecmds.c:18278"
reproduced: false
---

# `column "%s" inherits from generated column of different kind`

## What it means

In an inheritance or partitioning hierarchy, a child column and the parent column it inherits from are both generated but of different generation kinds (for example one `STORED` and the other a different form), which is not allowed. The placeholder names the column. Inherited generated columns must agree on their generation kind.

## When it happens

Creating or altering an inheritance/partition child whose generated column conflicts in kind with the parent's, or attaching a partition whose generated column definition does not match the parent's.

## How to fix

Make the child's generated column the same kind as the parent's — same `GENERATED ALWAYS AS (...) STORED` definition — or drop the mismatch so the column is inherited consistently. Align the generation kind across the hierarchy before attaching or creating the child.

## Example

*Illustrative* — mismatched generated-column kinds across inheritance.

```text
ERROR:  column "c" inherits from generated column of different kind
```

## Related

- [column of relation is an identity column](./column-of-relation-is-an-identity-column.md)
- [cannot assign to system column](./cannot-assign-to-system-column.md)
