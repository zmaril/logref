---
message: "Did not find any property graphs."
slug: did-not-find-any-property-graphs
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:4295"
reproduced: false
---

# `Did not find any property graphs.`

## What it means

A psql describe command for property graphs found none to list. This is psql reporting an empty result, not a server error.

## When it happens

It fires when the property-graph listing runs where no property graphs are visible.

## How to fix

Nothing is wrong. If you expected some, check the schema and search path, and confirm the graphs were created with `CREATE PROPERTY GRAPH`.

## Example

*Illustrative* — no property graphs to show.

```text
-- Did not find any property graphs.
```

## Related

- [Did not find any property graphs named](./did-not-find-any-property-graphs-named.md)
- [Did not find any relations](./did-not-find-any-relations-fc25da.md)
