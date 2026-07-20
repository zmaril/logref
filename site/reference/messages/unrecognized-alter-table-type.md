---
message: "unrecognized alter table type: %d"
slug: unrecognized-alter-table-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:4945"
  - "postgres/src/backend/commands/tablecmds.c:5386"
  - "postgres/src/backend/commands/tablecmds.c:5798"
reproduced: false
---

# `unrecognized alter table type: %d`

## What it means

Internal error. `ALTER TABLE` execution reached a subcommand type code it does not recognize. The parser produces one of a fixed set of subcommand types, and this value matched none of them. It is a consistency check on the command executor.

## When it happens

It should not occur through normal SQL. Reaching it points to an internal inconsistency between the parser and executor for `ALTER TABLE`, not to your command.

## How to fix

Treat it as an internal bug. Capture the `ALTER TABLE` statement and report it. There is no command-side change expected to reliably trigger or avoid it.

## Example

*Illustrative* — emitted internally during ALTER TABLE.

```text
ERROR:  unrecognized alter table type: 99
```

## Related

- [unrecognized cmd type](./unrecognized-cmd-type.md)
- [unknown operation](./unknown-operation.md)
