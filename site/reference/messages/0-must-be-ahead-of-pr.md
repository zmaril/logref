---
message: "\"0\" must be ahead of \"PR\""
slug: 0-must-be-ahead-of-pr
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/utils/adt/formatting.c:1216"
reproduced: false
---

# `"0" must be ahead of "PR"`

## What it means

A parser that validates an ordered sequence of tokens rejected the input because a token that must come before the `PR` marker (here the literal `0`) was found in the wrong position.

## When it happens

It is raised as a syntax error by the specific parser that emits this check when the required ordering of elements around the `PR` token is violated in the input string.

## How to fix

This is a narrow, format-specific parse rule. Consult the syntax the feature accepts and reorder the input so the required token precedes `PR`. If you did not knowingly use this feature, check which extension or input format produced the message and correct the offending value.

## Example

*Illustrative* — a token in the wrong order for this parser.

```text
ERROR:  "0" must be ahead of "PR"
```

## Related

- ["9" must be ahead of "PR"](./9-must-be-ahead-of-pr.md)
- [%s at or near "%s"](./at-or-near.md)
