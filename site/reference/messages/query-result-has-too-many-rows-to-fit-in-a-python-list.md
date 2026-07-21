---
message: "query result has too many rows to fit in a Python list"
slug: query-result-has-too-many-rows-to-fit-in-a-python-list
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/pl/plpython/plpy_cursorobject.c:461"
  - "postgres/src/pl/plpython/plpy_spi.c:399"
reproduced: false
---

# `query result has too many rows to fit in a Python list`

## What it means

A PL/Python function ran a query whose result set is larger than a Python list can hold on this platform, so the result cannot be materialized into a list object.

## When it happens

It arises in PL/Python when `plpy.execute` (without a row limit) returns an enormous number of rows, exceeding Python's maximum list length for the build.

## How to fix

Do not fetch the whole result at once. Use a cursor with `plpy.cursor()` and iterate in batches, or add a `LIMIT`/`WHERE` to reduce the result size. Streaming avoids building one giant list.

## Example

*Illustrative* — a PL/Python query returning too many rows for a list.

```text
ERROR:  query result has too many rows to fit in a Python list
```

## Related

- [query returned %d row instead of one: %s](./query-returned-row-instead-of-one.md)
- [retrieved too many tuples in a bounded sort](./retrieved-too-many-tuples-in-a-bounded-sort.md)
