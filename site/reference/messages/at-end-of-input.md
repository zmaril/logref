---
message: "%s at end of input"
slug: at-end-of-input
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_scanner.c:540"
reproduced: false
---

# `%s at end of input`

## What it means

The parser reached the end of the input while still expecting more tokens to complete the statement, so the command is syntactically incomplete. The leading text names what was expected.

## When it happens

It occurs when a statement is truncated — a missing closing token, an unfinished clause, or a command cut off before its end.

## How to fix

Complete the statement. The prefix before this phrase describes what the parser wanted; add the missing part (a closing parenthesis or quote, the rest of a clause, a terminating value). Check for a truncated string or a command assembled incorrectly by an application.

## Example

*Illustrative* — a statement ending prematurely.

```text
ERROR:  syntax error at end of input
```

## Related

- [%s at or near "%s"](./at-or-near.md)
- [at least one action needs to be specified](./at-least-one-action-needs-to-be-specified.md)
