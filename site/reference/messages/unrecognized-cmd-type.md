---
message: "unrecognized cmd_type: %d"
slug: unrecognized-cmd-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:2169"
  - "postgres/src/pl/plpgsql/src/pl_funcs.c:595"
  - "postgres/src/pl/plpgsql/src/pl_funcs.c:916"
reproduced: false
---

# `unrecognized cmd_type: %d`

## What it means

Internal error. PL/pgSQL execution reached a statement command-type code it does not recognize. Each compiled PL/pgSQL statement carries a command type from a fixed set, and this value matched none. It is a consistency check on the function interpreter.

## When it happens

It should not occur when running normally compiled functions. Reaching it points to an internal inconsistency in the PL/pgSQL executor, not to your function's source.

## How to fix

Treat it as an internal bug. Capture the function and the statement being executed, and report it. There is no source-side change expected to reliably trigger or avoid it.

## Example

*Illustrative* — emitted internally by the PL/pgSQL executor.

```text
ERROR:  unrecognized cmd_type: 42
```

## Related

- [unrecognized alter table type](./unrecognized-alter-table-type.md)
- [unknown operation](./unknown-operation.md)
