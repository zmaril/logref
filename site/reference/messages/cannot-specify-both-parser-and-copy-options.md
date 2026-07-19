---
message: "cannot specify both PARSER and COPY options"
slug: cannot-specify-both-parser-and-copy-options
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/tsearchcmds.c:944"
reproduced: false
---

# `cannot specify both PARSER and COPY options`

## What it means

A `CREATE TEXT SEARCH CONFIGURATION` statement named both a `PARSER` and a `COPY` source. Copying an existing configuration takes its parser from the copied object, so a separate `PARSER` clause conflicts.

## When it happens

It occurs when `CREATE TEXT SEARCH CONFIGURATION` is written with both `PARSER = ...` and `COPY = ...` in the same statement.

## How to fix

Keep one. Use `COPY` to clone an existing configuration and its parser, or use `PARSER` to build a fresh configuration. Remove the other clause and rerun.

## Example

*Illustrative* — parser and copy both requested.

```sql
CREATE TEXT SEARCH CONFIGURATION c (PARSER = default, COPY = english);
-- ERROR:  cannot specify both PARSER and COPY options
```

## Related

- [cannot specify both "a" and "b"](./cannot-specify-both-and-f3ca8a.md)
- [cannot specify statistics kinds when building univariate statistics](./cannot-specify-statistics-kinds-when-building-univariate-statistics.md)
