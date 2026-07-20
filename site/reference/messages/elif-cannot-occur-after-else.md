---
message: "\\elif: cannot occur after \\else"
slug: elif-cannot-occur-after-else
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/command.c:2206"
reproduced: false
---

# `\elif: cannot occur after \else`

## What it means

A psql `\elif` meta-command appeared after an `\else` in the same conditional block. Once `\else` is reached, no further `\elif` branches are allowed.

## When it happens

It fires while psql processes a `\if`/`\elif`/`\else`/`\endif` block where an `\elif` follows the `\else`.

## How to fix

Reorder the block so all `\elif` branches come before `\else`. The structure is `\if`, then any number of `\elif`, then an optional `\else`, then `\endif`.

## Example

*Illustrative* — an \elif after \else.

```text
\if :x
\else
\elif :y
-- \elif: cannot occur after \else
```

## Related

- [\elif: no matching \if](./elif-no-matching-if.md)
- [\else: cannot occur after \else](./else-cannot-occur-after-else.md)
