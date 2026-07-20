---
message: "could not find tuple for object %u in catalog \"%s\""
slug: could-not-find-tuple-for-object-in-catalog
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/sepgsql/relation.c:741"
reproduced: false
---

# `could not find tuple for object %u in catalog "%s"`

## What it means

The `sepgsql` module looked up an object's row in a named system catalog by its identifier and did not find it. It needs that row to assign or verify the object's security label.

## When it happens

It fires inside `sepgsql` while processing an object, when the catalog row it expects has gone missing — commonly the object was dropped concurrently or the catalog is inconsistent.

## How to fix

This is an internal guard in the `sepgsql` extension. Confirm the object still exists and is not being dropped concurrently with the operation. On stable definitions, note the object OID and catalog name and report a reproducible case.

## Example

*Illustrative* — a missing catalog row during a label lookup.

```text
ERROR:  could not find tuple for object 16500 in catalog "pg_proc"
```

## Related

- [could not find tuple for namespace](./could-not-find-tuple-for-namespace.md)
- [could not find tuple for column of relation](./could-not-find-tuple-for-column-of-relation.md)
