---
message: "column \"%s.%s\" must appear in the GROUP BY clause or be used in an aggregate function"
slug: column-must-appear-in-the-group-by-clause-or-be-used-in-an-aggregate-function
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_GROUPING_ERROR
    code: "42803"
call_sites:
  - "postgres/src/backend/parser/parse_agg.c:1572"
reproduced: true
---

# `column "%s.%s" must appear in the GROUP BY clause or be used in an aggregate function`

**Severity:** ERROR · SQLSTATE `42803` (ERRCODE_GROUPING_ERROR)

## What it means

A grouped query selected a column that is neither grouped nor aggregated. Once a query has a `GROUP BY` (or any aggregate), every output column must either be one of the grouping keys or be wrapped in an aggregate such as `sum`, `count`, or `max` — otherwise the value is ambiguous across the rows collapsed into each group. The placeholders name the table and column.

## When it happens

Writing `SELECT a, count(*) FROM t` without `GROUP BY a`, or adding an aggregate to a `SELECT` list that still contains a bare column. It is one of the most common SQL mistakes when moving from row-by-row to grouped queries.

## How to fix

Either add the column to `GROUP BY` (so each distinct value forms a group), or wrap it in an aggregate that picks one value per group (`max(a)`, `min(a)`, `array_agg(a)`). If you want one representative row per group rather than an aggregate, `DISTINCT ON` is often the cleaner tool. Decide which column is the grouping key and which are being summarized.

## Example

*Reproduced* — The query-semantics reproducer scenario selects an ungrouped column (`11_query_semantics.sql`).

```sql
SELECT id, count(*) FROM repro.child;
```

Produces:

```text
ERROR:  column "repro.child.id" must appear in the GROUP BY clause or be used in an aggregate function
```

## Source

Emitted from [`postgres/src/backend/parser/parse_agg.c:1572`](https://github.com/postgres/postgres/blob/master/src/backend/parser/parse_agg.c#L1572).

## SQLSTATE

- `42803` — **ERRCODE_GROUPING_ERROR**. Class 42 (Syntax Error or Access Rule Violation).

## Related

- [column "%s" does not exist](./column-does-not-exist-712d76.md)
