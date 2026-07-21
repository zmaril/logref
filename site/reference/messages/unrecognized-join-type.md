---
message: "unrecognized join type: %d"
slug: unrecognized-join-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeMergejoin.c:1597"
  - "postgres/src/backend/executor/nodeNestloop.c:339"
  - "postgres/src/backend/optimizer/path/costsize.c:5794"
  - "postgres/src/backend/optimizer/path/joinpath.c:1877"
  - "postgres/src/backend/optimizer/path/joinrels.c:1224"
  - "postgres/src/backend/optimizer/path/joinrels.c:1723"
  - "postgres/src/backend/optimizer/plan/initsplan.c:1842"
  - "postgres/src/backend/optimizer/prep/prepjointree.c:814"
  - "postgres/src/backend/optimizer/prep/prepjointree.c:1385"
  - "postgres/src/backend/optimizer/prep/prepjointree.c:3413"
  - "postgres/src/backend/optimizer/prep/prepjointree.c:3542"
  - "postgres/src/backend/optimizer/prep/prepjointree.c:4214"
  - "postgres/src/backend/optimizer/prep/prepjointree.c:4734"
  - "postgres/src/backend/optimizer/util/clauses.c:2263"
  - "postgres/src/backend/optimizer/util/relnode.c:2649"
  - "postgres/src/backend/parser/parse_clause.c:1594"
  - "postgres/src/backend/parser/parse_clause.c:1902"
  - "postgres/src/backend/parser/parse_cte.c:1178"
  - "postgres/src/backend/partitioning/partbounds.c:2759"
  - "postgres/src/backend/utils/adt/network_selfuncs.c:256"
  - "postgres/src/backend/utils/adt/ruleutils.c:13337"
  - "postgres/src/backend/utils/adt/selfuncs.c:2559"
reproduced: false
---

# `unrecognized join type: %d`

## What it means

Internal error. A `switch` over the planner/executor's join-type enum (`JoinType`: inner, left, full, right, semi, anti, and so on) hit a value it does not handle. The placeholder is the numeric join type.

## When it happens

A bug in the planner or executor, an extension that constructs join nodes, or memory corruption. Ordinary queries never reach it.

## How to fix

Treat it as a bug. If you use planner-hook or custom-scan extensions, suspect those and confirm their version matches the server. Capture the query and a stack trace and report it. If other corruption signs are present, run memory/hardware diagnostics.

## Example

*Illustrative* — emitted internally; no ordinary SQL triggers it.

```text
ERROR:  unrecognized join type: 99
```

## Related

- [unrecognized node type](./unrecognized-node-type.md)
- [unrecognized CmdType](./unrecognized-cmdtype.md)
