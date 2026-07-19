---
message: "invalid enum label \"%s\""
slug: invalid-enum-label
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_NAME
    code: "42602"
call_sites:
  - "postgres/src/backend/catalog/pg_enum.c:168"
  - "postgres/src/backend/catalog/pg_enum.c:325"
  - "postgres/src/backend/catalog/pg_enum.c:635"
reproduced: false
---

# `invalid enum label "%s"`

## What it means

A label given for an enum type is not acceptable. Enum labels have length and content limits, and the supplied text fell outside them or was otherwise rejected as a valid label.

## When it happens

Creating or adding an enum label with `CREATE TYPE ... AS ENUM (...)` or `ALTER TYPE ... ADD VALUE` where a label is empty, exceeds the maximum label length, or is otherwise malformed.

## How to fix

Use labels that fit the length limit and contain the intended text. Quote labels that contain spaces or special characters, and trim any accidental whitespace. If a label is too long, shorten it or reconsider whether an enum is the right representation.

## Example

*Illustrative* — an unacceptable enum label.

```sql
ALTER TYPE mood ADD VALUE '';  -- an empty label is not valid
```

## Related

- [invalid internal value for enum](./invalid-internal-value-for-enum.md)
- [invalid encoding name](./invalid-encoding-name.md)
