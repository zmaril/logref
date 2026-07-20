---
message: "\\endif: no matching \\if"
slug: endif-no-matching-if
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/command.c:2320"
reproduced: false
---

# `\endif: no matching \if`

## What it means

A psql `\endif` meta-command was used without an open `\if` block. `\endif` only makes sense as the close of a conditional started by `\if`.

## When it happens

It fires when psql sees `\endif` with no matching `\if` currently open.

## How to fix

Open the conditional with `\if` before `\endif`, and make sure you have not already closed the block with an earlier `\endif`. Each `\if` needs exactly one closing `\endif`.

## Example

*Illustrative* — an \endif with no \if.

```text
\endif
-- \endif: no matching \if
```

## Related

- [\else: no matching \if](./else-no-matching-if.md)
- [\elif: no matching \if](./elif-no-matching-if.md)
