---
message: "\\else: cannot occur after \\else"
slug: else-cannot-occur-after-else
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/command.c:2275"
reproduced: false
---

# `\else: cannot occur after \else`

## What it means

A psql `\else` meta-command appeared after another `\else` in the same conditional block. A block may have at most one `\else`.

## When it happens

It fires while psql processes a `\if` block that contains two `\else` branches.

## How to fix

Keep only one `\else` per `\if` block, placed after any `\elif` branches and before `\endif`. Remove the extra `\else`.

## Example

*Illustrative* — a second \else.

```text
\if :x
\else
\else
-- \else: cannot occur after \else
```

## Related

- [\else: no matching \if](./else-no-matching-if.md)
- [\elif: cannot occur after \else](./elif-cannot-occur-after-else.md)
