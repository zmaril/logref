---
message: "could not find schema \"%s\""
slug: could-not-find-schema
passthrough: false
api: [ereport]
level: [WARNING]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/statistics/extended_stats_funcs.c:402"
  - "postgres/src/backend/statistics/extended_stats_funcs.c:1797"
reproduced: false
---

# `could not find schema "%s"`

## What it means

A warning that an operation looked up a schema by name and could not find it in the catalog.

## When it happens

It arises in tools and stats/restore paths that resolve an object's schema when the named schema does not exist on the target — often because it was renamed or not yet created.

## Is this a problem?

Confirm the schema exists (`\dn` in psql) and is spelled correctly. Create the schema before the operation, or adjust the search path / target so the object's schema is present.

## Example

*Illustrative* — a missing schema.

```text
WARNING:  could not find schema "reporting"
```

## Related

- [could not find extended statistics object "%s.%s"](./could-not-find-extended-statistics-object.md)
- [could not validate "%s" object: invalid attribute number %d found](./could-not-validate-object-invalid-attribute-number-found.md)
