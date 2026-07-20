---
message: "relation \"%s\" is of wrong relation kind"
slug: relation-is-of-wrong-relation-kind
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/contrib/pg_visibility/pg_visibility.c:928"
  - "postgres/contrib/pgstattuple/pgstatapprox.c:342"
reproduced: false
---

# `relation "%s" is of wrong relation kind`

## What it means

An operation was applied to a relation whose kind (table, view, index, sequence, foreign table, partitioned table, and so on) is not one it accepts. The placeholder is the relation name. Many commands are restricted to particular relation kinds.

## When it happens

It arises broadly — for example applying a table-only operation to a view, an index-only operation to a table, or a sequence operation to something that is not a sequence.

## How to fix

Use a relation of the kind the command expects, or use the command appropriate to the relation's actual kind. Check the relation kind with `\d name` (or `pg_class.relkind`) to see what it really is.

## Example

*Illustrative* — a table-only command applied to a view.

```text
ERROR:  relation "orders_view" is of wrong relation kind
DETAIL:  This operation is not supported for views.
```

## Related

- [referenced relation "%s" is not a table](./referenced-relation-is-not-a-table.md)
- [relation "%s" cannot have rules](./relation-cannot-have-rules.md)
