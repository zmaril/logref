---
message: "inherited relation \"%s\" is not a table or foreign table"
slug: inherited-relation-is-not-a-table-or-foreign-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:2776"
  - "postgres/src/backend/parser/parse_utilcmd.c:2703"
  - "postgres/src/backend/parser/parse_utilcmd.c:2897"
reproduced: false
---

# `inherited relation "%s" is not a table or foreign table`

## What it means

A table was asked to inherit from a relation that is neither a plain table nor a foreign table. Only those two relation kinds can serve as an inheritance parent, because a child inherits column definitions and constraints that only tables and foreign tables carry.

## When it happens

A `CREATE TABLE ... INHERITS (parent)` or `ALTER TABLE ... INHERIT parent` clause names a view, a sequence, a composite type, an index, or another non-table object as the parent.

## How to fix

Point the inheritance clause at an actual table or foreign table. If you meant to reuse a shape rather than inherit storage, use `CREATE TABLE ... (LIKE source)` to copy column definitions from any table-like relation, or define a composite type and a column of that type.

## Example

*Illustrative* — inheriting from a view.

```sql
CREATE TABLE child () INHERITS (a_view);  -- a view is not a valid inheritance parent
```

## Related

- [is a view](./is-a-view.md)
- [relation is not a partition of relation](./relation-is-not-a-partition-of-relation.md)
