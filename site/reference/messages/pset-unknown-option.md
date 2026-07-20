---
message: "\\pset: unknown option: %s"
slug: pset-unknown-option
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/command.c:5437"
  - "postgres/src/bin/psql/command.c:5652"
reproduced: false
---

# `\pset: unknown option: %s`

## What it means

A psql `\pset` meta-command was given an option name it does not recognize. The placeholder is the option. `\pset` controls psql's output formatting, and only a fixed set of option names is valid.

## When it happens

It arises when typing `\pset something` in psql with a misspelled or non-existent formatting option.

## How to fix

Run `\pset` with no arguments to list current settings and their names, or consult the psql documentation. Use the correct option name (for example `format`, `border`, `null`, `pager`).

## Example

*Illustrative* — an unknown psql formatting option.

```text
\pset: unknown option: colour
```

## Related

- [query ignored; use \endif or Ctrl-C to exit current \if block](./query-ignored-use-endif-or-ctrl-c-to-exit-current-if-block.md)
- [storage "%s" not recognized](./storage-not-recognized.md)
