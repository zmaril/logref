---
message: "cannot cast type %s to %s"
slug: cannot-cast-type-to
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CANNOT_COERCE
    code: "42846"
call_sites:
  - "postgres/src/backend/parser/parse_coerce.c:1046"
  - "postgres/src/backend/parser/parse_coerce.c:1084"
  - "postgres/src/backend/parser/parse_coerce.c:1102"
  - "postgres/src/backend/parser/parse_coerce.c:1117"
  - "postgres/src/backend/parser/parse_expr.c:2184"
  - "postgres/src/backend/parser/parse_expr.c:2804"
  - "postgres/src/backend/parser/parse_expr.c:3459"
  - "postgres/src/backend/parser/parse_expr.c:3688"
  - "postgres/src/backend/parser/parse_expr.c:4209"
  - "postgres/src/backend/parser/parse_target.c:1004"
reproduced: false
---

# `cannot cast type %s to %s`

## What it means

An explicit cast between two types has no cast path. The placeholders are the source and target types. Postgres allows a cast only when one is defined (built-in, via `CREATE CAST`, or through I/O), and there is none for this pair.

## When it happens

`x::target` or `CAST(x AS target)` between unrelated types — for example casting a composite to an integer, or two custom types with no cast between them. It also appears when a cast exists only as `ASSIGNMENT`/`IMPLICIT` but you attempt it in a disallowed context.

## How to fix

Use a supported conversion. Often you can go through `text` (cast to text, then to the target) if both have text I/O, or use a function that converts between the types. If you need this cast regularly, define one with `CREATE CAST`. Verify the types are actually compatible in meaning before forcing a conversion.

## Example

*Illustrative* — a cast with no defined path.

```sql
SELECT ROW(1,2)::integer;
```

Produces:

```text
ERROR:  cannot cast type record to integer
```

## Related

- [cannot accept a value of type %s](./cannot-accept-a-value-of-type.md)
- [arguments declared are not all alike](./arguments-declared-are-not-all-alike.md)
