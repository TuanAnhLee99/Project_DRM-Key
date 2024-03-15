USE `Class 4`;

CREATE TEMPORARY TABLE log_all AS (
SELECT customerID, Date(Date) AS date_trunc
FROM log_bhd_movieid
WHERE MovieID IN (
	SELECT id -- DRM-ed properties
	FROM mv_propertiesshowvn mp 
	WHERE isDRM = 1)
UNION 
SELECT customerID, Date(Date) AS date_trunc
FROM log_fimplus_movieid
WHERE MovieID IN (
	SELECT id -- DRM-ed properties
	FROM mv_propertiesshowvn mp 
	WHERE isDRM = 1)
UNION
SELECT CustomerID, Date AS date_trunc
FROM log_get_drm_list lgdl);

SELECT * FROM log_all;

SELECT 
	count(DISTINCT customerID) AS total_drm_count
	, date_trunc
	, CASE WHEN dayofweek(date_trunc) = 1 THEN 'Sunday'
		WHEN dayofweek(date_trunc) = 2 THEN 'Monday'
		WHEN dayofweek(date_trunc) = 3 THEN 'Tuesday'
		WHEN dayofweek(date_trunc) = 4 THEN 'Wednesday'
		WHEN dayofweek(date_trunc) = 5 THEN 'Thursday'
		WHEN dayofweek(date_trunc) = 6 THEN 'Friday'
		WHEN dayofweek(date_trunc) = 7 THEN 'Saturday' END AS day_of_week
FROM  log_all
GROUP BY date_trunc
ORDER BY date_trunc;

-- Kết luận:  dữ liệu fimplus chỉ có từ tháng 5 đến tháng 9 2019, và dữ liệu phim gói chỉ có từ tháng 4 2020

