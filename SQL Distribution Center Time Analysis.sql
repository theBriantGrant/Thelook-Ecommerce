--First, create a CTE allows the avg of the inventory days in the main body
WITH avg_inv_calc AS (
SELECT d.name, ROUND(AVG(TIMESTAMP_DIFF(ii.sold_at, ii.created_at, DAY)),2)  AS avg_inv_storage_days
--Using TIMESTAMP_DIFF to see how long an item was in the inventory before it was sold
FROM `bigquery-public-data.thelook_ecommerce.inventory_items` AS ii
JOIN `bigquery-public-data.thelook_ecommerce.distribution_centers` AS d
  ON ii.product_distribution_center_id = d.id
GROUP BY d.name
),
--Create a CTE that sums the total price of order items with a return data
  return_price_calc AS (
    SELECT d.name, ROUND(SUM(oi.sale_price),2) AS return_price_sum
FROM `bigquery-public-data.thelook_ecommerce.distribution_centers` AS d
LEFT JOIN `bigquery-public-data.thelook_ecommerce.products` AS p
  ON d.id = p.distribution_center_id 
LEFT JOIN `bigquery-public-data.thelook_ecommerce.order_items` AS oi
  ON p.id = oi.product_id  
WHERE oi.returned_at IS NOT NULL
GROUP BY d.name
)
--Select the desired differences in timestamps and join required tables
SELECT  
d.name AS distib_center,
ROUND(AVG(TIMESTAMP_DIFF(o.shipped_at, o.created_at, HOUR)),2) AS avg_order_ship_hr,
ROUND(AVG(TIMESTAMP_DIFF(o.delivered_at, o.shipped_at, HOUR)),2) AS avg_ship_deliver_hr, 
ROUND(AVG(TIMESTAMP_DIFF(o.returned_at, o.delivered_at, HOUR)),2) AS deliver_return_hr, 
AVG(avg_inv_storage_days) AS avg_inv_storage_days,
COUNT(oi.returned_at) AS return_item_quantity,
ROUND(SUM(oi.sale_price),2) AS return_price_sum
FROM `bigquery-public-data.thelook_ecommerce.orders` AS o
LEFT JOIN `bigquery-public-data.thelook_ecommerce.order_items` AS oi
  ON o.order_id = oi.order_id
LEFT JOIN `bigquery-public-data.thelook_ecommerce.products` AS p
  ON oi.product_id = p.id
LEFT JOIN `bigquery-public-data.thelook_ecommerce.distribution_centers` AS d
  ON p.distribution_center_id = d.id
JOIN avg_inv_calc AS aic
  ON d.name = aic.name
JOIN return_price_calc AS rpc
  ON d.name = rpc.name
GROUP BY d.name
