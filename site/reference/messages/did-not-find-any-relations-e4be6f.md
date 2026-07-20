---
message: "Did not find any relations."
slug: did-not-find-any-relations-e4be6f
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:1494"
  - "postgres/src/bin/psql/describe.c:4281"
reproduced: false
---

# `Did not find any relations.`

## What it means

A `psql` listing command (for example `\dt` or `\d` with a pattern) matched no relations. It is informational: the pattern found nothing to display.

## When it happens

Running a `\d`-family command in a database or schema that has no matching relations, or with a name pattern that matches none.

## How to fix

This is not an error. Broaden the pattern, check the current database and `search_path`, or confirm the objects exist. Nothing is wrong if you expected an empty result.

## Example

*Illustrative* — a pattern matched no tables.

```text
psql: Did not find any relations.
```

## Related

- [error message from server](./error-message-from-server.md)
- [foreign table does not exist](./foreign-table-does-not-exist.md)
