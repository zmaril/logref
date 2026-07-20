---
message: "--%s requires a value"
slug: requires-a-value
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/bootstrap/bootstrap.c:292"
  - "postgres/src/backend/postmaster/postmaster.c:643"
  - "postgres/src/backend/tcop/postgres.c:4050"
reproduced: false
---

# `--%s requires a value`

## What it means

A command-line option that takes a value was supplied without one. The option expects an argument, and none followed it on the command line.

## When it happens

Invoking a server or bootstrap process with an option that needs a value but leaving the value off — for example a flag placed last with nothing after it, or a scripted command line that dropped the argument.

## How to fix

Supply the option's value. Check the tool's help for the expected form, and inspect any wrapper or service definition that builds the command line if the value was lost during assembly.

## Example

*Illustrative* — an option missing its value.

```text
postgres --data-directory  # --data-directory requires a value
```

## Related

- [requires an integer value](./requires-an-integer-value.md)
- [invalid value for option](./invalid-value-for-option.md)
