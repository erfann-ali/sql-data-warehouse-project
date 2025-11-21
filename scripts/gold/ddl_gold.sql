USE [DataWarehouse]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [gold].[dim_customers] AS
SELECT
	ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key, --Surrogate Key: it is a unique identifier
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.cntry AS country,
	ci.cst_material_status AS material_status,
	CASE
		WHEN ci.cst_gndr != 'N/A' THEN ci.cst_gndr
		ELSE COALESCE(ca.gen, 'N/A')
	END gender,
	ca.bdate AS birthdate,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid
GO
