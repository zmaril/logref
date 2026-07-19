---
message: "cannot display a value of type %s"
slug: cannot-display-a-value-of-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/contrib/btree_gist/btree_gist.c:43"
  - "postgres/contrib/hstore/hstore_gist.c:110"
  - "postgres/contrib/intarray/_intbig_gist.c:42"
  - "postgres/contrib/ltree/ltree_gist.c:34"
  - "postgres/contrib/pg_trgm/trgm_gist.c:69"
reproduced: false
---

# `cannot display a value of type %s`

## What it means

A tool that renders index or page contents as text (here from `btree_gist`/inspection code) encountered a value of a type it has no textual output routine for. The placeholder is the type. The value exists but this display path cannot format it.

## When it happens

Using an inspection or GiST support path on a data type that lacks the output support the display code requires — often an exotic or internal type not meant for direct display in that context.

## How to fix

This is a limitation of the display path, not a data problem. Query the value through a normal `SELECT` (which uses the type's output function) rather than the inspection routine, or select a representation the tool can format. If it comes from an extension, its display support may be incomplete.

## Example

*Illustrative* — an undisplayable type in an inspection path.

```text
ERROR:  cannot display a value of type internal
```

## Related

- [cannot call on a scalar](./cannot-call-on-a-scalar.md)
- [type with oid not supported](./type-with-oid-not-supported.md)
