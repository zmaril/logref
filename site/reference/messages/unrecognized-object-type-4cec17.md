---
message: "unrecognized object type: %d"
slug: unrecognized-object-type-4cec17
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:298"
  - "postgres/src/backend/catalog/aclchk.c:1233"
  - "postgres/src/backend/catalog/aclchk.c:3052"
  - "postgres/src/backend/catalog/objectaddress.c:1228"
  - "postgres/src/backend/catalog/objectaddress.c:1418"
  - "postgres/src/backend/catalog/objectaddress.c:1502"
  - "postgres/src/backend/catalog/objectaddress.c:1578"
  - "postgres/src/backend/catalog/objectaddress.c:1770"
  - "postgres/src/backend/catalog/objectaddress.c:1888"
  - "postgres/src/backend/catalog/objectaddress.c:2465"
  - "postgres/src/backend/catalog/pg_shdepend.c:1322"
  - "postgres/src/backend/commands/dropcmds.c:519"
  - "postgres/src/backend/commands/indexcmds.c:3061"
  - "postgres/src/backend/utils/adt/acl.c:899"
reproduced: false
---

# `unrecognized object type: %d`

## What it means

Internal error. A `switch` over the catalog's object-type/class enum hit a value it does not handle. The placeholder is the numeric object type. Code that manipulates database objects generically (dependency tracking, `DROP`, ACLs, event triggers) reached an object kind it was not written for.

## When it happens

A bug in core or in an extension that registers or manipulates object types, or a version mismatch where a newer catalog contains an object class an older code path does not know. Ordinary data does not trigger it.

## How to fix

Treat it as a bug. If an extension adds object types or hooks into object access, suspect it and confirm it matches the server version. Capture the operation (often a `DROP`, `ALTER`, or `COMMENT`) and report it. Reproducible steps help pin the missing case.

## Example

*Illustrative* — emitted internally during generic object handling.

```text
ERROR:  unrecognized object type: 42
```

## Related

- [unsupported object type: %d](./unsupported-object-type-51541a.md)
- [unrecognized node type](./unrecognized-node-type.md)
