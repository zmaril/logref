---
message: "invalid relpersistence: %c"
slug: invalid-relpersistence
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/catalog.c:608"
  - "postgres/src/backend/catalog/storage.c:146"
  - "postgres/src/backend/utils/adt/dbsize.c:1036"
  - "postgres/src/backend/utils/cache/relcache.c:1194"
  - "postgres/src/backend/utils/cache/relcache.c:3667"
reproduced: false
---

# `invalid relpersistence: %c`

## What it means

Internal error. Code switched on a relation's persistence marker (`relpersistence`: permanent `p`, unlogged `u`, temporary `t`) and found a character that is none of those. The placeholder is the character. The set is fixed, so an invalid value means corrupted catalog state or a caller bug.

## When it happens

It should not occur for normally-created relations. Reaching it points to catalog corruption in `pg_class.relpersistence` or a bug, not to your SQL.

## How to fix

Treat it as an internal bug. If it recurs on a specific relation, inspect its `pg_class.relpersistence`; an out-of-range value indicates corruption warranting investigation and possibly a restore.

## Example

*Illustrative* — emitted internally over a relation's persistence.

```text
ERROR:  invalid relpersistence: x
```

## Related

- [invalid cache ID](./invalid-cache-id.md)
- [could not open relation with OID](./could-not-open-relation-with-oid.md)
