---
message: "unrecognized node type: %d"
slug: unrecognized-node-type
passthrough: false
api: [elog]
level: [DEBUG2, ERROR, WARNING]
call_sites:
  - "postgres/contrib/pg_plan_advice/pgpa_join.c:426"
  - "postgres/contrib/pg_plan_advice/pgpa_walker.c:921"
  - "postgres/src/backend/commands/define.c:58"
  - "postgres/src/backend/commands/define.c:329"
  - "postgres/src/backend/commands/define.c:352"
  - "postgres/src/backend/commands/tablecmds.c:20362"
  - "postgres/src/backend/commands/typecmds.c:874"
  - "postgres/src/backend/commands/typecmds.c:2995"
  - "postgres/src/backend/executor/execAmi.c:303"
  - "postgres/src/backend/executor/execAmi.c:358"
  - "postgres/src/backend/executor/execAmi.c:406"
  - "postgres/src/backend/executor/execAsync.c:43"
  - "postgres/src/backend/executor/execAsync.c:76"
  - "postgres/src/backend/executor/execAsync.c:102"
  - "postgres/src/backend/executor/execAsync.c:127"
  - "postgres/src/backend/executor/execExpr.c:2658"
  - "postgres/src/backend/executor/execProcnode.c:386"
  - "postgres/src/backend/executor/execProcnode.c:522"
  - "postgres/src/backend/executor/execProcnode.c:741"
  - "postgres/src/backend/executor/execSRF.c:476"
  - "postgres/src/backend/nodes/copyfuncs.c:135"
  - "postgres/src/backend/nodes/copyfuncs.c:206"
  - "postgres/src/backend/nodes/equalfuncs.c:257"
  - "postgres/src/backend/nodes/nodeFuncs.c:291"
  - "postgres/src/backend/nodes/nodeFuncs.c:1078"
  - "postgres/src/backend/nodes/nodeFuncs.c:1325"
  - "postgres/src/backend/nodes/nodeFuncs.c:2732"
  - "postgres/src/backend/nodes/nodeFuncs.c:3858"
  - "postgres/src/backend/nodes/nodeFuncs.c:4858"
  - "postgres/src/backend/nodes/queryjumblefuncs.c:598"
  - "postgres/src/backend/nodes/queryjumblefuncs.c:738"
  - "postgres/src/backend/nodes/read.c:505"
  - "postgres/src/backend/nodes/readfuncs.c:339"
  - "postgres/src/backend/optimizer/path/allpaths.c:4230"
  - "postgres/src/backend/optimizer/path/allpaths.c:4794"
  - "postgres/src/backend/optimizer/path/costsize.c:993"
  - "postgres/src/backend/optimizer/path/costsize.c:1143"
  - "postgres/src/backend/optimizer/path/indxpath.c:2189"
  - "postgres/src/backend/optimizer/plan/createplan.c:543"
  - "postgres/src/backend/optimizer/plan/createplan.c:799"
  - "postgres/src/backend/optimizer/plan/createplan.c:1099"
  - "postgres/src/backend/optimizer/plan/createplan.c:3371"
  - "postgres/src/backend/optimizer/plan/createplan.c:5498"
  - "postgres/src/backend/optimizer/plan/initsplan.c:204"
  - "postgres/src/backend/optimizer/plan/initsplan.c:349"
  - "postgres/src/backend/optimizer/plan/initsplan.c:406"
  - "postgres/src/backend/optimizer/plan/initsplan.c:1883"
  - "postgres/src/backend/optimizer/plan/initsplan.c:2035"
  - "postgres/src/backend/optimizer/plan/planner.c:1559"
  - "postgres/src/backend/optimizer/plan/setrefs.c:1346"
  - "postgres/src/backend/optimizer/plan/subselect.c:3111"
  - "postgres/src/backend/optimizer/prep/prepjointree.c:833"
  - "postgres/src/backend/optimizer/prep/prepjointree.c:1391"
  - "postgres/src/backend/optimizer/prep/prepjointree.c:1902"
  - "postgres/src/backend/optimizer/prep/prepjointree.c:2421"
  - "postgres/src/backend/optimizer/prep/prepjointree.c:2543"
  - "postgres/src/backend/optimizer/prep/prepjointree.c:2763"
  - "postgres/src/backend/optimizer/prep/prepjointree.c:3419"
  - "postgres/src/backend/optimizer/prep/prepjointree.c:3714"
  - "postgres/src/backend/optimizer/prep/prepjointree.c:4220"
  - "postgres/src/backend/optimizer/prep/prepjointree.c:4585"
  - "postgres/src/backend/optimizer/prep/prepjointree.c:4648"
  - "postgres/src/backend/optimizer/prep/prepjointree.c:4740"
  - "postgres/src/backend/optimizer/prep/prepunion.c:352"
  - "postgres/src/backend/optimizer/util/clauses.c:2269"
  - "postgres/src/backend/optimizer/util/placeholder.c:249"
  - "postgres/src/backend/parser/parse_clause.c:1773"
  - "postgres/src/backend/parser/parse_clause.c:1943"
  - "postgres/src/backend/parser/parse_expr.c:378"
  - "postgres/src/backend/parser/parse_node.c:466"
  - "postgres/src/backend/parser/parse_relation.c:1156"
  - "postgres/src/backend/parser/parse_relation.c:1171"
  - "postgres/src/backend/parser/parse_utilcmd.c:289"
  - "postgres/src/backend/parser/parse_utilcmd.c:3920"
  - "postgres/src/backend/parser/parse_utilcmd.c:4231"
  - "postgres/src/backend/parser/parse_utilcmd.c:4557"
  - "postgres/src/backend/rewrite/rewriteHandler.c:1987"
  - "postgres/src/backend/tcop/pquery.c:266"
  - "postgres/src/backend/tcop/pquery.c:306"
  - "postgres/src/backend/tcop/utility.c:396"
  - "postgres/src/backend/tcop/utility.c:1929"
  - "postgres/src/backend/tcop/utility.c:3270"
  - "postgres/src/backend/tcop/utility.c:3816"
  - "postgres/src/backend/utils/adt/oid.c:280"
  - "postgres/src/backend/utils/adt/ruleutils.c:4552"
  - "postgres/src/backend/utils/adt/ruleutils.c:4727"
  - "postgres/src/backend/utils/adt/ruleutils.c:6921"
  - "postgres/src/backend/utils/adt/ruleutils.c:8024"
  - "postgres/src/backend/utils/adt/ruleutils.c:11208"
  - "postgres/src/backend/utils/adt/ruleutils.c:13405"
  - "postgres/src/backend/utils/misc/guc_funcs.c:265"
  - "postgres/src/backend/utils/misc/guc_funcs.c:327"
reproduced: false
---

# `unrecognized node type: %d`

## What it means

Internal error. A `switch` over Postgres's parse/plan/execute node tags hit a tag it has no case for. The placeholder is the numeric `NodeTag`. Every node the planner and executor handle has a case; reaching the default arm means either a node of an unexpected kind reached code that should never see it, or in-memory structures were corrupted.

## When it happens

It should never happen in a correct build. In practice it points to a bug (often in an extension that builds or rewrites node trees), a version mismatch between a loaded module and the server, or memory corruption. It is not caused by anything in your SQL data.

## How to fix

Treat it as a bug to investigate, not a user error. If you run extensions that manipulate query trees (planner hooks, custom scan providers), suspect those first and check they were built against this exact server version. Capture the full statement and a stack trace if you can, and report it. If it appears alongside other corruption symptoms, run hardware and memory checks.

## Example

*Illustrative* — emitted internally; no ordinary SQL reliably triggers it.

```text
ERROR:  unrecognized node type: 347
```

## Related

- [unrecognized CmdType](./unrecognized-cmdtype.md)
- [unrecognized join type](./unrecognized-join-type.md)
