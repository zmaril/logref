---
message: "unrecognized strategy number: %d"
slug: unrecognized-strategy-number
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/btree_gin/btree_gin.c:135"
  - "postgres/contrib/btree_gin/btree_gin.c:227"
  - "postgres/contrib/hstore/hstore_gin.c:141"
  - "postgres/contrib/hstore/hstore_gin.c:209"
  - "postgres/contrib/pg_trgm/trgm_gin.c:141"
  - "postgres/contrib/pg_trgm/trgm_gin.c:256"
  - "postgres/contrib/pg_trgm/trgm_gin.c:354"
  - "postgres/contrib/pg_trgm/trgm_gist.c:272"
  - "postgres/contrib/pg_trgm/trgm_gist.c:444"
  - "postgres/contrib/pg_trgm/trgm_gist.c:527"
  - "postgres/contrib/pg_trgm/trgm_op.c:316"
  - "postgres/src/backend/access/gist/gistproc.c:940"
  - "postgres/src/backend/access/gist/gistproc.c:1021"
  - "postgres/src/backend/access/gist/gistproc.c:1325"
  - "postgres/src/backend/access/gist/gistproc.c:1449"
  - "postgres/src/backend/access/gist/gistproc.c:1473"
  - "postgres/src/backend/access/gist/gistproc.c:1495"
  - "postgres/src/backend/access/spgist/spgkdtreeproc.c:248"
  - "postgres/src/backend/access/spgist/spgquadtreeproc.c:364"
  - "postgres/src/backend/access/spgist/spgquadtreeproc.c:458"
  - "postgres/src/backend/access/spgist/spgtextproc.c:551"
  - "postgres/src/backend/access/spgist/spgtextproc.c:691"
  - "postgres/src/backend/utils/adt/jsonb_gin.c:922"
  - "postgres/src/backend/utils/adt/jsonb_gin.c:1008"
  - "postgres/src/backend/utils/adt/jsonb_gin.c:1073"
  - "postgres/src/backend/utils/adt/jsonb_gin.c:1213"
  - "postgres/src/backend/utils/adt/jsonb_gin.c:1267"
  - "postgres/src/backend/utils/adt/jsonb_gin.c:1315"
reproduced: false
---

# `unrecognized strategy number: %d`

## What it means

Internal error in an index access method or operator class. Index strategies (for example "less than", "contains", "overlaps") are numbered per access method, and a `switch` over them hit a number it does not handle. The placeholder is the strategy number.

## When it happens

Almost always a bug in a custom or contrib operator class whose support functions and strategy numbers are inconsistent, or a mismatch between an index and the operator class it was built with. Ordinary queries do not cause it unless a broken opclass is involved.

## How to fix

Suspect the operator class in play — especially a custom or third-party one — and verify its strategy numbers match what its access method expects. If it appears after an extension upgrade, the opclass definition and the C code may be out of sync. Reproducible cases against a specific index/opclass are worth reporting.

## Example

*Illustrative* — a GiST/GIN opclass with an unhandled strategy.

```text
ERROR:  unrecognized strategy number: 42
```

## Related

- [invalid strategy number](./invalid-strategy-number.md)
- [unrecognized StrategyNumber](./unrecognized-strategynumber.md)
