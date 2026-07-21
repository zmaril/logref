---
message: "\\df does not take a \"%c\" option with server version %s"
slug: df-does-not-take-a-option-with-server-version
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:315"
reproduced: false
---

# `\df does not take a "%c" option with server version %s`

## What it means

The psql `\df` meta-command was given a modifier option that the connected server version does not support. The placeholders are the option character and the server version. Newer `\df` flags need a newer backend.

## When it happens

It fires in psql when you pass a `\df` sub-option (such as a function-kind filter) while connected to a server too old to provide the needed catalog information.

## How to fix

Drop the unsupported option, or connect to a newer server. The set of `\df` options depends on the backend version; run `\?` in psql to see what the current connection supports.

## Example

*Illustrative* — a newer `\df` option against an old server.

```text
\dfp
-- \df does not take a "p" option with server version 9.5
```

## Related

- [\df only takes [...] as options](./df-only-takes-as-options.md)
- [Did not find any relation named](./did-not-find-any-relation-named.md)
