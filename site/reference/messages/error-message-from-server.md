---
message: "Error message from server: %s"
slug: error-message-from-server
passthrough: false
api: [pg_log_error_detail]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:2470"
  - "postgres/src/bin/pg_dump/pg_dump.c:2480"
reproduced: false
---

# `Error message from server: %s`

## What it means

`pg_dump` is relaying an error the server returned, as a detail line attached to a higher-level failure. The `%s` is the server's message text. It is context, not a distinct fault of its own.

## When it happens

It accompanies a `pg_dump` operation whose server-side query failed — a permission issue, a missing object, or a query error during the dump.

## How to fix

Read the server message it carries; that is the real cause. Address the underlying server error (privileges, object existence, connection) and rerun the dump.

## Example

*Illustrative* — a relayed server error.

```text
pg_dump: detail: Error message from server: ERROR:  permission denied for table secrets
```

## Related

- [did not find any relations](./did-not-find-any-relations-e4be6f.md)
- [failed sanity check, parent table with OID of sequence with OID not found](./failed-sanity-check-parent-table-with-oid-of-sequence-with-oid-not-found.md)
