---
message: "query for CALL statement is not a CallStmt"
slug: query-for-call-statement-is-not-a-callstmt
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:2346"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:2350"
reproduced: false
---

# `query for CALL statement is not a CallStmt`

## What it means

Internal error. Code executing a `CALL` expected its parsed/planned query to be a `CallStmt` node and found a different node type. It is a consistency check between a statement and the machinery that runs procedures.

## When it happens

It fires from procedure-execution glue (for example in PL/pgSQL's `CALL` handling) when the plan tree does not have the expected shape. Ordinary `CALL` statements do not raise it.

## How to fix

This is an internal consistency guard. If a real `CALL` triggers it, capture the procedure and the calling context and report it as a reproducible bug.

## Example

*Illustrative* — a CALL whose plan is not a CallStmt.

```text
ERROR:  query for CALL statement is not a CallStmt
```

## Related

- [procedure %s does not exist](./procedure-does-not-exist.md)
- [prepared statement is not a SELECT](./prepared-statement-is-not-a-select.md)
