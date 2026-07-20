---
message: "could not parse \"%s\": invalid element in expression %d"
slug: could-not-parse-invalid-element-in-expression
passthrough: false
api: [ereport]
level: [WARNING]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/statistics/extended_stats_funcs.c:1134"
  - "postgres/src/backend/statistics/extended_stats_funcs.c:1164"
  - "postgres/src/backend/statistics/extended_stats_funcs.c:1184"
  - "postgres/src/backend/statistics/extended_stats_funcs.c:1195"
  - "postgres/src/backend/statistics/extended_stats_funcs.c:1212"
  - "postgres/src/backend/statistics/extended_stats_funcs.c:1657"
reproduced: false
---

# `could not parse "%s": invalid element in expression %d`

## What it means

Extended-statistics code tried to reconstruct a stored expression and found an element it could not parse at the given position. The first placeholder is the text being parsed, the second the element index. At `WARNING` the operation continues, but the expression statistic could not be read back.

## When it happens

Reading expression statistics (from `CREATE STATISTICS ... ON (expr)`) whose serialized form is malformed — typically after catalog corruption or a version-related change in how the expression was stored.

## Is this a problem?

The affected statistics object cannot be used and may be stale. Drop and recreate it with `DROP STATISTICS` then `CREATE STATISTICS`, and run `ANALYZE` to repopulate. If the warning recurs, capture the statistics definition and report it.

## Example

*Illustrative* — an unreadable expression statistic.

```text
WARNING:  could not parse "...": invalid element in expression 2
```

## Related

- [operator family of access method contains function with invalid support number](./operator-family-of-access-method-contains-function-with-invalid-support-number.md)
- [extconfig and extcondition arrays do not match](./extconfig-and-extcondition-arrays-do-not-match.md)
