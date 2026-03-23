--The result table identifies key KPIs by category
 SELECT
  p.category,
  p.name AS product_name,
  ROUND(p.retail_price,2) AS retail_price,
  ROUND(ii.cost,2) AS wholesale_price,
  COUNT(oi.product_id) AS total_units_sold,
  ROUND(retail_price * COUNT(oi.product_id),2) AS total_unit_revenue,
  ROUND((ii.cost) *COUNT(oi.product_id),2) AS total_unit_cogs,
  ROUND((retail_price - ii.cost) *COUNT(oi.product_id),2) AS total_unit_profit
  FROM `bigquery-public-data.thelook_ecommerce.products` AS p 
  JOIN `bigquery-public-data.thelook_ecommerce.inventory_items` AS ii
    ON p.id = ii.product_id
  JOIN `bigquery-public-data.thelook_ecommerce.distribution_centers` AS d
    ON p.distribution_center_id = d.id
  JOIN `bigquery-public-data.thelook_ecommerce.order_items` AS oi
    ON p.id = oi.product_id
  GROUP BY p.category,p.name, p.retail_price, ii.cost 
