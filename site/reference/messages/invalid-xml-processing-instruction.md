---
message: "invalid XML processing instruction"
slug: invalid-xml-processing-instruction
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_XML_PROCESSING_INSTRUCTION
    code: "2200T"
call_sites:
  - "postgres/src/backend/utils/adt/xml.c:1061"
  - "postgres/src/backend/utils/adt/xml.c:1084"
reproduced: false
---

# `invalid XML processing instruction`

## What it means

A string used to build an XML processing instruction is not valid. The target name must be a valid XML name and must not be `xml` (in any case), and the content must not contain `?>`.

## When it happens

It arises from `xmlpi(name target, content)` when the target is a reserved or malformed name, or the content includes the forbidden `?>` sequence.

## How to fix

Use a valid, non-reserved target name (not `xml`), and remove any `?>` from the content. Follow XML naming rules for the target: start with a letter or underscore and avoid the `xml` prefix.

## Example

*Illustrative* — a reserved processing-instruction target.

```sql
SELECT xmlpi(name xml, 'data');  -- 'xml' target is reserved
```

## Related

- [invalid XML comment](./invalid-xml-comment.md)
- [invalid name syntax](./invalid-name-syntax.md)
