---
message: "\\copy: parse error at \"%s\""
slug: copy-parse-error-at
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/copy.c:253"
reproduced: false
---

# `\copy: parse error at "%s"`

## What it means

psql could not parse the `\copy` meta-command near the quoted token. The `\copy` syntax was not understood at that point.

## When it happens

It happens in psql when `\copy` is written with a syntax error, such as a misplaced keyword or a missing `TO`/`FROM`.

## How to fix

Correct the `\copy` syntax at the reported token. The form is `\copy { table [(cols)] | (query) } { FROM | TO } 'file' [ options ]`. Check the option keywords and quoting.

## Example

*Illustrative* — a \copy parse error.

```text
\copy: parse error at "xyzzy"
```

## Related

- [\copy: parse error at end of line](./copy-parse-error-at-end-of-line.md)
- [\copy: arguments required](./copy-arguments-required.md)
