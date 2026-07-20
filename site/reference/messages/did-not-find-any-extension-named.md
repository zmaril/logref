---
message: "Did not find any extension named \"%s\"."
slug: did-not-find-any-extension-named
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:6348"
reproduced: false
---

# `Did not find any extension named "%s".`

## What it means

A psql `\dx` command with a name pattern matched no installed extension. The placeholder is the pattern. This is psql reporting an empty result, not a server error.

## When it happens

It fires when `\dx pattern` finds no extension whose name matches, because the extension is not installed or the pattern does not match.

## How to fix

List everything installed with a bare `\dx`, and check the spelling and any wildcards in your pattern. Install the extension first with `CREATE EXTENSION` if it is genuinely missing.

## Example

*Illustrative* — a pattern matching no extension.

```text
\dx nosuchext
-- Did not find any extension named "nosuchext".
```

## Related

- [Did not find any extensions](./did-not-find-any-extensions.md)
- [Did not find any relation named](./did-not-find-any-relation-named.md)
