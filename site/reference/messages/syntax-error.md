---
message: "syntax error"
slug: syntax-error
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONFIG_FILE_ERROR
    code: "F0000"
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/contrib/ltree/ltxtquery_io.c:614"
  - "postgres/contrib/ltree/ltxtquery_io.c:647"
  - "postgres/src/backend/tsearch/spell.c:970"
  - "postgres/src/backend/tsearch/spell.c:987"
  - "postgres/src/backend/tsearch/spell.c:1004"
  - "postgres/src/backend/tsearch/spell.c:1021"
  - "postgres/src/backend/tsearch/spell.c:1086"
reproduced: false
---

# `syntax error`

## What it means

A specialized parser (not the main SQL parser) could not parse its input. The bare "syntax error" here comes from sub-grammars such as the `ltree`/`ltxtquery` label-path parser or the text-search dictionary/synonym file reader. The input did not conform to that mini-language's rules.

## When it happens

A malformed `ltxtquery`/`lquery` expression, a bad `ltree` label path, or an invalid line in a text-search configuration file (synonym, thesaurus, stopword). The main SQL `syntax error at or near` is a different message; this one is from these embedded grammars.

## How to fix

Check the input against the specific grammar's rules. For `ltree`/`ltxtquery`, verify label characters and operators; for text-search files, verify each line's format. The surrounding context (the function or file being parsed) tells you which mini-language applies — consult its documentation and fix the offending token.

## Example

*Illustrative* — a malformed ltxtquery.

```sql
SELECT 'a & & b'::ltxtquery;
```

Produces:

```text
ERROR:  syntax error
```

## Related

- [improper qualified name (too many dotted names)](./improper-qualified-name-too-many-dotted-names.md)
- [invalid regular expression: %s](./invalid-regular-expression-55c554.md)
