---
message: "invalid XML comment"
slug: invalid-xml-comment
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_XML_COMMENT
    code: "2200S"
call_sites:
  - "postgres/src/backend/utils/adt/xml.c:504"
  - "postgres/src/backend/utils/adt/xml.c:509"
reproduced: false
---

# `invalid XML comment`

## What it means

A string used to build an XML comment is not a valid comment body. XML comments cannot contain the sequence `--` or end with `-`, and must be otherwise well-formed.

## When it happens

It arises from `xmlcomment(text)` when the argument violates XML comment rules — most commonly by containing a double hyphen.

## How to fix

Remove `--` sequences and a trailing `-` from the comment text. XML forbids `--` inside comments; replace or separate the hyphens before building the comment.

## Example

*Illustrative* — a comment body containing '--'.

```sql
SELECT xmlcomment('a -- b');  -- '--' not allowed in XML comments
```

## Related

- [invalid XML processing instruction](./invalid-xml-processing-instruction.md)
- [invalid Unicode escape](./invalid-unicode-escape.md)
