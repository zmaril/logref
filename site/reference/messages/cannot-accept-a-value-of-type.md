---
message: "cannot accept a value of type %s"
slug: cannot-accept-a-value-of-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/contrib/btree_gist/btree_gist.c:30"
  - "postgres/contrib/hstore/hstore_gist.c:100"
  - "postgres/contrib/intarray/_intbig_gist.c:32"
  - "postgres/contrib/ltree/ltree_gist.c:24"
  - "postgres/contrib/pg_trgm/trgm_gist.c:59"
  - "postgres/src/backend/access/brin/brin_bloom.c:784"
  - "postgres/src/backend/access/brin/brin_bloom.c:826"
  - "postgres/src/backend/access/brin/brin_minmax_multi.c:2980"
  - "postgres/src/backend/access/brin/brin_minmax_multi.c:3117"
  - "postgres/src/backend/statistics/mcv.c:1476"
  - "postgres/src/backend/statistics/mcv.c:1507"
  - "postgres/src/backend/utils/adt/pg_dependencies.c:855"
  - "postgres/src/backend/utils/adt/pg_ndistinct.c:834"
  - "postgres/src/backend/utils/adt/tsgistidx.c:92"
reproduced: false
---

# `cannot accept a value of type %s`

## What it means

An index access method or type-specific function was handed a value whose type it does not support. Many index support functions (GiST, BRIN, etc.) are written for a particular input type and reject anything else. The placeholder is the offending type.

## When it happens

Building or querying an index with an operator class that does not match the column type, or calling a type-specific support function on the wrong type — often through a custom or contrib opclass used incorrectly.

## How to fix

Match the operator class and index support functions to the actual column type. If you chose an opclass explicitly, verify it applies to that type; otherwise let Postgres pick the default opclass for the type. For custom opclasses, ensure their support functions declare and handle the intended type.

## Example

*Illustrative* — an opclass applied to an incompatible type.

```text
ERROR:  cannot accept a value of type foo
```

## Related

- [cannot cast type %s to %s](./cannot-cast-type-to.md)
- [collations are not supported by type %s](./collations-are-not-supported-by-type.md)
