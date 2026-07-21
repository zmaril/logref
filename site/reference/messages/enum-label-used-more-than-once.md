---
message: "enum label \"%s\" used more than once"
slug: enum-label-used-more-than-once
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/catalog/pg_enum.c:185"
reproduced: false
---

# `enum label "%s" used more than once`

## What it means

A `CREATE TYPE ... AS ENUM` (or `ALTER TYPE ... ADD VALUE`) listed the same label twice. Enum labels must be unique within the type. The placeholder is the label.

## When it happens

It fires from `CREATE TYPE ... AS ENUM` when the label list contains a duplicate, or from `ALTER TYPE ... ADD VALUE` when the value already exists.

## How to fix

Remove the duplicate label from the enum definition. Each enum label must appear exactly once; if you need it, it is already present.

## Example

*Illustrative* — a duplicated enum label.

```sql
CREATE TYPE mood AS ENUM ('happy', 'sad', 'happy');
-- enum label "happy" used more than once
```

## Related

- [enum data types are not binary-compatible](./enum-data-types-are-not-binary-compatible.md)
- [element label not found](./element-label-not-found.md)
