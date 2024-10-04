INSERT INTO `EXPLAIN ANALYZE
WITH Flower_order_counts AS (
    SELECT 
        f.name_flower,
        COUNT(*) AS order_count
    FROM flower_orders fo
    JOIN flowers f ON fo.flower_id = f.flower_id
    GROUP BY f.flower_id, f.name_flower
)
SELECT 
    (SELECT CONCAT(name_flower, ': ', order_count)
     FROM Flower_order_counts
     ORDER BY order_count ASC
     LIMIT 1) AS least_ordered_flower,
     
    (SELECT CONCAT(name_flower, ': ', order_count)
     FROM Flower_order_counts
     ORDER BY order_count DESC
     LIMIT 1) AS most_ordered_flower` (`EXPLAIN`) VALUES
	 ('-> Rows fetched before execution  (cost=0..0 rows=1) (actual time=155e-6..228e-6 rows=1 loops=1)
-> Select #2 (subquery in projection; run only once)
    -> Limit: 1 row(s)  (cost=2.6..2.6 rows=0) (actual time=27.2..27.2 rows=1 loops=1)
        -> Sort: flower_order_counts.order_count, limit input to 1 row(s) per chunk  (cost=2.6..2.6 rows=0) (actual time=27.2..27.2 rows=1 loops=1)
            -> Table scan on Flower_order_counts  (cost=2.5..2.5 rows=0) (actual time=26.6..26.8 rows=1000 loops=1)
                -> Materialize CTE flower_order_counts if needed  (cost=0..0 rows=0) (actual time=26.6..26.6 rows=1000 loops=1)
                    -> Table scan on <temporary>  (actual time=25.9..26.3 rows=1000 loops=1)
                        -> Aggregate using temporary table  (actual time=25.9..25.9 rows=1000 loops=1)
                            -> Nested loop inner join  (cost=1396 rows=10029) (actual time=0.0724..15.2 rows=10000 loops=1)
                                -> Table scan on f  (cost=102 rows=1000) (actual time=0.0461..0.718 rows=1000 loops=1)
                                -> Covering index lookup on fo using flower_id (flower_id=f.flower_id)  (cost=0.292 rows=10) (actual time=0.00947..0.0129 rows=10 loops=1000)
-> Select #4 (subquery in projection; run only once)
    -> Limit: 1 row(s)  (cost=2.6..2.6 rows=0) (actual time=0.395..0.395 rows=1 loops=1)
        -> Sort: flower_order_counts.order_count DESC, limit input to 1 row(s) per chunk  (cost=2.6..2.6 rows=0) (actual time=0.395..0.395 rows=1 loops=1)
            -> Table scan on Flower_order_counts  (cost=2.5..2.5 rows=0) (actual time=0.00859..0.2 rows=1000 loops=1)
                -> Materialize CTE flower_order_counts if needed (query plan printed elsewhere)  (cost=0..0 rows=0) (never executed)
');
