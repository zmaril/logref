---
message: "subscriptions created by regression test cases should have names starting with \"regress_\""
slug: subscriptions-created-by-regression-test-cases-should-have-names-starting-with
passthrough: false
api: [elog]
level: [WARNING]
call_sites:
  - "postgres/src/backend/commands/alter.c:297"
  - "postgres/src/backend/commands/subscriptioncmds.c:753"
reproduced: false
---

# `subscriptions created by regression test cases should have names starting with "regress_"`

## What it means

The regression test suite's naming check found a subscription whose name does not begin with the required `regress_` prefix for test-created objects.

## When it happens

It is emitted at WARNING during `make check` when a test creates a subscription without the mandated prefix, which could collide with real objects on the installation under test.

## Is this a problem?

This is a developer-facing warning from the test harness, not a production issue. If you hit it running the tests, rename the subscription in the offending test to start with `regress_`.

## Example

*Illustrative* — a test subscription missing the prefix.

```text
WARNING:  subscriptions created by regression test cases should have names starting with "regress_"
```

## Related

- [roles created by regression test cases should have names starting with regress_](./roles-created-by-regression-test-cases-should-have-names-starting-with-regress.md)
- [tablespaces created by regression test cases should have names starting with regress_](./tablespaces-created-by-regression-test-cases-should-have-names-starting-with.md)
