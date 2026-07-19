---
message: "exclusion constraints not possible for domains"
slug: exclusion-constraints-not-possible-for-domains
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/typecmds.c:1010"
reproduced: false
---

# `exclusion constraints not possible for domains`

## What it means

A `CREATE DOMAIN` or `ALTER DOMAIN` tried to attach an exclusion constraint. Domains are scalar types and can carry `CHECK` and `NOT NULL` constraints, but not exclusion constraints, which apply across rows of a table.

## When it happens

It fires from domain DDL that includes an `EXCLUDE` constraint clause.

## How to fix

Remove the exclusion constraint from the domain. Enforce single-value rules with a `CHECK` constraint on the domain instead. If you need an across-row exclusion rule, define it on the table that uses the domain, not on the domain type.

## Example

*Illustrative* — domains take CHECK, not EXCLUDE.

```sql
CREATE DOMAIN d AS int CHECK (VALUE > 0);  -- allowed
```

## Related

- [exclusion constraints are not supported on foreign tables](./exclusion-constraints-are-not-supported-on-foreign-tables.md)
- [exclusion constraint record missing for rel](./exclusion-constraint-record-missing-for-rel.md)
