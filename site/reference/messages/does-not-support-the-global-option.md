---
message: "%s does not support the \"global\" option"
slug: does-not-support-the-global-option
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/regexp.c:1162"
  - "postgres/src/backend/utils/adt/regexp.c:1253"
  - "postgres/src/backend/utils/adt/regexp.c:1340"
  - "postgres/src/backend/utils/adt/regexp.c:1379"
  - "postgres/src/backend/utils/adt/regexp.c:1767"
  - "postgres/src/backend/utils/adt/regexp.c:1822"
  - "postgres/src/backend/utils/adt/regexp.c:1951"
reproduced: false
---

# `%s does not support the "global" option`

## What it means

A regular-expression function was given the `g` (global) flag in a context that does not support it. The placeholder is the function name. Some regex functions return a single result and cannot honor "global" (all matches), so passing `g` is rejected.

## When it happens

Adding `g` to the flags of a regex function that is inherently single-result — for example `regexp_replace` in a mode where global does not apply, or a function whose semantics do not include repeating over all matches.

## How to fix

Remove the `g` flag, or use a function designed to return all matches (`regexp_matches` with `g`, `regexp_split_to_table`, or `regexp_replace` where global replace is supported). Match the flag to a function that can act globally.

## Example

*Illustrative* — the global flag on a function that rejects it.

```sql
SELECT regexp_substr('a1b2', '[0-9]', 1, 1, 'g');
```

Produces:

```text
ERROR:  regexp_substr() does not support the "global" option
```

## Related

- [invalid value for parameter](./invalid-value-for-parameter-61fc7e.md)
- [invalid regular expression: %s](./invalid-regular-expression-55c554.md)
