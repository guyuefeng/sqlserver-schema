/*
首先增加 Schema
CREATE SCHEMA testSchema AUTHORIZATION dbo

可设置为存储过程，加参数 ，使用更灵活

*/
	SET NOCOUNT ON 

	CREATE TABLE #tmp_tables
			(
			  id INT IDENTITY(1, 1) ,
			  tab_name VARCHAR(100) 
			)
	-- 获取所有表名
	INSERT   INTO #tmp_tables
			( 
			  tab_name 
			)
	SELECT  a.name
	FROM    sysobjects a 
	WHERE   a.type = 'U'
	--SELECT   *FROM     #tmp_tables
		 
		--创建视图脚本，批量生成创建视图SQL语句
		DECLARE @i INT , @cnt INT
		DECLARE @tab_name VARCHAR(100)
		DECLARE @tab_cols_name VARCHAR(max) = ''
		
		DECLARE @sql VARCHAR(max)
		DECLARE @result_sql TABLE ( sqlstr VARCHAR(max) )
		
		SET @i = 1
		SELECT   @cnt = MAX(id)
		FROM     #tmp_tables

		WHILE @i <= @cnt 
		BEGIN
			SELECT  @tab_name = tab_name
			FROM    #tmp_tables
			WHERE   id = @i
			
			-- 获取列名
			SELECT @tab_cols_name=@tab_cols_name + CHAR(10) + '    ' + b.name  +','
		    FROM    sysobjects a ,	syscolumns b
		    WHERE   a.id = b.id
				AND a.type = 'U'
				AND a.name = @tab_name
				AND b.name <> 'company_code'
				
			SELECT @tab_cols_name = SUBSTRING(@tab_cols_name,1,LEN(LTRIM(RTRIM(@tab_cols_name)))-1)
			
			--SELECT @tab_cols_name 
			DECLARE @pre_sql VARCHAR(max)
			SET @pre_sql ='-- =============================================
-- Author:		Ligf
-- Create date: 2014-05-09
-- Description:	Web101+原始表生成Schema视图
-- =============================================' + CHAR(10)
			
            SELECT  @sql = 'CREATE VIEW SBIPlant.' + @tab_name + CHAR(10)
                    + 'WITH SCHEMABINDING' + CHAR(10)
                    + 'AS ' + CHAR(10) 
                    + '    SELECT ' + @tab_cols_name + CHAR(10)
                    + '    FROM dbo.' + @tab_name + CHAR(10)
                    + '    WHERE company_code = CONVERT (VARCHAR, RIGHT(USER_NAME(),4))'
                    + CHAR(10) + 'GO' + CHAR(10)
			FROM    #tmp_tables
			WHERE   id = @i
			
			
			INSERT  INTO @result_sql
			SELECT  @sql
			
			--PRINT @tab_cols_name
			PRINT @pre_sql + @sql
			
			SET @tab_cols_name =''
					
			SELECT  @i = @i + 1
		END
		    
		--SELECT   *
		--FROM     @result_sql
		
		DROP TABLE #tmp_tables