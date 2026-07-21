---
message: "cannot dump statistics for relation kind \"%c\""
slug: cannot-dump-statistics-for-relation-kind
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:7134"
reproduced: false
---

# `cannot dump statistics for relation kind "%c"`

## What it means

`pg_dump` encountered a relation whose kind it cannot dump statistics for. Statistics export applies to certain relation kinds, and the one seen — identified by its single-character kind code — is not among them. The placeholder is the relation-kind character.

## When it happens

It occurs during a dump that includes statistics when a relation of an unsupported kind is reached.

## How to fix

Exclude statistics for that relation, or run the dump without statistics if the relation kind is not supported. Confirm the source and target versions agree on which relation kinds carry dumpable statistics.

## Example

*Illustrative* — an unsupported relation kind for statistics.

```text
pg_dump: error: cannot dump statistics for relation kind "c"
```

## Related

- [cannot continue without required control information, terminating](./cannot-continue-without-required-control-information-terminating.md)
- [cannot check relation](./cannot-check-relation.md)
