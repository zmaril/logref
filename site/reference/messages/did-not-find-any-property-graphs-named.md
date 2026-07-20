---
message: "Did not find any property graphs named \"%s\"."
slug: did-not-find-any-property-graphs-named
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:4272"
reproduced: false
---

# `Did not find any property graphs named "%s".`

## What it means

A psql describe command for property graphs with a name pattern matched none. The placeholder is the pattern. This is psql reporting an empty result, not a server error.

## When it happens

It fires when the pattern matches no property graph, because none exists or the pattern does not match.

## How to fix

List all property graphs without a pattern, and check the pattern and search path.

## Example

*Illustrative* — a pattern matching no property graph.

```text
-- Did not find any property graphs named "g_*".
```

## Related

- [Did not find any property graphs](./did-not-find-any-property-graphs.md)
- [destination vertex of edge does not exist](./destination-vertex-of-edge-does-not-exist.md)
