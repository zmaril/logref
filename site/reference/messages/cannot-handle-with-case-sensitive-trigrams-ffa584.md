---
message: "cannot handle ~~* with case-sensitive trigrams"
slug: cannot-handle-with-case-sensitive-trigrams-ffa584
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/pg_trgm/trgm_gin.c:100"
  - "postgres/contrib/pg_trgm/trgm_gin.c:225"
  - "postgres/contrib/pg_trgm/trgm_gin.c:311"
  - "postgres/contrib/pg_trgm/trgm_gist.c:249"
  - "postgres/contrib/pg_trgm/trgm_gist.c:346"
reproduced: false
---

# `cannot handle ~~* with case-sensitive trigrams`

## What it means

The `pg_trgm` index support cannot serve the case-insensitive `LIKE` operator `~~*` (`ILIKE`) against a case-sensitive trigram configuration. The trigram extraction path for this operator has no valid strategy under case-sensitive settings, so it declines.

## When it happens

Using `ILIKE` (or its `~~*` operator) against a `pg_trgm` index configured for case-sensitive trigrams, where the extension cannot build a correct trigram query.

## How to fix

Use a supported pattern: index and query on `lower(column)` and compare with `LIKE` on lowercased input, so the match becomes case-insensitive by construction. Otherwise the query runs without the index via a sequential scan.

## Example

*Illustrative* — an unsupported ILIKE trigram match.

```text
ERROR:  cannot handle ~~* with case-sensitive trigrams
```

## Related

- [cannot handle with case-sensitive trigrams](./cannot-handle-with-case-sensitive-trigrams-1413ff.md)
- [unrecognized operator](./unrecognized-operator.md)
