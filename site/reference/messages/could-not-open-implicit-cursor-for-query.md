---
message: "could not open implicit cursor for query \"%s\": %s"
slug: could-not-open-implicit-cursor-for-query
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:5894"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:9107"
reproduced: false
---

# `could not open implicit cursor for query "%s": %s`

## What it means

A PL/pgSQL `FOR ... IN query LOOP` (or similar) could not open the implicit cursor it uses to iterate the query. The first `%s` is the query and the second is the underlying error.

## When it happens

The loop's query could not be planned or executed — a missing relation, a type mismatch, or a permission error. It fires when the loop starts.

## How to fix

Read the nested error; it identifies the fault. Correct the query used in the `FOR` loop and re-run the function.

## Example

*Illustrative* — a FOR-loop query over a missing relation.

```text
ERROR:  could not open implicit cursor for query "SELECT * FROM missing": relation "missing" does not exist
```

## Related

- [could not open cursor](./could-not-open-cursor.md)
- [cursor variable is null](./cursor-variable-is-null.md)
