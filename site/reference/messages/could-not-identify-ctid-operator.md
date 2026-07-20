---
message: "could not identify CTID operator"
slug: could-not-identify-ctid-operator
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeTidrangescan.c:95"
reproduced: false
---

# `could not identify CTID operator`

## What it means

The executor's TID-range scan tried to find the comparison operator for the `tid` (`ctid`) type and could not. A TID-range scan uses these operators to compare physical row locations while scanning a range of them.

## When it happens

It fires while executing a plan that uses a TID-range scan, when the expected `tid` comparison operator cannot be located — an internal inconsistency, not a normal user condition.

## How to fix

This is an internal guard. It should not be reachable on stock catalogs; a damaged catalog or a tampered `tid` operator class could produce it. Capture the query and report a reproducible case; on a corrupted catalog, restore from a backup.

## Example

*Illustrative* — the ctid comparison operator could not be found.

```text
ERROR:  could not identify CTID operator
```

## Related

- [could not get function name](./could-not-get-function-name.md)
- [could not identify relation associated with constraint](./could-not-identify-relation-associated-with-constraint.md)
