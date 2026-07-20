---
message: "stxkind is not a 1-D char array"
slug: stxkind-is-not-a-1-d-char-array
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:2083"
  - "postgres/src/backend/statistics/extended_stats.c:506"
  - "postgres/src/backend/utils/adt/ruleutils.c:2089"
reproduced: false
---

# `stxkind is not a 1-D char array`

## What it means

Internal error. Code reading a statistics object's kind list found the stored value was not the one-dimensional character array it must be. The kinds of an extended-statistics object are stored as such an array, and this value's shape did not match.

## When it happens

It should not occur for statistics objects created through normal DDL. Reaching it points to catalog corruption or an internal inconsistency in the statistics catalog, not to your `CREATE STATISTICS` usage.

## How to fix

Treat it as a catalog-integrity or internal-bug signal. Identify the statistics object involved, drop and recreate it if the catalog entry is damaged, and check storage health. Report it with context if the catalog otherwise appears intact.

## Example

*Illustrative* — a malformed statistics-kind array.

```text
ERROR:  stxkind is not a 1-D char array
```

## Related

- [statistics creation on system columns is not supported](./statistics-creation-on-system-columns-is-not-supported.md)
- [cannot specify parameter](./cannot-specify-parameter.md)
