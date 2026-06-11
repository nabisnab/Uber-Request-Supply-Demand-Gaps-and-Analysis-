CREATE DATABASE uber_db;
USE uber_db;
-- inspect data
SELECT * FROM uber_request_data_cleaned
LIMIT 10;
-- total request count
SELECT COUNT(*) AS total_requests
FROM uber_request_data_cleaned;
-- Status distribution
SELECT Status, COUNT(*) AS total
FROM uber_requests
GROUP BY Status;

-- Pickup point analysis
SELECT `Pickup point`, COUNT(*) AS total
FROM uber_requests
GROUP BY `Pickup point`;

-- Hourly demand
SELECT hour, COUNT(*) AS requests
FROM uber_requests
GROUP BY hour
ORDER BY hour;

-- Time slot analysis
SELECT time_slot, COUNT(*) AS requests
FROM uber_requests
GROUP BY time_slot;

-- Average trip duration
SELECT AVG(duration_min) AS avg_duration
FROM uber_requests
WHERE Status = 'Trip Completed';
