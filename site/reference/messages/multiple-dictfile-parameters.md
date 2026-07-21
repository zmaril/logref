---
message: "multiple DictFile parameters"
slug: multiple-dictfile-parameters
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/tsearch/dict_ispell.c:53"
  - "postgres/src/backend/tsearch/dict_thesaurus.c:615"
reproduced: false
---

# `multiple DictFile parameters`

## What it means

A text-search dictionary definition supplied the `DictFile` option more than once. Each option may appear only a single time in the definition.

## When it happens

It arises from `CREATE TEXT SEARCH DICTIONARY`/`ALTER` when `DictFile` is listed twice in the option list.

## How to fix

Specify `DictFile` exactly once. Remove the duplicate entry, keeping the intended dictionary file name.

## Example

*Illustrative* — DictFile given twice.

```sql
CREATE TEXT SEARCH DICTIONARY d (TEMPLATE = ispell, DictFile = a, DictFile = b);  -- duplicate
```

## Related

- [missing DictFile parameter](./missing-dictfile-parameter.md)
- [multiple assignments to same column](./multiple-assignments-to-same-column.md)
