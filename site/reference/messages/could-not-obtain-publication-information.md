---
message: "could not obtain publication information: %s"
slug: could-not-obtain-publication-information
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1814"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1942"
reproduced: false
---

# `could not obtain publication information: %s`

## What it means

`pg_createsubscriber` queried the publisher for its publications and the query failed. The `%s` carries the server's error text. Without publication metadata the subscriber cannot be set up.

## When it happens

The publisher connection failed mid-query, the role lacked rights to read publication catalogs, or the named publications do not exist on the publisher.

## How to fix

Read the trailing server error. Confirm the publisher is reachable, the connecting role can read `pg_publication`, and the publication names passed to `pg_createsubscriber` exist on the publisher.

## Example

*Illustrative* — the publication query failed against the publisher.

```text
pg_createsubscriber: error: could not obtain publication information: ERROR:  permission denied
```

## Related

- [could not receive list of replicated tables from the publisher](./could-not-receive-list-of-replicated-tables-from-the-publisher.md)
- [could not identify system](./could-not-identify-system-got-rows-and-fields-expected-rows-and-or-more-fields.md)
