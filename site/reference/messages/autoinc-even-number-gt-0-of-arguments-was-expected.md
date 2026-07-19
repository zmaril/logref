---
message: "autoinc (%s): even number gt 0 of arguments was expected"
slug: autoinc-even-number-gt-0-of-arguments-was-expected
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/spi/autoinc.c:65"
reproduced: false
---

# `autoinc (%s): even number gt 0 of arguments was expected`

## What it means

The `autoinc` example trigger from the `spi` contrib module was created with an odd number of, or zero, arguments. It expects arguments in column/sequence pairs, so the count must be even and greater than zero. The placeholder is the trigger name.

## When it happens

It occurs when a `CREATE TRIGGER ... EXECUTE FUNCTION autoinc(...)` supplies the wrong number of arguments.

## How to fix

Pass the trigger arguments as pairs of column name and sequence name, giving at least one pair. Review the `autoinc` documentation in the `spi` module for the exact argument format.

## Example

*Illustrative* — an odd argument count.

```text
ERROR:  autoinc (my_trigger): even number gt 0 of arguments was expected
```

## Related

- [attribute of must be type int4](./attribute-of-must-be-type-int4.md)
- [attribute of must be type text](./attribute-of-must-be-type-text.md)
