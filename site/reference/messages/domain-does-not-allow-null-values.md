---
message: "domain %s does not allow null values"
slug: domain-does-not-allow-null-values
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NOT_NULL_VIOLATION
    code: "23502"
call_sites:
  - "postgres/src/backend/commands/copyfromparse.c:1085"
reproduced: false
---

# `domain %s does not allow null values`

## What it means

A value being stored in a `NOT NULL` domain was null. The placeholder is the domain name. A domain declared `NOT NULL` rejects null values wherever it is used.

## When it happens

It fires during `COPY`, `INSERT`, `UPDATE`, or a cast when a null reaches a column or expression typed as a `NOT NULL` domain.

## How to fix

Provide a non-null value for the domain-typed column, or relax the domain with `ALTER DOMAIN ... DROP NOT NULL` if nulls should be allowed. During `COPY`, check that the input column is not blank where the domain forbids null.

## Example

*Illustrative* — a null into a NOT NULL domain.

```sql
INSERT INTO t (d) VALUES (NULL);
-- domain positive_int does not allow null values
```

## Related

- [domain constraint has NULL conbin](./domain-constraint-has-null-conbin.md)
- [empty WITHOUT OVERLAPS value found in column in relation](./empty-without-overlaps-value-found-in-column-in-relation.md)
