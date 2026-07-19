---
message: "invalid collation \"%s\""
slug: invalid-collation
passthrough: false
api: [pg_log_warning]
level: [WARNING]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:15100"
  - "postgres/src/bin/pg_dump/pg_dump.c:15107"
  - "postgres/src/bin/pg_dump/pg_dump.c:15118"
  - "postgres/src/bin/pg_dump/pg_dump.c:15128"
  - "postgres/src/bin/pg_dump/pg_dump.c:15143"
reproduced: false
---

# `invalid collation "%s"`

## What it means

A tool (here `pg_dump`) found a collation reference it considers invalid while processing objects. The placeholder is the collation name. At `WARNING` the run continues, but the affected object's collation could not be validated or mapped.

## When it happens

Dumping objects that reference a collation the tool cannot resolve — for example a collation missing from the target environment, or one whose definition is inconsistent with the current locale/provider setup.

## Is this a problem?

Note which collation is flagged. Ensure the collation exists and is valid in both source and destination (matching provider and locale availability). For restores, the target system must provide the referenced collations; install the needed locales or adjust the objects to a collation that exists everywhere.

## Example

*Illustrative* — an unresolved collation during dump.

```text
WARNING:  invalid collation "en_X"
```

## Related

- [could not determine which collation to use for function](./could-not-determine-which-collation-to-use-for-function.md)
- [case conversion failed](./case-conversion-failed.md)
