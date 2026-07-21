---
message: "text search parser does not support headline creation"
slug: text-search-parser-does-not-support-headline-creation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/tsearch/wparser.c:304"
  - "postgres/src/backend/tsearch/wparser.c:392"
  - "postgres/src/backend/tsearch/wparser.c:469"
reproduced: false
---

# `text search parser does not support headline creation`

## What it means

A headline was requested using a text-search parser that provides no headline routine. Headlines highlight matching fragments of a document, and generating them needs a parser feature this parser does not implement.

## When it happens

Calling `ts_headline` with a configuration whose parser does not support headline generation — typically a custom or specialized parser that omits the headline function.

## How to fix

Use a configuration whose parser supports headlines, such as the default parser, or add the headline function to the custom parser. If highlighting is not essential, switch to a configuration that supports it for the headline call while keeping the specialized parser for indexing.

## Example

*Illustrative* — headline with an unsupported parser.

```sql
SELECT ts_headline('custom_cfg', doc, query);  -- parser has no headline support
```

## Related

- [text search configuration does not exist](./text-search-configuration-does-not-exist.md)
- [text search parser does not exist](./text-search-parser-does-not-exist.md)
