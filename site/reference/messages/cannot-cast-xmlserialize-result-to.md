---
message: "cannot cast XMLSERIALIZE result to %s"
slug: cannot-cast-xmlserialize-result-to
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CANNOT_COERCE
    code: "42846"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:2553"
reproduced: false
---

# `cannot cast XMLSERIALIZE result to %s`

## What it means

An `XMLSERIALIZE(... AS type)` named a target type the result cannot become. `XMLSERIALIZE` produces a character string, so it can only be serialized to a text-like type, not to an arbitrary target. The placeholder is the requested type.

## When it happens

It occurs when `XMLSERIALIZE` specifies a non-character target type, such as an integer or a composite type.

## How to fix

Serialize to a character type such as `text` or `varchar`. If you need another type, cast the resulting text explicitly after serialization instead of asking `XMLSERIALIZE` to produce it directly.

## Example

*Illustrative* — serializing to a non-text type.

```sql
SELECT XMLSERIALIZE(CONTENT x AS integer);
```

## Related

- [cannot coerce to int](./cannot-coerce-to-int.md)
- [cannot cast to for number](./cannot-cast-to-for-number.md)
