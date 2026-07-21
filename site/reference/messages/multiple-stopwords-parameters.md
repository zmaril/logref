---
message: "multiple StopWords parameters"
slug: multiple-stopwords-parameters
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/snowball/dict_snowball.c:251"
  - "postgres/src/backend/tsearch/dict_ispell.c:79"
  - "postgres/src/backend/tsearch/dict_simple.c:48"
reproduced: false
---

# `multiple StopWords parameters`

## What it means

A text-search dictionary definition supplied the `StopWords` parameter more than once. Each dictionary option may appear at most once, so a repeated `StopWords` is ambiguous and is rejected.

## When it happens

Creating or altering a text-search dictionary (`CREATE TEXT SEARCH DICTIONARY` or `ALTER ...`) with two `StopWords = ...` entries in the option list, usually a copy-paste slip.

## How to fix

List `StopWords` once, naming the single stop-word file you intend. If you need to combine stop-word sets, merge them into one file and reference that.

## Example

*Illustrative* — a duplicated dictionary option.

```sql
CREATE TEXT SEARCH DICTIONARY d (TEMPLATE = snowball, Language = english, StopWords = english, StopWords = extra);
```

## Related

- [multiple language parameters](./multiple-language-parameters.md)
- [invalid value for option](./invalid-value-for-option.md)
