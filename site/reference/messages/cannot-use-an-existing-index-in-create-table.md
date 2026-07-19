---
message: "cannot use an existing index in CREATE TABLE"
slug: cannot-use-an-existing-index-in-create-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:2423"
reproduced: false
---

# `cannot use an existing index in CREATE TABLE`

## What it means

A `CREATE TABLE` tried to build a constraint from an existing index with `USING INDEX`. That form is only available on `ALTER TABLE`, because the index must already exist on a table before it can back a constraint, so it is rejected inside `CREATE TABLE`.

## When it happens

It occurs when a primary key or unique constraint in a `CREATE TABLE` statement references an existing index rather than defining fresh columns.

## How to fix

Define the constraint by columns in `CREATE TABLE`, or create the table first and then attach the constraint with `ALTER TABLE ... ADD CONSTRAINT ... USING INDEX`.

## Example

*Illustrative* — USING INDEX inside CREATE TABLE.

```text
ERROR:  cannot use an existing index in CREATE TABLE
```

## Related

- [cannot use more than columns in an index](./cannot-use-more-than-columns-in-an-index.md)
- [cannot use non-unique index as replica identity](./cannot-use-non-unique-index-as-replica-identity.md)
