---
message: "cannot use system column \"%s\" in column generation expression"
slug: cannot-use-system-column-in-column-generation-expression
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_COLUMN_REFERENCE
    code: "42P10"
call_sites:
  - "postgres/src/backend/parser/parse_relation.c:750"
reproduced: false
---

# `cannot use system column "%s" in column generation expression`

## What it means

A generated column's expression referenced a system column such as `ctid` or `xmin`. System columns are not stable stored user data, so a generation expression may not depend on them.

## When it happens

It occurs on `CREATE TABLE` or `ALTER TABLE` when a `GENERATED ALWAYS AS (...)` expression names a system column.

## How to fix

Rewrite the expression to use only ordinary user columns. Remove the system column reference and base the generated value on stored data.

## Example

*Illustrative* — a system column in a generation expression.

```sql
CREATE TABLE t (a int, g tid GENERATED ALWAYS AS (ctid) STORED);
-- ERROR:  cannot use system column "ctid" in column generation expression
```

## Related

- [cannot use generated column in column generation expression](./cannot-use-generated-column-in-column-generation-expression.md)
- [cannot use system column in partition key](./cannot-use-system-column-in-partition-key.md)
