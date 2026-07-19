---
message: "cannot use system column \"%s\" in partition key"
slug: cannot-use-system-column-in-partition-key
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:20549"
reproduced: false
---

# `cannot use system column "%s" in partition key`

## What it means

A partition key referenced a system column such as `ctid` or `xmin`. Partition keys must be based on stable user data, and system columns do not qualify, so the definition is rejected.

## When it happens

It occurs on `CREATE TABLE ... PARTITION BY ... (system_column)`.

## How to fix

Use ordinary user columns or expressions over them as the partition key. Remove the system column reference from the key definition.

## Example

*Illustrative* — a system column partition key.

```sql
CREATE TABLE t (a int) PARTITION BY RANGE (ctid);
-- ERROR:  cannot use system column "ctid" in partition key
```

## Related

- [cannot use constant expression as partition key](./cannot-use-constant-expression-as-partition-key.md)
- [cannot use system column in column generation expression](./cannot-use-system-column-in-column-generation-expression.md)
