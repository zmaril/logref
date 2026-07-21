---
message: "can't negate an empty subexpression"
slug: can-t-negate-an-empty-subexpression
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/prep/prepqual.c:76"
reproduced: false
---

# `can't negate an empty subexpression`

## What it means

A text-search or JSON-path parse encountered a negation applied to nothing — a `!` or `NOT` with no operand to negate. An empty subexpression cannot be negated.

## When it happens

It occurs when building a `tsquery` or similar expression whose input has a negation operator with no following term, often from malformed or programmatically generated query text.

## How to fix

Fix the query text so every negation has an operand. Validate or sanitize user-supplied search strings, and when constructing queries in code, ensure a negation is never emitted without a term to apply it to.

## Example

*Illustrative* — a dangling negation.

```sql
SELECT to_tsquery('!');
```

## Related

- [boolean jsonpath item cannot have next item](./boolean-jsonpath-item-cannot-have-next-item.md)
- [can only be executed as a top-level statement](./can-only-be-executed-as-a-top-level-statement.md)
