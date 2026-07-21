---
message: "\\copy: arguments required"
slug: copy-arguments-required
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/copy.c:98"
reproduced: false
---

# `\copy: arguments required`

## What it means

The psql `\copy` meta-command was invoked without arguments. `\copy` needs a table/query and a direction and file to operate on.

## When it happens

It happens in psql when `\copy` is typed with nothing after it.

## How to fix

Provide the full `\copy` specification, for example `\copy tab TO 'file.csv' CSV` or `\copy tab FROM 'file.csv' CSV`. See `\?` for the `\copy` syntax.

## Example

*Illustrative* — \copy with no arguments.

```text
\copy: arguments required
```

## Related

- [\copy: parse error at](./copy-parse-error-at.md)
- [\copy: parse error at end of line](./copy-parse-error-at-end-of-line.md)
