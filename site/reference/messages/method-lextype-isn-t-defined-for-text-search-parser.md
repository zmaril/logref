---
message: "method lextype isn't defined for text search parser %u"
slug: method-lextype-isn-t-defined-for-text-search-parser
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/tsearchcmds.c:1242"
  - "postgres/src/backend/tsearch/wparser.c:56"
reproduced: false
---

# `method lextype isn't defined for text search parser %u`

## What it means

Internal error. A text-search parser was used but does not define the required `lextype` method. The placeholder is the parser OID. A complete parser must implement all of its support methods.

## When it happens

It fires when the text-search machinery queries a parser's token types and the parser lacks the `lextype` function. Built-in parsers define it; this points to a custom or incompletely defined `CREATE TEXT SEARCH PARSER`.

## How to fix

This is a definition-completeness guard. If a custom text-search parser is involved, define all required methods (`start`, `gettoken`, `end`, `lextype`, and `headline`) in its `CREATE TEXT SEARCH PARSER`. For built-in parsers, capture the case and report it.

## Example

*Illustrative* — a parser missing its lextype method.

```text
ERROR:  method lextype isn't defined for text search parser 16500
```

## Related

- [missing DictFile parameter](./missing-dictfile-parameter.md)
- [multiple DictFile parameters](./multiple-dictfile-parameters.md)
