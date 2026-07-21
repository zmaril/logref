-- Shared datetime decode/format engine value errors  ->  src/backend/utils/adt/{datetime,formatting,date,timestamp}.c
-- Reaches the DCH template parser, timezone lookup, timetz displacement, interval
-- justify/overflow helpers, textual DecodeDate paths, and per-type unit lookups
-- that the numeric-literal baseline in 09/16 does not touch.

-- to_timestamp / to_date DCH parse: source-too-short and template errors (formatting.c)
SELECT to_timestamp('2024-01-01', 'YYYY-MM-DD HH24:MI:SS');
SELECT to_timestamp('24', 'YYYY-MM-DD');
SELECT to_timestamp('2024-01-01 25', 'YYYY-MM-DD HH24');
SELECT to_timestamp('2024', 'YYYY-MM-DD"');

-- to_timestamp / to_date field value out of range with a valid template (datetime.c)
SELECT to_timestamp('2024-99', 'YYYY-MM');
SELECT to_timestamp('2024-01-99', 'YYYY-MM-DD');
SELECT to_date('2024-99-01', 'YYYY-MM-DD');
SELECT to_date('2024-01-99', 'YYYY-MM-DD');

-- textual DecodeDate field overflow (datetime.c, not the numeric literal path)
SELECT timestamp 'Feb 30 2024 10:00';
SELECT timestamp 'Jan 40 2024';

-- timezone abbreviation / named-zone not recognized (datetime.c, distinct decode sites)
SELECT timestamptz '2024-01-01 10:00 XYZ';
SELECT timestamp '2024-01-01 10:00' AT TIME ZONE 'Foo/Bar';
SELECT timetz '12:00:00' AT TIME ZONE 'Nowhere/Void';

-- timetz displacement out of range (date.c timetz decode)
SELECT timetz '12:00:00+16:00';
SELECT timetz '12:00:00-16:00';

-- interval decode junk (datetime.c DecodeInterval, distinct from unit-not-recognized)
SELECT interval '1 day 2';
SELECT interval '1 2 3 days';

-- interval justify / make overflow helpers (timestamp.c)
SELECT justify_interval(interval '2147483647 months 2147483647 days');
SELECT make_interval(secs => 1e308);
SELECT make_interval(hours => 2147483647, mins => 2147483647);

-- date_part / extract: unit not recognized or unsupported for a specific type
SELECT date_part('badunit', date '2024-01-01');
SELECT date_part('badunit', time '12:00:00');
SELECT extract(timezone FROM date '2024-01-01');
SELECT extract(timezone FROM time '12:00:00');
SELECT date_part('millennium2', timetz '12:00:00+00');
