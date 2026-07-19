---
message: "no query buffer"
slug: no-query-buffer
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/command.c:1357"
  - "postgres/src/bin/psql/command.c:1458"
  - "postgres/src/bin/psql/command.c:3279"
reproduced: false
---

# `no query buffer`

## What it means

A psql command that operates on the current query buffer was run when the buffer was empty. Meta-commands like editing or executing the buffer need something in it, and there was nothing to act on.

## When it happens

Running a psql meta-command such as `\e`, `\g`, or `\p` at the start of a session or right after the buffer was cleared, with no SQL typed or loaded yet.

## How to fix

Type or load a statement into the query buffer first, then run the meta-command. If a script triggers it, make sure a statement precedes the buffer-dependent command.

## Example

*Illustrative* — a buffer command with nothing buffered.

```text
postgres=# \g
no query buffer
```

## Related

- [query string argument of execute is null](./query-string-argument-of-execute-is-null.md)
- [query returned more than one row](./query-returned-more-than-one-row.md)
