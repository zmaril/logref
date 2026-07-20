---
message: "unexpected opcintype: %u"
slug: unexpected-opcintype
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/pg_constraint.c:1722"
  - "postgres/src/backend/parser/analyze.c:1536"
  - "postgres/src/backend/parser/analyze.c:1568"
reproduced: false
---

# `unexpected opcintype: %u`

## What it means

Internal error. Constraint or parser code read an operator class whose declared input type does not match the type the surrounding code expected. The message reports the unexpected type identifier. It is a consistency check on operator-class metadata.

## When it happens

It should not occur through normal DDL. Reaching it points to an internal inconsistency between an operator class and the context using it, not to your command as such.

## How to fix

Treat it as an internal-bug or catalog-integrity signal. Capture the operation that triggered it and the type involved, and report it. If a custom or extension operator class is in play, a mismatched class definition could contribute, so verify the extension is current.

## Example

*Illustrative* — an unexpected operator-class input type.

```text
ERROR:  unexpected opcintype: 16400
```

## Related

- [operator class of access method is missing support function](./operator-class-of-access-method-is-missing-support-function.md)
- [invalid opclass definition](./invalid-opclass-definition.md)
