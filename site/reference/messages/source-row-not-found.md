---
message: "source row not found"
slug: source-row-not-found
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CARDINALITY_VIOLATION
    code: "21000"
call_sites:
  - "postgres/contrib/dblink/dblink.c:2154"
  - "postgres/contrib/dblink/dblink.c:2271"
reproduced: false
---

# `source row not found`

## What it means

A `MERGE` command could not locate a source row it expected while processing an action. The source relation did not provide a matching row where the merge logic required one. This is a cardinality problem in the merge.

## When it happens

It arises during `MERGE` when the source query's rows do not line up as the `WHEN` clauses assume — for example a source that changes or fails to yield the anticipated row during execution.

## How to fix

Ensure the `MERGE` source is a stable query that yields exactly the rows the join expects, and that the `ON` condition matches at most one source row per target. Materialize a volatile source (into a temp table or CTE) so it does not shift mid-statement.

## Example

*Illustrative* — a MERGE whose source row could not be found.

```text
ERROR:  source row not found
```

## Related

- [query returned no rows](./query-returned-no-rows.md)
- [tuple to be deleted was already modified by an operation triggered by the current command](./tuple-to-be-deleted-was-already-modified-by-an-operation-triggered-by-the.md)
