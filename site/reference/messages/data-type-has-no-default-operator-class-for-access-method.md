---
message: "data type %s has no default operator class for access method \"%s\""
slug: data-type-has-no-default-operator-class-for-access-method
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:2311"
  - "postgres/src/backend/commands/tablecmds.c:20759"
  - "postgres/src/backend/commands/tablecmds.c:20765"
  - "postgres/src/backend/commands/typecmds.c:2379"
  - "postgres/src/backend/parser/analyze.c:1503"
reproduced: false
---

# `data type %s has no default operator class for access method "%s"`

## What it means

An index was requested on a column whose data type has no default operator class for the chosen access method. The placeholders are the type and the access method. An operator class tells the index how to compare/handle the type; without a default, Postgres does not know how to index that type with that method.

## When it happens

Running `CREATE INDEX ... USING <am> (col)` where `col`'s type has no default opclass for `<am>` — for example a GiST or GIN index on a type that provides no such support, or a btree index on a type lacking ordering operators.

## How to fix

Name a specific operator class in the index if a non-default one exists (`CREATE INDEX ON t USING gin (col jsonb_path_ops)`), choose an access method the type supports, or install the extension that provides the needed opclass. If none exists, the type genuinely cannot be indexed that way.

## Example

*Illustrative* — no default opclass for the chosen AM.

```sql
CREATE INDEX ON t USING gin (a);  -- when a's type has no gin default opclass
```

## Related

- [access method does not exist](./access-method-does-not-exist.md)
- [missing support function in opfamily](./missing-support-function-in-opfamily.md)
