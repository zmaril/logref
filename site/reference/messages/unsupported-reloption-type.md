---
message: "unsupported reloption type %d"
slug: unsupported-reloption-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/common/reloptions.c:866"
  - "postgres/src/backend/access/common/reloptions.c:1816"
  - "postgres/src/backend/access/common/reloptions.c:1955"
reproduced: false
---

# `unsupported reloption type %d`

## What it means

Internal error. Relation-option handling reached an option-type code it does not support while parsing or applying a storage parameter. The option types form a fixed set, and this value matched none. It is a consistency check on the reloptions machinery.

## When it happens

It should not occur through normal use of storage parameters. Reaching it points to an internal inconsistency — possibly from an extension that registers a malformed relation option — rather than to your `WITH (...)` clause as such.

## How to fix

Treat it as an internal or extension bug. Note any extensions that add custom storage parameters, capture the operation, and report it. If an extension is implicated, updating or removing it may work around it.

## Example

*Illustrative* — an unsupported relation-option type.

```text
ERROR:  unsupported reloption type 9
```

## Related

- [unrecognized parameter](./unrecognized-parameter.md)
- [invalid value for option](./invalid-value-for-option.md)
