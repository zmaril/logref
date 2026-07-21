---
message: "cannot use the \"%s\" option without \"%s\" or \"%s\""
slug: cannot-use-the-option-without-or
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/scripts/vacuumdb.c:307"
reproduced: false
---

# `cannot use the "%s" option without "%s" or "%s"`

## What it means

A client tool was given an option that only makes sense alongside one of two other options, but neither of those was supplied. The first name is the dependent option, and the other two are the options it requires.

## When it happens

It occurs with tools such as `pg_receivewal` or `pg_recvlogical` when a flag that depends on a mode option is used without that mode, for example an option that needs either a create or a start action.

## How to fix

Add one of the required options, or drop the dependent one. Read the message for the two names it lists and supply whichever fits your intent.

## Example

*Illustrative* — a dependent option used alone.

```text
pg_recvlogical: error: cannot use the "endpos" option without "start" or "drop-slot"
```

## Related

- [cannot use the option when performing full vacuum](./cannot-use-the-option-when-performing-full-vacuum.md)
- [cannot use with a logical replication slot](./cannot-use-with-a-logical-replication-slot.md)
