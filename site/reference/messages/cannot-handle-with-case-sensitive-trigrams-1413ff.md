---
message: "cannot handle ~* with case-sensitive trigrams"
slug: cannot-handle-with-case-sensitive-trigrams-1413ff
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/pg_trgm/trgm_gin.c:114"
  - "postgres/contrib/pg_trgm/trgm_gin.c:243"
  - "postgres/contrib/pg_trgm/trgm_gin.c:329"
  - "postgres/contrib/pg_trgm/trgm_gist.c:258"
  - "postgres/contrib/pg_trgm/trgm_gist.c:388"
reproduced: false
---

# `cannot handle ~* with case-sensitive trigrams`

## What it means

The `pg_trgm` GIN/GiST index support cannot serve the case-sensitive regex-match operator `~*` in this configuration. It extracts trigrams to answer regex matches, but the case-sensitive path here has no valid trigram strategy, so it declines rather than return wrong results.

## When it happens

Using a regular-expression match against a `pg_trgm` index in a way that requires case-sensitive trigrams the extension does not support for that operator combination.

## How to fix

Rephrase the match so it uses a supported form — for example use the case-insensitive operator, or apply `lower()` on both sides and index the lowercased expression. If you need the exact operator, the query will fall back to a sequential scan rather than the index.

## Example

*Illustrative* — an unsupported case-sensitive trigram match.

```text
ERROR:  cannot handle ~* with case-sensitive trigrams
```

## Related

- [cannot handle with case-sensitive trigrams](./cannot-handle-with-case-sensitive-trigrams-ffa584.md)
- [unrecognized operator](./unrecognized-operator.md)
