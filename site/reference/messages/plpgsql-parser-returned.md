---
message: "plpgsql parser returned %d"
slug: plpgsql-parser-returned
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_comp.c:684"
  - "postgres/src/pl/plpgsql/src/pl_comp.c:844"
reproduced: false
---

# `plpgsql parser returned %d`

## What it means

Internal error. The PL/pgSQL parser returned an unexpected status code to its caller during function compilation. The placeholder is the numeric code. It is a self-check on the parser's own result.

## When it happens

It fires from PL/pgSQL compilation glue when the underlying parse routine reports a value the caller did not expect. It points to an internal problem rather than an ordinary syntax error in the function body (which produces a normal syntax-error message).

## How to fix

This is an internal guard. If reproducible, capture the function source that triggers it and report it; a genuine syntax problem would surface as a specific parse error instead.

## Example

*Illustrative* — an unexpected parser return during compilation.

```text
ERROR:  plpgsql parser returned 2
```

## Related

- [query for CALL statement is not a CallStmt](./query-for-call-statement-is-not-a-callstmt.md)
- [record type has not been registered](./record-type-has-not-been-registered.md)
