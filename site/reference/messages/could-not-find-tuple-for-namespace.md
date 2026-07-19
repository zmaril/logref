---
message: "could not find tuple for namespace %u"
slug: could-not-find-tuple-for-namespace
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/sepgsql/schema.c:68"
reproduced: false
---

# `could not find tuple for namespace %u`

## What it means

The `sepgsql` module looked up the catalog row for a schema (namespace) and did not find it. It needs that row to derive or check the schema's security label.

## When it happens

It fires inside `sepgsql` while labeling or checking a schema, when the `pg_namespace` row it expects is gone — usually a schema dropped concurrently or an inconsistent catalog.

## How to fix

This is an internal guard in the `sepgsql` extension. Confirm the schema still exists and is not being dropped concurrently. If it recurs on stable definitions, note the namespace OID and report a reproducible case.

## Example

*Illustrative* — a missing schema row during a label lookup.

```text
ERROR:  could not find tuple for namespace 16400
```

## Related

- [could not find tuple for column of relation](./could-not-find-tuple-for-column-of-relation.md)
- [could not find tuple for object in catalog](./could-not-find-tuple-for-object-in-catalog.md)
