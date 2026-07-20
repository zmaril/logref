---
message: "some but not all node labels are null in SPGiST inner tuple"
slug: some-but-not-all-node-labels-are-null-in-spgist-inner-tuple
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/spgist/spgutils.c:1172"
  - "postgres/src/backend/access/spgist/spgutils.c:1183"
reproduced: false
---

# `some but not all node labels are null in SPGiST inner tuple`

## What it means

Internal error / corruption report. An SPGiST index inner tuple had a mix of null and non-null node labels, which its format does not allow — either all node labels are null or none are.

## When it happens

It surfaces during SPGiST index traversal or verification when an inner tuple's node-label array violates that all-or-nothing rule, indicating index corruption or a bug in an SPGiST operator class.

## How to fix

This is a structural guard. Treat the index as suspect: `REINDEX` it. If a custom SPGiST operator class is involved, review its label handling. Investigate storage faults and report a reproducible case.

## Example

*Illustrative* — an SPGiST inner tuple with inconsistent node labels.

```text
ERROR:  some but not all node labels are null in SPGiST inner tuple
```

## Related

- [root page %u of index "%s" has level %u, expected %u](./root-page-of-index-has-level-expected.md)
- [out of overflow pages in hash index "%s"](./out-of-overflow-pages-in-hash-index.md)
