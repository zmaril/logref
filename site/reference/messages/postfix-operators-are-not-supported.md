---
message: "postfix operators are not supported"
slug: postfix-operators-are-not-supported
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_oper.c:115"
  - "postgres/src/backend/parser/parse_oper.c:727"
reproduced: false
---

# `postfix operators are not supported`

## What it means

A statement used or defined a postfix (right-unary) operator. Postgres removed support for postfix operators, so both defining one and writing an expression that relies on one are rejected.

## When it happens

It arises from `CREATE OPERATOR` that omits a right operand (declaring a postfix operator), or from parsing legacy SQL that used a postfix operator such as the old factorial `5!`.

## How to fix

Rewrite using a function or a prefix/infix operator. For the classic factorial example, use the `factorial(5)` function. For custom operators, redefine them as prefix or infix and update callers.

## Example

*Illustrative* — a query relying on a removed postfix operator.

```text
ERROR:  postfix operators are not supported
```

## Related

- [SETOF type not allowed for operator argument](./setof-type-not-allowed-for-operator-argument.md)
- [%s requires = operator to yield boolean](./requires-operator-to-yield-boolean.md)
