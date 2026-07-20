---
message: "cannot use type %s in IS JSON predicate"
slug: cannot-use-type-in-is-json-predicate
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:4241"
reproduced: false
---

# `cannot use type %s in IS JSON predicate`

## What it means

An `IS JSON` predicate was applied to a value of a type it does not accept. The predicate tests text or JSON input for well-formed JSON, so a type that is neither string nor JSON cannot be checked.

## When it happens

It occurs in `expr IS JSON` when `expr` has a type such as `integer` or `boolean` rather than `text`, `bytea`, `json`, or `jsonb`.

## How to fix

Cast the value to `text` or `json` before the predicate, or apply `IS JSON` only to string and JSON inputs.

## Example

*Illustrative* — IS JSON on a numeric value.

```sql
SELECT 42 IS JSON;
-- ERROR:  cannot use type integer in IS JSON predicate
```

## Related

- [cannot use non-string types with implicit FORMAT JSON clause](./cannot-use-non-string-types-with-implicit-format-json-clause.md)
- [cannot use JSON format with non-string output types](./cannot-use-json-format-with-non-string-output-types.md)
