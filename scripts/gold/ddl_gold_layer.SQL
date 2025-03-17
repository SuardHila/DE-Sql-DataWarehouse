========================================================================================================================

/*
This SQL code creates three views in the gold schema:

gold.dim_customers: Combines customer data from crm_cust_info, erp_cust_az12, and erp_loc_a101, creating a customer dimension with details like customer_key, customer_id, name, birthday, gender, country, and marital_status.

gold.dim_products: Combines product data from crm_prd_info and erp_px_cat_g1v2, creating a product dimension with details like product_key, product_id, name, category, cost, and start date for active products.

gold.fact_sales: Joins sales data from crm_sales_details with dim_products and dim_customers to create a sales fact table, including details like order_number, sales_amount, quantity, and price.

These views organize and simplify customer, product, and sales data for analysis.


*/
========================================================================================================================
CREATE VIEW gold.dim_customers AS

SELECT 
	ROW_NUMBER()OVER(ORDER BY cst_id) AS customer_key,
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
	ca.bdate AS birthday,
	CASE WHEN ci.cst_gndr !='n/a' THEN ci.cst_gndr
		ELSE COALESCE(ca.gen,'n/a')
	END AS gender ,
	la.cntry AS country,
    ci.cst_material_status AS marital_status,
	ci.cst_create_date AS create_date
		
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON CAST(ci.cst_key AS NVARCHAR) = ca.cid
LEFT JOIN silver.erp_loc_a101 la
    ON CAST(ci.cst_key AS NVARCHAR) = la.cid

CREATE VIEW gold.dim_products AS

SELECT 
	ROW_NUMBER()OVER(ORDER BY pn.prd_start_dt , pn.prd_key) AS product_key ,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,
	pn.prd_cost AS product_cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS product_start_date


FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.prd_key = pc.ID
WHERE prd_end_dt IS NULL


CREATE VIEW gold.fact_sales AS

SELECT 
sd.sls_ord_num AS order_number,
pr.product_key  ,
cu.customer_key,
sd.sls_order_dt AS order_date,
sd.sls_ship_dt AS shiping_date ,
sd.sls_sales AS sales_amount ,
sd.sls_due_dt,
sd.sls_quantity AS quantity ,
sd.sls_price AS price
FROM SILVER.CRM_SALES_DETAILS sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key =pr.category_id
LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id =cu.customer_id



