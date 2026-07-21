---
message: "unrecognized item type: %d"
slug: unrecognized-item-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/opclasscmds.c:579"
  - "postgres/src/backend/commands/opclasscmds.c:1017"
  - "postgres/src/backend/commands/opclasscmds.c:1107"
reproduced: false
---

# `unrecognized item type: %d`

## What it means

Internal error. Operator-class command code reached an item-type code it does not recognize while processing an operator-class or operator-family element. The element kinds are a fixed set, and the value matched none. It is a consistency check on the command executor.

## When it happens

It should not occur through normal DDL. Reaching it points to an internal inconsistency in operator-class handling, not to your command.

## How to fix

Treat it as an internal bug. Capture the `CREATE`/`ALTER OPERATOR CLASS` or `FAMILY` statement and report it. There is no command-side change expected to reliably trigger or avoid it.

## Example

*Illustrative* — an unrecognized operator-class item type.

```text
ERROR:  unrecognized item type: 5
```

## Related

- [unrecognized integer](./unrecognized-integer.md)
- [invalid opclass definition](./invalid-opclass-definition.md)
