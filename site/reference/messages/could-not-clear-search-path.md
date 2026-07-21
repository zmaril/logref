---
message: "could not clear \"search_path\": %s"
slug: could-not-clear-search-path
passthrough: false
api: [pg_fatal, pg_log_error]
level: [ERROR, FATAL]
call_sites:
  - "postgres/contrib/oid2name/oid2name.c:356"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:607"
  - "postgres/src/bin/pg_basebackup/streamutil.c:230"
  - "postgres/src/bin/pg_rewind/libpq_source.c:130"
reproduced: false
---

# `could not clear "search_path": %s`

## What it means

A client tool (here `oid2name`) failed while resetting the session `search_path` on its connection. The placeholder is the server error text. The tool sets a safe `search_path` for its queries and could not, so it stops.

## When it happens

A utility that manages its own `search_path` encountered a server-side error running the `SET`/`SELECT` that clears it — usually a connection problem or an unexpected server response.

## How to fix

Read the included server error text for the underlying cause. Check that the connection is healthy and the server is responsive. This is usually a symptom of a broken or interrupted connection rather than a search_path problem per se; resolve the connection issue and retry.

## Example

*Illustrative* — a tool unable to reset search_path.

```text
ERROR:  could not clear "search_path": connection lost
```

## Related

- [could not establish connection](./could-not-establish-connection.md)
- [invalid list syntax in parameter](./invalid-list-syntax-in-parameter.md)
