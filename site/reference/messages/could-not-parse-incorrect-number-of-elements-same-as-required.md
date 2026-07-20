---
message: "could not parse \"%s\": incorrect number of elements (same as \"%s\" required)"
slug: could-not-parse-incorrect-number-of-elements-same-as-required
passthrough: false
api: [ereport]
level: [WARNING]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/statistics/attribute_stats.c:383"
  - "postgres/src/backend/statistics/extended_stats_funcs.c:1357"
reproduced: false
---

# `could not parse "%s": incorrect number of elements (same as "%s" required)`

## What it means

A warning that a stats-import path could not parse a value because its element count does not match the count another related value requires.

## When it happens

It arises when importing statistics whose paired arrays (for example values and their frequencies) have mismatched lengths, so they cannot be aligned.

## Is this a problem?

Usually the affected statistic is skipped and rebuilt by the next `ANALYZE`. Run `ANALYZE` on the object after import if current statistics are needed; report a reproducible case if it recurs across matching versions.

## Example

*Illustrative* — mismatched element counts.

```text
WARNING:  could not parse "{1,2}": incorrect number of elements (same as "most_common_vals" required)
```

## Related

- [could not parse array "%s": incorrect number of dimensions (%d required)](./could-not-parse-array-incorrect-number-of-dimensions-required.md)
- [invalid stats kind %u for entry of type %c](./invalid-stats-kind-for-entry-of-type.md)
