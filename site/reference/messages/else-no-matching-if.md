---
message: "\\else: no matching \\if"
slug: else-no-matching-if
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/command.c:2280"
reproduced: false
---

# `\else: no matching \if`

## What it means

A psql `\else` meta-command was used without an open `\if` block. `\else` only makes sense inside a conditional started by `\if`.

## When it happens

It fires when psql sees `\else` with no matching `\if` currently open.

## How to fix

Open the conditional with `\if` before `\else`, and make sure a prior `\endif` did not already close the block. Every `\else` must sit between an `\if` and its `\endif`.

## Example

*Illustrative* — an \else with no \if.

```text
\else
-- \else: no matching \if
```

## Related

- [\else: cannot occur after \else](./else-cannot-occur-after-else.md)
- [\endif: no matching \if](./endif-no-matching-if.md)
