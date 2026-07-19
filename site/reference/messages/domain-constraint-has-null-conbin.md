---
message: "domain \"%s\" constraint \"%s\" has NULL conbin"
slug: domain-constraint-has-null-conbin
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/typcache.c:1176"
reproduced: false
---

# `domain "%s" constraint "%s" has NULL conbin`

## What it means

An internal catalog guard. A domain's `CHECK` constraint row in `pg_constraint` has a null `conbin` (the compiled expression), which should never happen for a valid constraint. The placeholders are the domain and constraint names.

## When it happens

It fires when the type cache loads a domain's constraints and finds one with no stored expression, indicating catalog damage rather than a user error.

## How to fix

This is not a routine user error. It suggests a damaged `pg_constraint` entry. Investigate catalog integrity; recreating the domain constraint (drop and re-add with `ALTER DOMAIN`) may repair the row. Capture the case for the PostgreSQL developers.

## Example

*Illustrative* — the guard as it appears in the log.

```text
ERROR:  domain "positive_int" constraint "positive_int_check" has NULL conbin
```

## Related

- [domain does not allow null values](./domain-does-not-allow-null-values.md)
- [does not require a toast table](./does-not-require-a-toast-table.md)
