  SELECT 
  o.order_id,
  ROUND(oi.sale_price,2) AS sale_price,
  o.num_of_item,
  p.category,
  p.name AS product_name,
  o.created_at,
  o.returned_at,
  o.shipped_at,
  o.delivered_at,
  d.name distrib_name,
  d.distribution_center_geom,
  o.status 
  FROM `bigquery-public-data.thelook_ecommerce.orders` AS o
  LEFT JOIN `bigquery-public-data.thelook_ecommerce.order_items` AS oi
    ON o.order_id = oi.order_id
  LEFT JOIN `bigquery-public-data.thelook_ecommerce.products` AS p
    ON oi.product_id = p.id
  LEFT JOIN `bigquery-public-data.thelook_ecommerce.distribution_centers` AS d
    ON p.distribution_center_id = d.id


