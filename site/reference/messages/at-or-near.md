---
message: "%s at or near \"%s\""
slug: at-or-near
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_scanner.c:556"
reproduced: false
---

# `%s at or near "%s"`

## What it means

The parser found a syntax error at or just before the quoted token, which is the point where the input stopped making sense. The leading text names the kind of problem.

## When it happens

It is the common syntax-error form, raised whenever a statement's grammar is violated — a misspelled keyword, a misplaced clause, a missing comma, or an unexpected token.

## How to fix

Look at the quoted token and the text just before it: that is where the parser got stuck. Fix the surrounding syntax — check keyword spelling, clause order, punctuation, and that the statement matches the documented grammar for the command.

## Example

*Illustrative* — a syntax error at a specific token.

```sql
SELECT * FORM t;  -- ERROR:  syntax error at or near "t"
```

## Related

- [syntax error at end of input](./at-end-of-input.md)
- [argument of must be a name](./argument-of-must-be-a-name.md)
