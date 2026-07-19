---
message: "collations are not supported by type %s"
slug: collations-are-not-supported-by-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:2126"
  - "postgres/src/backend/commands/tablecmds.c:20734"
  - "postgres/src/backend/commands/typecmds.c:812"
  - "postgres/src/backend/parser/parse_expr.c:2835"
  - "postgres/src/backend/parser/parse_type.c:566"
  - "postgres/src/backend/parser/parse_utilcmd.c:4383"
  - "postgres/src/backend/utils/adt/misc.c:601"
reproduced: false
---

# `collations are not supported by type %s`

## What it means

A collation was specified for a value whose type is not collatable. The placeholder is the type. Collations only apply to string types (`text`, `varchar`, `char`, and domains over them); attaching one to a non-string type like `integer` or `bytea` is rejected.

## When it happens

A `COLLATE` clause on a non-text expression, defining a column of a non-collatable type with a collation, or an index/constraint that applies a collation to a numeric or binary column. Sometimes a generated query adds `COLLATE` indiscriminately.

## How to fix

Remove the `COLLATE` clause from non-string values — collation is meaningless for numbers, booleans, `bytea`, and the like. Apply collations only to text-typed columns and expressions. If you need locale-aware behavior on non-text data, rethink the approach; collation is a string concept.

## Example

*Illustrative* — a COLLATE on an integer.

```sql
SELECT 1 COLLATE "en_US";
```

Produces:

```text
ERROR:  collations are not supported by type integer
```

## Related

- [cache lookup failed for collation](./cache-lookup-failed-for-collation.md)
- [cannot cast type %s to %s](./cannot-cast-type-to.md)
