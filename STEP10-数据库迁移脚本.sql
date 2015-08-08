/*
批量生成迁移脚本

#######需指定LINKSERVER地址

*/
    SET NOCOUNT ON
    DECLARE @database VARCHAR(50) =DB_NAME()
    
    -- 厂房表
	DECLARE @tbl_company TABLE
	(
	  id INT IDENTITY(1, 1) ,
	  company_code VARCHAR(4) ,
	  company_name VARCHAR(50),
	  linkserverstr VARCHAR(500)
	)
	--      
	INSERT   INTO @tbl_company
			( company_code ,
			  company_name ,
			  linkserverstr
			)
	SELECT  '3006' ,'HZ','LINKSERVERHZSBIUAT' 
	--UNION	SELECT  '3005' ,'NJ','LINKSERVERNJSBIUAT' 
	--UNION	SELECT  '3010' ,'XM','LINKSERVERXMSBIUAT' 
	--UNION	SELECT  '3013' ,'GD','LINKSERVERGDSBIUAT' 
	--UNION	SELECT  '3007' ,'XA','LINKSERVERXASBIUAT' 
	--UNION	SELECT  '3008' ,'ZZ','LINKSERVERZZSBIUAT' 
	--UNION	SELECT  '3009' ,'HF','LINKSERVERHFSBIUAT'
	--select * from @tbl_company
	DECLARE @company_code VARCHAR(4)
	DECLARE @linkserverstr VARCHAR(500)
	
	
	
	--------------------- 遍历各厂房
	DECLARE @ID int
    SELECT @ID=MIN(id) FROM @tbl_company
	WHILE NOT @ID IS NULL 
	BEGIN
		SELECT @company_code=company_code
		      ,@linkserverstr=linkserverstr 
		FROM @tbl_company WHERE id=@ID
		
		
		DECLARE @tablename VARCHAR(500)
		DECLARE @tab_cols_name VARCHAR(max) = ''
		DECLARE @sql VARCHAR(max)
		 
		DECLARE rs CURSOR
		FOR
			SELECT name FROM   sysobjects
			WHERE  xtype = 'U'

			OPEN rs 
			FETCH NEXT FROM rs INTO @tablename 
			WHILE @@FETCH_STATUS <> -1 -- =0 
			BEGIN 
					SELECT @tab_cols_name=@tab_cols_name + b.name  +','
					FROM    sysobjects a ,	syscolumns b
					WHERE   a.id = b.id
						AND a.type = 'U'
						AND a.name = @tablename
						AND b.name <> 'company_code'
				    SELECT @tab_cols_name = SUBSTRING(@tab_cols_name,1,LEN(LTRIM(RTRIM(@tab_cols_name)))-1)
				    
				    SELECT  @sql = 'INSERT INTO dbo.' + @tablename + '(company_code,'+@tab_cols_name + ')' + CHAR(10)
				                  + 'SELECT ''' +  @company_code + ''',' + @tab_cols_name + ' FROM ' + @linkserverstr +'.[' +@database +'].[dbo].' + @tablename + CHAR(10)
				                  
				    
				    -- 判断是否包含自增列,如果自增列需要单独处理
				    IF EXISTS ( SELECT TOP 1 1
							FROM    sysobjects
							WHERE   OBJECTPROPERTY(id, 'TableHasIdentity') = 1
									AND UPPER(name) = UPPER(@tablename) ) 
					    PRINT 'SET IDENTITY_INSERT ' + @tablename + ' ON' + CHAR(10)
					        + @sql 
					        + 'SET IDENTITY_INSERT ' + @tablename + ' OFF' + CHAR(10)
					        + 'GO'
					ELSE 
					    PRINT @sql + CHAR(10) + 'GO'
    
    

				    --PRINT @tab_cols_name

					 
					SET @tab_cols_name =''
				  
				FETCH NEXT FROM rs INTO @tablename		
			END
		CLOSE rs 
		DEALLOCATE rs
		
	    
		SELECT @ID=MIN(id) FROM @tbl_company WHERE id>@ID
	END