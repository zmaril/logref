---
message: "\\copy: parse error at end of line"
slug: copy-parse-error-at-end-of-line
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/copy.c:255"
reproduced: false
---

# `\copy: parse error at end of line`

## What it means

psql reached the end of the `\copy` command while still expecting more input. The `\copy` specification is incomplete.

## When it happens

It happens in psql when `\copy` is missing a required element, such as the direction or the file name, so parsing runs out of tokens.

## How to fix

Supply the complete `\copy` command. Ensure it includes the table or query, `FROM` or `TO`, and the file (or `STDIN`/`STDOUT`), plus any options.

## Example

*Illustrative* — an incomplete \copy command.

```text
\copy: parse error at end of line
```

## Related

- [\copy: parse error at](./copy-parse-error-at.md)
- [\copy: arguments required](./copy-arguments-required.md)
