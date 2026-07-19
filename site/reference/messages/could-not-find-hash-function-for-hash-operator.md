---
message: "could not find hash function for hash operator %u"
slug: could-not-find-hash-function-for-hash-operator
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/execGrouping.c:120"
  - "postgres/src/backend/executor/nodeMemoize.c:1019"
  - "postgres/src/backend/executor/nodeSubplan.c:1029"
reproduced: false
---

# `could not find hash function for hash operator %u`

## What it means

Internal error. Executor code setting up hashing (for a hash join, hash aggregate, or hashed subplan) could not find the hash support function for a hash operator by OID. The placeholder is the operator OID. A hashable operator must have a registered hash function in its operator family; the lookup found none.

## When it happens

It does not arise from ordinary SQL. It points to an incomplete operator family (often from a custom type or extension) that marks an operator hashable without providing the hash support function, or catalog inconsistency.

## How to fix

If a custom type/operator is involved, ensure its hash operator family includes the required hash support function. For core types this indicates catalog inconsistency worth investigating. Capture the query and the operator OID and report reproducible cases.

## Example

*Illustrative* — a hashable operator lacking its hash function.

```text
ERROR:  could not find hash function for hash operator 16700
```

## Related

- [unsupported indexqual type](./unsupported-indexqual-type.md)
- [cache lookup failed for opfamily](./cache-lookup-failed-for-opfamily.md)
