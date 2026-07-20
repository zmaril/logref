---
message: "could not interpret EXPLAIN output: \"%s\""
slug: could-not-interpret-explain-output
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/postgres_fdw/postgres_fdw.c:3847"
  - "postgres/contrib/postgres_fdw/postgres_fdw.c:3851"
reproduced: false
---

# `could not interpret EXPLAIN output: "%s"`

## What it means

Internal error in the `postgres_fdw` extension. It ran `EXPLAIN` on the remote server to estimate costs and could not parse the line it got back. The `%s` is the offending output line.

## When it happens

The remote server produced `EXPLAIN` output in a format the local `postgres_fdw` did not expect — usually a remote of a different or unexpected version, or a non-Postgres endpoint behind the foreign server.

## How to fix

Confirm the foreign server points at a compatible Postgres version. Align the remote and local major versions where practical, and verify no proxy is rewriting the remote's `EXPLAIN` output.

## Example

*Illustrative* — unparseable remote EXPLAIN output.

```text
ERROR:  could not interpret EXPLAIN output: "Foreign Scan ..."
```

## Related

- [could not obtain publication information](./could-not-obtain-publication-information.md)
- [function name is not unique](./function-name-is-not-unique.md)
