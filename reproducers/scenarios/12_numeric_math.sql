-- Arithmetic / numeric-function domain errors  ->  src/backend/utils/adt/{numeric,float,int}.c
-- Division by zero, undefined math-function domains, and NaN/Infinity handling
-- across the numeric types.

SELECT 1 / 0;
SELECT 1.0 / 0.0;
SELECT 1::numeric / 0;
SELECT 1::float8 / 0::float8;
SELECT 1 % 0;
SELECT 5 % 0::numeric;
SELECT mod(5, 0);
SELECT div(5, 0::numeric);
SELECT ln(0);
SELECT ln(-1);
SELECT log(0);
SELECT log(-10);
SELECT log(0, 10);
SELECT log(10::numeric, 1::numeric);
SELECT sqrt(-1);
SELECT sqrt(-1::numeric);
SELECT power(0, -1);
SELECT power(0::numeric, -1);
SELECT power(-1, 0.5);
SELECT power(-1::numeric, 0.5);
SELECT acos(2);
SELECT asin(-2);
SELECT acosh(0);
SELECT atanh(2);
SELECT gamma(0);
SELECT lgamma(0);
SELECT factorial(-1);
SELECT (-1)!;
SELECT gcd(0, 0)::int / 0;
SELECT 'NaN'::numeric::int4;
SELECT 'Infinity'::float8::int8;
SELECT 'NaN'::float8::numeric::int8;
SELECT to_char('NaN'::numeric, '999');
SELECT width_bucket(5, 10, 1, 0);
SELECT width_bucket(1.0, 0.0, 0.0, 5);
SELECT round(1.5, -2147483648);
SELECT trunc(1.5, 2147483647);
SELECT numeric_send(1e100000::numeric);
SELECT scale('NaN'::numeric);
