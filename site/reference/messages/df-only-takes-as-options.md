---
message: "\\df only takes [%s] as options"
slug: df-only-takes-as-options
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:307"
reproduced: false
---

# `\df only takes [%s] as options`

## What it means

The psql `\df` meta-command was given a modifier letter it does not accept. The placeholder lists the valid option letters. `\df` filters functions by kind, and only those letters are meaningful.

## When it happens

It fires in psql when the characters after `\df` are not among the allowed set (such as `a`, `n`, `p`, `t`, `w` for aggregate, normal, procedure, trigger, and window functions).

## How to fix

Use only the listed option letters after `\df`. Run `\?` in psql for the exact list, and remember that filters follow the command with no space, for example `\dfa` for aggregates.

## Example

*Illustrative* — an invalid `\df` option letter.

```text
\dfz
-- \df only takes [anptwS+] as options
```

## Related

- [\df does not take a option with server version](./df-does-not-take-a-option-with-server-version.md)
- [Did not find any relation named](./did-not-find-any-relation-named.md)
