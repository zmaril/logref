---
message: "missing DictFile parameter"
slug: missing-dictfile-parameter
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/tsearch/dict_ispell.c:107"
  - "postgres/src/backend/tsearch/dict_thesaurus.c:639"
reproduced: false
---

# `missing DictFile parameter`

## What it means

A text-search dictionary definition that requires a `DictFile` option did not provide one. The dictionary template needs to know which dictionary file to load.

## When it happens

It arises from `CREATE TEXT SEARCH DICTIONARY` (or `ALTER`) using a template such as the Ispell template without specifying the `DictFile` parameter.

## How to fix

Add the `DictFile` option naming the dictionary file (without extension) installed in the server's `tsearch_data` directory, for example `DictFile = english`. Ensure the corresponding files exist on the server.

## Example

*Illustrative* — an Ispell dictionary without DictFile.

```sql
CREATE TEXT SEARCH DICTIONARY d (TEMPLATE = ispell, AffFile = english);  -- DictFile missing
```

## Related

- [multiple DictFile parameters](./multiple-dictfile-parameters.md)
- [method lextype isn't defined for text search parser](./method-lextype-isn-t-defined-for-text-search-parser.md)
