---
message: "%s will create implicit sequence \"%s\" for serial column \"%s.%s\""
slug: will-create-implicit-sequence-for-serial-column
passthrough: false
api: [ereport]
level: [DEBUG1]
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:481"
reproduced: true
---

# `%s will create implicit sequence "%s" for serial column "%s.%s"`

**Severity:** DEBUG1

## What it means

Creating a `serial` (or `bigserial`) column caused Postgres to create a backing sequence automatically. `serial` is not a real type — it is shorthand for an `integer`/`bigint` column plus an owned sequence that supplies its default. This `DEBUG1` line reports that automatic sequence being made. The placeholders name the command, the generated sequence, and the target column.

## When it happens

Emitted (at `DEBUG1`, off by default) whenever a `CREATE TABLE` or `ALTER TABLE` introduces a `serial`/`bigserial` column. The sequence is named `table_column_seq` and is owned by the column, so it is dropped with it.

## Is this a problem?

Informational — the implicit sequence is expected behavior. Worth knowing for schema design: if you want control over the sequence (custom start, increment, or type), declare the column as `integer` with an explicit `GENERATED ALWAYS AS IDENTITY` or a hand-made sequence instead of `serial`. Modern Postgres favors identity columns over `serial` for standards compliance.

## Example

*Reproduced* — The setup reproducer scenario creates a table with a serial column (`00_setup.sql`).

```sql
CREATE TABLE churn (id serial PRIMARY KEY, n int);
```

Produces:

```text
DEBUG:  CREATE TABLE will create implicit sequence "churn_id_seq" for serial column "churn.id"
```

## Source

Emitted from [`postgres/src/backend/parser/parse_utilcmd.c:481`](https://github.com/postgres/postgres/blob/master/src/backend/parser/parse_utilcmd.c#L481).

## Related

- [relation "%s" already exists](./relation-already-exists.md)
