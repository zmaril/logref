---
message: "%s: column \"%s\" does not exist"
slug: column-does-not-exist-fb944f
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/lo/lo.c:70"
reproduced: false
---

# `%s: column "%s" does not exist`

## What it means

An internal lookup, driven by a tool or function that resolves a column by name, found no column of that name. The leading placeholder names the context. The requested column is absent from the relation being examined.

## When it happens

It is reached from internal name-resolution paths in the server or utilities. It usually reflects stale metadata or a mismatch between an expected and an actual table shape rather than an ordinary query.

## How to fix

Confirm the column name and the relation it is expected on. If a tool cached an old schema, refresh it; if a query names the column, correct the spelling or qualification and rerun.

## Example

*Illustrative* — an internal missing-column lookup.

```text
ERROR:  myfunc: column "c" does not exist
```

## Related

- [child table is missing column](./child-table-is-missing-column.md)
- [column exclusion constraints are not supported](./column-exclusion-constraints-are-not-supported.md)
