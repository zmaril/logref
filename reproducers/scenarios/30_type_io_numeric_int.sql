-- Numeric typmod, per-operator integer overflow, float domain, money math  ->  src/backend/utils/adt/{numeric,int,int8,float,cash}.c
-- Secondary value-error lines the baseline input casts never reach: scale/precision
-- application, numeric->integer conversion overflow, per-width arithmetic operators,
-- gcd/lcm overflow, float special-value branches, and cash arithmetic/division.

-- numeric scale/precision application (numeric.c apply_typmod / make_result)
SELECT 12345.6::numeric(4,1);
SELECT 9.99::numeric(2,2);
SELECT 1.5::numeric(0,0);
SELECT 100.5::numeric(3,1);
SELECT 0.001::numeric(2,1) + 999.9::numeric(4,1);

-- numeric -> integer conversion overflow (numeric_int2/int4/int8, distinct from int*in)
SELECT (9e99::numeric)::int2;
SELECT (9e99::numeric)::int4;
SELECT (9e99::numeric)::int8;
SELECT (99999::numeric)::int2;
SELECT (2200000000::numeric)::int4;
SELECT (1e30::numeric)::int8;

-- numeric gcd/lcm overflow (numeric_lcm)
SELECT lcm(9e130000::numeric, 9e130000::numeric);
SELECT lcm(1e100000::numeric, 3e100000::numeric);

-- int2 per-operator overflow / division (int.c int2pl/int2mi/int2mul/int2div/int2mod/int2um/int2abs)
SELECT int2 '32767' + int2 '1';
SELECT int2 '-32768' - int2 '1';
SELECT int2 '-32768' * int2 '-1';
SELECT int2 '-32768' / int2 '-1';
SELECT int2 '5' % int2 '0';
SELECT -(int2 '-32768');
SELECT abs(int2 '-32768');

-- int4 per-operator overflow / division and gcd/lcm (int.c int4div/int4mod/int4gcd/int4lcm)
SELECT int4 '-2147483648' / int4 '-1';
SELECT int4 '10' % int4 '0';
SELECT gcd((-2147483648)::int4, 0);
SELECT lcm(2147483647, 2147483647);
SELECT lcm(1500000000, 1500000001);

-- int8 per-operator overflow / division and gcd/lcm (int8.c int8mod/int8mul/int8um/int8abs/int8mi/int8gcd/int8lcm)
SELECT int8 '5' % int8 '0';
SELECT int8 '-9223372036854775808' * int8 '-1';
SELECT -(int8 '-9223372036854775808');
SELECT abs(int8 '-9223372036854775808');
SELECT int8 '-9223372036854775808' - int8 '1';
SELECT gcd((-9223372036854775808)::int8, 0);
SELECT lcm(9223372036854775807::int8, 2::int8);

-- float residuals: setseed range, ^ domain branches, float8->float4 narrowing (float.c)
SELECT setseed(2);
SELECT setseed(-2);
SELECT (0::float8) ^ (-1::float8);
SELECT (-2::float8) ^ 0.5::float8;
SELECT (1e300::float8)::float4;
SELECT (-1e300::float8)::float4;

-- money input range and arithmetic overflow / divide-by-zero (cash.c)
SELECT '-92233720368547758.09'::money;
SELECT '92233720368547758.08'::money * 2;
SELECT '92233720368547758.08'::money * 2::float8;
SELECT '1.00'::money / 0;
SELECT '1.00'::money / 0::int4;
SELECT '1.00'::money / 0::int8;
SELECT '1.00'::money / 0::int2;
SELECT '1.00'::money / 0::float8;
