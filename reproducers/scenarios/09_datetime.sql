-- Date / time / interval / timezone errors  ->  src/backend/utils/adt/date*.c, timestamp.c, datetime.c
-- Field-out-of-range, unparseable literals, bad formats and timezone lookups.

SELECT '2020-13-01'::date;
SELECT '2020-02-30'::date;
SELECT '2020-00-01'::date;
SELECT 'notadate'::date;
SELECT '2020-01-01 25:00:00'::timestamp;
SELECT '2020-01-01 12:61:00'::timestamp;
SELECT '2020-01-01 12:00:61'::timestamp;
SELECT 'notatime'::time;
SELECT '25:00'::time;
SELECT 'nonsense'::timestamptz;
SELECT '2020-01-01'::timestamptz AT TIME ZONE 'Mars/Phobos';
SELECT now() AT TIME ZONE 'Nowhere/Nowhere';
SELECT make_date(2020, 13, 1);
SELECT make_date(2020, 1, 40);
SELECT make_time(25, 0, 0);
SELECT make_timestamp(2020, 0, 1, 0, 0, 0);
SELECT make_interval(mons => 2147483647, days => 2147483647);
SELECT to_date('2020-99-99', 'YYYY-MM-DD');
SELECT to_timestamp('nope', 'YYYY');
SELECT to_date('', '');
SELECT '1 badunit'::interval;
SELECT 'P1Y2X'::interval;
SELECT extract(nonsense FROM now());
SELECT date_trunc('nonsense', now());
SELECT date_part('nonsense', now());
SELECT '294277-01-01'::timestamp;
SELECT '4714-01-01 BC'::date - 1000000000;
SELECT age('notadate'::date);
SELECT '24:00:00.1'::time;
SELECT to_char(now(), repeat('Y', 100000));
SELECT justify_hours('2147483647 days'::interval * 1000000);
SELECT generate_series('2020-01-01'::timestamp, '2020-12-31'::timestamp, '0 seconds'::interval);
SELECT '10000000000 years'::interval;
