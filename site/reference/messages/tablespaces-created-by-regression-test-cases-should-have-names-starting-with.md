---
message: "tablespaces created by regression test cases should have names starting with \"regress_\""
slug: tablespaces-created-by-regression-test-cases-should-have-names-starting-with
passthrough: false
api: [elog]
level: [WARNING]
call_sites:
  - "postgres/src/backend/commands/tablespace.c:301"
  - "postgres/src/backend/commands/tablespace.c:993"
reproduced: false
---

# `tablespaces created by regression test cases should have names starting with "regress_"`

## What it means

The regression test suite's naming check found a tablespace whose name does not begin with the required `regress_` prefix for test-created objects.

## When it happens

It is emitted at WARNING during `make check` when a test creates a tablespace without the mandated prefix, which risks colliding with real objects on the installation under test.

## Is this a problem?

This is a developer-facing test-harness warning, not a production problem. If you hit it while running the suite, rename the tablespace in the offending test to start with `regress_`.

## Example

*Illustrative* — a test tablespace missing the prefix.

```text
WARNING:  tablespaces created by regression test cases should have names starting with "regress_"
```

## Related

- [roles created by regression test cases should have names starting with regress_](./roles-created-by-regression-test-cases-should-have-names-starting-with-regress.md)
- [subscriptions created by regression test cases should have names starting with regress_](./subscriptions-created-by-regression-test-cases-should-have-names-starting-with.md)
