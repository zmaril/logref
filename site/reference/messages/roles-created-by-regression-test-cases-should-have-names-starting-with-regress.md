---
message: "roles created by regression test cases should have names starting with \"regress_\""
slug: roles-created-by-regression-test-cases-should-have-names-starting-with-regress
passthrough: false
api: [elog]
level: [WARNING]
call_sites:
  - "postgres/src/backend/commands/user.c:371"
  - "postgres/src/backend/commands/user.c:1416"
reproduced: false
---

# `roles created by regression test cases should have names starting with "regress_"`

## What it means

The regression test suite's naming check found a role whose name does not begin with the `regress_` prefix that test-created roles are required to use.

## When it happens

It is emitted at WARNING during `make check` when a test creates a global object (a role) without the mandated prefix, which risks colliding with real objects on the installation being tested.

## Is this a problem?

This warning is aimed at Postgres developers and test authors, not at production users. If you see it while running the test suite, rename the offending role in the test to start with `regress_`. It is not something that appears in normal operation.

## Example

*Illustrative* — a test role missing the required prefix.

```text
WARNING:  roles created by regression test cases should have names starting with "regress_"
```

## Related

- [subscriptions created by regression test cases should have names starting with regress_](./subscriptions-created-by-regression-test-cases-should-have-names-starting-with.md)
- [tablespaces created by regression test cases should have names starting with regress_](./tablespaces-created-by-regression-test-cases-should-have-names-starting-with.md)
