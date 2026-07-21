---
message: "table name \"%s\" specified more than once"
slug: table-name-specified-more-than-once
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_ALIAS
    code: "42712"
call_sites:
  - "postgres/src/backend/parser/analyze.c:3107"
  - "postgres/src/backend/parser/parse_relation.c:467"
reproduced: true
---

# `table name "%s" specified more than once`

## What it means

A statement used the same table alias or name in a place where each must be distinct. The placeholder is the duplicated name. Range-table entries in a query need unique names so references are unambiguous.

## When it happens

It arises when a `FROM`/`UPDATE`/`DELETE` clause lists the same table without distinguishing aliases, or an operation's table list repeats a name — producing an ambiguous reference.

## How to fix

Give each occurrence a distinct alias (`FROM orders o1, orders o2`), or remove the duplicate if it was unintended. Use the aliases to qualify column references so they are unambiguous.

## Example

*Reproduced* — captured from `reproducers/scenarios/23_query_semantics_extended.sql`.

```sql
WITH t AS (SELECT 1) SELECT * FROM t, t;
```

Produces:

```text
ERROR:  table name "t" specified more than once
```

## Related

- [too many column names were specified](./too-many-column-names-were-specified.md)
- [relation "%s" would be inherited from more than once](./relation-would-be-inherited-from-more-than-once.md)
