/*
Stored procedure :Load Bronze Layer(Source->Bronze)

Script purpose:
  This stored procedure loads date in the bronze schema for external CSV files. 
  It performs the following actions :
    -Truncates the bronze tables before loading the data
    -Uses the 'Bulk Insertion' comand to load data from csv files to bronze tabls

Usage example:
  EXEC bronze.load_bronze 



*/



CREATE OR ALTER PROCEDURE bronze.load_bronze AS 

BEGIN
	DECLARE @start_time DATETIME, @endtime DATETIME ,@start_time_batch DATETIME, @endtime_batch DATETIME
	
	BEGIN TRY 
		PRINT '======================';
		PRINT 'Loading bronze layer';
		PRINT '======================';

		PRINT '======================';
		PRINT 'Loading CRM tables';
		PRINT '======================';

		SET @start_time_batch = GETDATE();

		SET @start_time = GETDATE();

		TRUNCATE TABLE bronze.crm_cust_info ;

		BULK INSERT bronze.crm_cust_info 
		FROM 'C:\Users\User\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR =',',
		TABLOCK

		) ;

		SET @endtime = GETDATE();
		PRINT'LOAD DURATION TABLE crm_cust_info :'+ cast(DATEDIFF(second,@start_time,@endtime) AS NVARCHAR)+' seconds'
		PRINT '======================';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_prd_info ;

		BULK INSERT bronze.crm_prd_info 
		FROM 'C:\Users\User\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR =',',
		TABLOCK

		) ;
		SET @endtime = GETDATE();

		PRINT'LOAD DURATION TABLE crm_prd_info :'+ cast(DATEDIFF(second,@start_time,@endtime) AS NVARCHAR)+' seconds'
		PRINT '======================';



		SET @start_time = GETDATE();

		TRUNCATE TABLE bronze.crm_sales_details ;

		BULK INSERT bronze.crm_sales_details 
		FROM 'C:\Users\User\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR =',',
		TABLOCK

		) ;
		SET @endtime = GETDATE();
		PRINT'LOAD DURATION TABLE crm_sales_details  :'+ cast(DATEDIFF(second,@start_time,@endtime) AS NVARCHAR)+' seconds'
		PRINT '======================';




		PRINT '======================';
		PRINT 'Loading ERP tables';
		PRINT '======================';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_cust_az12 ;

		BULK INSERT bronze.erp_cust_az12 
		FROM 'C:\Users\User\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR =',',
		TABLOCK

		) ;
		SET @endtime = GETDATE();

		PRINT'LOAD DURATION TABLE erp_cust_az12   :'+ cast(DATEDIFF(second,@start_time,@endtime) AS NVARCHAR)+' seconds'
		PRINT '======================';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_loc_a101 ;

		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\User\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR =',',
		TABLOCK

		) ;
		SET @endtime = GETDATE();

		PRINT'LOAD DURATION TABLE erp_loc_a101   :'+ cast(DATEDIFF(second,@start_time,@endtime) AS NVARCHAR)+' seconds'
		PRINT '======================';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_px_cat_g1v2 ;

		BULK INSERT bronze.erp_px_cat_g1v2 
		FROM 'C:\Users\User\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR =',',
		TABLOCK

		) ;
		SET @endtime = GETDATE();
		PRINT'LOAD DURATION TABLE erp_px_cat_g1v2  :'+ cast(DATEDIFF(second,@start_time,@endtime) AS NVARCHAR)+' seconds'
		PRINT '======================';

		SET @endtime_batch = GETDATE();
		PRINT '======================';
		PRINT'LOAD DURATION TABLE BATCH :'+ cast(DATEDIFF(second,@start_time_batch,@endtime_batch) AS NVARCHAR)+' seconds'
		PRINT '======================';



	END TRY
	BEGIN CATCH
		PRINT '========================='
		PRINT 'ERROR DURING LOADING BRONZE LAYER'
		PRINT 'ERROR MESSAGE'+ERROR_MESSAGE()
		PRINT 'ERROR NUMBER'+CAST(ERROR_NUMBER() AS NVARCHAR)
		PRINT '========================='
	END CATCH



END
