---
message: "could not parse array \"%s\": incorrect number of dimensions (%d required)"
slug: could-not-parse-array-incorrect-number-of-dimensions-required
passthrough: false
api: [ereport]
level: [WARNING]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/statistics/extended_stats_funcs.c:778"
  - "postgres/src/backend/statistics/extended_stats_funcs.c:831"
reproduced: false
---

# `could not parse array "%s": incorrect number of dimensions (%d required)`

## What it means

A warning that a stats-import path could not parse an array value because it has a different number of dimensions than the target expects.

## When it happens

It arises when importing statistics whose array-valued components (such as histogram or most-common-value arrays) do not match the expected dimensionality — usually a version or shape mismatch.

## Is this a problem?

Usually the affected statistic is skipped and rebuilt by the next `ANALYZE`. Run `ANALYZE` on the object after import if you need current statistics; report a reproducible case if it recurs across matching versions.

## Example

*Illustrative* — an array with the wrong dimension count.

```text
WARNING:  could not parse array "{{1,2}}": incorrect number of dimensions (1 required)
```

## Related

- [could not parse "%s": incorrect number of elements (same as "%s" required)](./could-not-parse-incorrect-number-of-elements-same-as-required.md)
- [invalid stats kind %u for entry of type %c](./invalid-stats-kind-for-entry-of-type.md)
