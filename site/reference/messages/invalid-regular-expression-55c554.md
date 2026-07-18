---
message: "invalid regular expression: %s"
slug: invalid-regular-expression-55c554
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_REGULAR_EXPRESSION
    code: "2201B"
call_sites:
  - "postgres/contrib/pg_trgm/trgm_regexp.c:749"
  - "postgres/src/backend/tsearch/spell.c:750"
  - "postgres/src/backend/utils/adt/regexp.c:221"
reproduced: false
---

# `invalid regular expression: %s`

## What it means

A regular expression could not be compiled. The placeholder carries the underlying reason from the regex engine — `quantifier operand invalid`, `parentheses () not balanced`, `invalid character range`, and so on. The pattern is syntactically broken, so no matching can be attempted.

## When it happens

Any regex operator or function given a malformed pattern: `~`, `~*`, `SIMILAR TO`, `substring(s FROM pattern)`, `regexp_replace`, `regexp_matches`, `regexp_split_to_*`. A stray unescaped metacharacter — an open `(` or `[`, a trailing backslash, a backwards `{2,1}` bound — is the usual cause.

## How to fix

Read the reason in the message; it points at the specific defect. Escape metacharacters that are meant literally (`\(`, `\[`, `\.`), balance brackets and parentheses, and make quantifier bounds ascend (`{1,2}` not `{2,1}`). When the pattern comes from user input, escape it — build it with a helper rather than concatenating raw text — or validate it before use. Postgres uses POSIX ARE syntax, which differs from PCRE in a few escapes.

## Example

*Illustrative* — the string/regex reproducer scenario feeds broken patterns (`10_strings_regex.sql`).

```sql
SELECT 'abc' ~ '(';
```

Produces:

```text
ERROR:  invalid regular expression: parentheses () not balanced
```

## Related

- [invalid input syntax for type](./invalid-input-syntax-for-type-1b54ae.md)
