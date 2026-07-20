---
message: "%s options %s and %s cannot be used together"
slug: options-and-cannot-be-used-together-72fe42
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/explain_state.c:207"
  - "postgres/src/backend/commands/matview.c:211"
reproduced: false
---

# `%s options %s and %s cannot be used together`

## What it means

Two command options were supplied that are mutually exclusive. The first placeholder names the command or context, and the other two name the conflicting options.

## When it happens

It fires when a utility or SQL command is given a pair of flags that contradict each other — for example two output modes, or an option that only makes sense in the absence of another.

## How to fix

Choose one of the two options and remove the other. The message names both; consult the command's documentation to decide which applies to your intent.

## Example

*Illustrative* — passing two conflicting flags to one command.

```text
ERROR:  pg_dump options -a and -s cannot be used together
```

## Related

- [subscription with %s must also set %s](./subscription-with-must-also-set.md)
- [parameter name "%s" used more than once](./parameter-name-used-more-than-once.md)
