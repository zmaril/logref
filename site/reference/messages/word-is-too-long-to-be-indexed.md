---
message: "word is too long to be indexed"
slug: word-is-too-long-to-be-indexed
passthrough: false
api: [ereport]
level: [ERROR, NOTICE]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/tsearch/ts_parse.c:385"
  - "postgres/src/backend/tsearch/ts_parse.c:392"
  - "postgres/src/backend/tsearch/ts_parse.c:571"
  - "postgres/src/backend/tsearch/ts_parse.c:578"
reproduced: false
---

# `word is too long to be indexed`

## What it means

Full-text search skipped a token because it exceeds the maximum length a `tsvector` lexeme may have (2 KB). The token is not indexed or matched; the rest of the document is processed normally. At most call sites this is a `NOTICE`, not an error.

## When it happens

Converting text to a `tsvector` (via `to_tsvector`, an FTS index build, or a trigger) where the input contains an extremely long unbroken run of characters — often a URL, base64 blob, or concatenated identifier with no separators.

## How to fix

Usually nothing: the overlong token is simply not searchable, which is the intended behavior. If you need such content to be findable, pre-process the text to split or strip the long runs before indexing, or store that field outside the full-text index. It does not fail the insert or the index build.

## Example

*Illustrative* — an over-long token during tsvector construction.

```sql
SELECT to_tsvector(repeat('a', 3000));  -- NOTICE: word is too long to be indexed
```

## Related

- [can't extend cube](./can-t-extend-cube.md)
- [number of pairs exceeds the maximum allowed](./number-of-pairs-exceeds-the-maximum-allowed.md)
