--Number of distinct sources
SELECT COUNT(DISTINCT utm_source) AS 'Source Count'
FROM page_visits;

--Number of distinct campaigns
SELECT COUNT(DISTINCT utm_campaign) AS 'Campaign Count'
FROM page_visits;

--Relationship between utm_cmapaign and utm_source
SELECT DISTINCT utm_campaign AS Campaigns,
	utm_source AS Source
FROM page_visits;

--Distinct pages on CoolTShirts
SELECT DISTINCT page_name AS 'Page Names'
FROM page_visits;

--Temporary table to link user ids and first touch times
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),

--Temp table to join first_touch table with source and campaign from page_visits

ft_attr AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)

--Selecting count of first touches associated with a campaign and source

SELECT ft_attr.utm_source AS Source,
       ft_attr.utm_campaign AS Campaign,
       COUNT(*) AS Count
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

--Temporary table to link user ids and last touch times
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
--Temp table to join last_touch table with source and campaign from page_visits
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
--Selecting count of last touches associated with a campaign and source
SELECT lt_attr.utm_source AS Source,
       lt_attr.utm_campaign AS Campaign,
       COUNT(*) AS Count
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

-- Count number of purchase made by distinct users
SELECT COUNT(DISTINCT user_id) AS 'Purchasing Customers'
FROM page_visits
WHERE page_name = '4 - purchase';

--Temporary table to link user ids and last touch times
--With added WHERE clause to select last touch on purchase page
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
  		WHERE page_name = '4 - purchase'
    GROUP BY user_id),
--Temp table to join last_touch table with source and campaign from page_visits
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
--Selecting count of last touches associated with a campaign and source
SELECT lt_attr.utm_source AS Source,
       lt_attr.utm_campaign AS Campaign,
       COUNT(*) AS Count
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

