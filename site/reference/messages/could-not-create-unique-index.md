---
message: "could not create unique index \"%s\""
slug: could-not-create-unique-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNIQUE_VIOLATION
    code: "23505"
call_sites:
  - "postgres/src/backend/utils/sort/tuplesortvariants.c:1686"
reproduced: false
---

# `could not create unique index "%s"`

## What it means

Building a unique index failed because the column values are not unique. The `%s` names the index. Existing rows contain duplicate keys that the unique index cannot allow.

## When it happens

It happens during `CREATE UNIQUE INDEX`, `ADD PRIMARY KEY`/`ADD UNIQUE`, or a `REINDEX` of a unique index, when the current data holds duplicate key values.

## How to fix

Find and resolve the duplicate keys before creating the index. A follow-on detail line names a duplicated value; a `GROUP BY ... HAVING count(*) > 1` query finds the rest. Remove or merge the duplicates, then create the index again.

## Example

*Illustrative* — duplicate values blocking a unique index.

```sql
CREATE UNIQUE INDEX ON t (email);
-- ERROR:  could not create unique index "t_email_idx"
-- DETAIL:  Key (email)=(a@b.com) is duplicated.
```

## Related

- [could not create exclusion constraint](./could-not-create-exclusion-constraint.md)
- [could not convert type to](./could-not-convert-type-to.md)
