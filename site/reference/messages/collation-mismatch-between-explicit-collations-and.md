---
message: "collation mismatch between explicit collations \"%s\" and \"%s\""
slug: collation-mismatch-between-explicit-collations-and
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_COLLATION_MISMATCH
    code: "42P21"
call_sites:
  - "postgres/src/backend/parser/parse_collate.c:855"
reproduced: false
---

# `collation mismatch between explicit collations "%s" and "%s"`

## What it means

An expression combined two values that each carry a different explicit `COLLATE` clause. When two explicit collations meet, the server cannot choose between them, so it reports a conflict.

## When it happens

It occurs when an operation such as a comparison or concatenation has both operands given conflicting explicit `COLLATE` clauses.

## How to fix

Apply a single explicit `COLLATE` to the whole expression, or make the two sides use the same collation. Remove the conflicting clause so only one explicit collation applies.

## Example

*Illustrative* — two explicit collations meeting.

```sql
SELECT (a COLLATE "C") < (b COLLATE "en_US") FROM t;
-- ERROR:  collation mismatch between explicit collations "C" and "en_US"
```

## Related

- [collation of DEFAULT expression conflicts with RETURNING clause](./collation-of-default-expression-conflicts-with-returning-clause.md)
- [column has a collation conflict](./column-has-a-collation-conflict.md)
