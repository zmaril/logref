---
message: "unsupported XQuery result: %d"
slug: unsupported-xquery-result
passthrough: false
api: [elog]
level: [NOTICE]
call_sites:
  - "postgres/contrib/xml2/xpath.c:611"
  - "postgres/contrib/xml2/xpath.c:872"
reproduced: false
---

# `unsupported XQuery result: %d`

## What it means

An XML processing function produced a result of an XQuery/XPath result kind the server does not know how to represent, so it could not turn the result into a SQL value.

## When it happens

It is emitted at NOTICE from the XML functions when evaluating an expression that yields a node or item type outside the subset Postgres supports.

## Is this a problem?

Rewrite the XPath/XQuery expression so it returns a supported result — typically a node-set, string, number, or boolean — rather than the unsupported item kind. Postgres implements a subset of XPath 1.0; features beyond it are not available.

## Example

*Illustrative* — an XPath expression yielding an unsupported result kind.

```text
NOTICE:  unsupported XQuery result: 7
```

## Related

- [array element type cannot be](./array-element-type-cannot-be.md)
- [argument types and cannot be matched](./argument-types-and-cannot-be-matched.md)
