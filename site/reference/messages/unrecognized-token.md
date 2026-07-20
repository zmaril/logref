---
message: "unrecognized token: \"%.*s\""
slug: unrecognized-token
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/nodes/read.c:473"
  - "postgres/src/backend/nodes/readfuncs.c:217"
  - "postgres/src/backend/nodes/readfuncs.c:223"
  - "postgres/src/backend/nodes/readfuncs.c:679"
reproduced: false
---

# `unrecognized token: "%.*s"`

## What it means

Internal error. The node-tree reader — which parses the internal serialized form of plan and parse nodes — hit a token it could not interpret. The placeholder is the token text. This reader consumes data the server itself wrote (stored rules, cached plans), so a bad token signals corruption or a version mismatch rather than user input.

## When it happens

It does not arise from ordinary SQL. It can surface from a corrupted stored rule/view definition, a cached plan mismatch, or reading node data written by an incompatible version — for example a stale `pg_rewrite` entry.

## How to fix

Treat it as an internal/corruption issue. If it points at a specific view or rule, recreating that object rewrites its stored node tree. If it followed an improper version change or catalog damage, investigate `pg_rewrite`/related catalogs and restore from backup if needed. Report reproducible cases.

## Example

*Illustrative* — emitted internally by the node reader.

```text
ERROR:  unrecognized token: "badtok"
```

## Related

- [expected to find SELECT subquery](./expected-to-find-select-subquery.md)
- [could not parse](./could-not-parse.md)
