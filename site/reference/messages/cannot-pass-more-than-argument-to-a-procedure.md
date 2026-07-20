---
message: "cannot pass more than %d argument to a procedure"
slug: cannot-pass-more-than-argument-to-a-procedure
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_TOO_MANY_ARGUMENTS
    code: "54023"
call_sites:
  - "postgres/src/backend/commands/functioncmds.c:2264"
reproduced: false
---

# `cannot pass more than %d argument to a procedure`

## What it means

A procedure definition or call used more arguments than a procedure may take. Postgres caps the number of arguments to a routine, and the procedure exceeded it. The placeholder is the maximum argument count.

## When it happens

It occurs when `CREATE PROCEDURE` or a `CALL` names more arguments than the limit.

## How to fix

Reduce the number of arguments. Group related values into a composite type or an array and pass that single argument, or split the procedure's work across several routines.

## Example

*Illustrative* — too many procedure arguments.

```text
ERROR:  cannot pass more than 100 argument to a procedure
```

## Related

- [cannot partition using more than columns](./cannot-partition-using-more-than-columns.md)
- [cannot remove parameter defaults from existing function](./cannot-remove-parameter-defaults-from-existing-function.md)
