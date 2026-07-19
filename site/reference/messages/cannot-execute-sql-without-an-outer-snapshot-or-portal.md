---
message: "cannot execute SQL without an outer snapshot or portal"
slug: cannot-execute-sql-without-an-outer-snapshot-or-portal
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/tcop/pquery.c:1776"
reproduced: false
---

# `cannot execute SQL without an outer snapshot or portal`

## What it means

An internal guard fired: SQL execution was requested without an active snapshot or portal to run under. Every statement needs a snapshot that defines which rows are visible, and this path found neither. It reflects a coding issue in a caller that drove execution incorrectly.

## When it happens

It is reached when an extension or internal caller invokes SQL execution outside a portal and without first establishing a snapshot. It should not occur in normal query processing.

## How to fix

There is no user-level fix. If it appears, capture the extension or procedural code that invoked execution and report it, since the caller must push a snapshot before running SQL.

## Example

*Illustrative* — execution with no snapshot or portal.

```text
ERROR:  cannot execute SQL without an outer snapshot or portal
```

## Related

- [cannot fetch toast data without an active snapshot](./cannot-fetch-toast-data-without-an-active-snapshot.md)
- [cannot free an active snapshot](./cannot-free-an-active-snapshot.md)
