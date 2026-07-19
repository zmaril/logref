---
message: "inconsistent point values"
slug: inconsistent-point-values
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/gist/gistproc.c:1248"
  - "postgres/src/backend/access/gist/gistproc.c:1259"
reproduced: false
---

# `inconsistent point values`

## What it means

Internal error in the GiST support code for geometric types. A point's coordinate values were inconsistent where the algorithm required them ordered or well-formed. It is a consistency guard in the GiST geometry path.

## When it happens

It fires during GiST index operations over geometric data when internal point bounds did not satisfy an invariant. Ordinary queries rarely surface it; it can accompany index corruption or malformed geometry.

## How to fix

Reindex the affected GiST index. If it recurs, check the geometric data and storage health, and capture the index and a reproducible case for a bug report.

## Example

*Illustrative* — inconsistent point coordinates in GiST.

```text
ERROR:  inconsistent point values
```

## Related

- [failed to add item to GiST index page](./failed-to-add-item-to-gist-index-page-size-bytes.md)
- [ginarrayconsistent: unknown strategy number](./ginarrayconsistent-unknown-strategy-number.md)
