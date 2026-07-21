---
message: "could not open cursor: %s"
slug: could-not-open-cursor
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:2991"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:4895"
reproduced: false
---

# `could not open cursor: %s`

## What it means

A PL/pgSQL `OPEN` statement failed to open a bound cursor. The `%s` carries the underlying error from planning or executing the cursor's query. The failure is a passthrough of whatever the query itself raised.

## When it happens

The cursor's query could not be planned or started — a missing object, a permissions error, or a runtime error in the query. It fires when a PL/pgSQL function opens a cursor variable.

## How to fix

Read the nested error text; it names the real cause. Fix the cursor's query (object names, privileges, parameter types) and re-run the function.

## Example

*Illustrative* — opening a cursor over a missing table.

```text
ERROR:  could not open cursor: relation "missing" does not exist
```

## Related

- [could not open implicit cursor for query](./could-not-open-implicit-cursor-for-query.md)
- [cursor already in use](./cursor-already-in-use.md)
