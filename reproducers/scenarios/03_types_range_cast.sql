-- Out-of-range / overflow / illegal cast  ->  src/backend/utils/adt/**
-- Values that parse fine but overflow the target, or casts between types with
-- no path. Exercises the range-check and coercion ereports.

SELECT 32768::int2;
SELECT (-32769)::int2;
SELECT 2147483648::int4;
SELECT 9223372036854775808::int8;
SELECT 2147483647::int4 + 1;
SELECT (-2147483648)::int4 - 1;
SELECT 2000000000::int4 * 2;
SELECT 1e400::float8;
SELECT '1e-400'::float8 = 0;
SELECT 300::int4::int2 + 32767::int2;
SELECT factorial(1000)::int8;
SELECT (10::numeric ^ 1000)::int8;
SELECT '10 years'::interval * 1e300;
SELECT 'infinity'::numeric + 1;
SELECT 127::int2::"char"::int2;
SELECT abs((-2147483648)::int4);
SELECT (2147483647::int4) * (2147483647::int4);
SELECT 9223372036854775807::int8 + 1;
SELECT 65536::int4 * 65536::int4 * 65536::int4;
SELECT '32768'::text::int2;
SELECT (2^31)::int::int;
SELECT 255::int4 * 255::int4 * 255::int4 * 255::int4 * 255::int4;
SELECT lpad('x', 2000000000, 'y');
SELECT repeat('x', 2000000000);
SELECT '10000000000'::int8::int4;
SELECT round(1e308::float8)::numeric::int8;
SELECT (-1)::int4::bit(32)::int8::int4 - 2147483647 - 2147483647 - 2;
SELECT chr(-1);
SELECT chr(2000000000);
SELECT to_char(1, repeat('9', 100000));
