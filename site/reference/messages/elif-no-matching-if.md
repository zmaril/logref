---
message: "\\elif: no matching \\if"
slug: elif-no-matching-if
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/command.c:2211"
reproduced: false
---

# `\elif: no matching \if`

## What it means

A psql `\elif` meta-command was used without an open `\if` block. `\elif` only makes sense inside a conditional started by `\if`.

## When it happens

It fires when psql sees `\elif` with no matching `\if` currently open.

## How to fix

Start the conditional with `\if` before using `\elif`, and make sure a prior `\endif` did not already close the block. Every `\elif` must sit between an `\if` and its `\endif`.

## Example

*Illustrative* — an \elif with no \if.

```text
\elif :y
-- \elif: no matching \if
```

## Related

- [\elif: cannot occur after \else](./elif-cannot-occur-after-else.md)
- [\endif: no matching \if](./endif-no-matching-if.md)
