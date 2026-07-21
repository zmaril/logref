---
message: "regular expression failed: %s"
slug: regular-expression-failed
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_REGULAR_EXPRESSION
    code: "2201B"
call_sites:
  - "postgres/src/backend/utils/adt/regexp.c:302"
  - "postgres/src/backend/utils/adt/regexp.c:2066"
  - "postgres/src/backend/utils/adt/varlena.c:3412"
reproduced: false
---

# `regular expression failed: %s`

## What it means

The regular-expression engine failed while compiling or executing a pattern. The message carries the engine's own detail, which explains the specific failure — an out-of-resources condition, an internal limit, or a malformed construct not caught earlier.

## When it happens

Running a regular-expression match (`~`, `regexp_match`, `regexp_replace`, and related functions) with a pattern that is pathologically complex, exceeds an engine limit, or triggers a failure the engine reports at run time.

## How to fix

Read the detail after the colon; it names the underlying cause. Simplify the pattern, reduce catastrophic backtracking by making it more specific, or split the work if the pattern is hitting a resource limit. If the pattern is user-supplied, validate or constrain it before use.

## Example

*Illustrative* — a pattern the engine could not process.

```sql
SELECT 'x' ~ '((((((((((a))))))))))*';  -- engine reports the failure detail
```

## Related

- [invalid regular expression](./invalid-regular-expression-4741ba.md)
- [like pattern must not end with escape character](./like-pattern-must-not-end-with-escape-character.md)
