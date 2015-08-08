
DECLARE tables_cursor CURSOR
   FOR
   SELECT name FROM sysobjects WHERE type = 'U' --//选择用户表名
OPEN tables_cursor --//打开游标连接

DECLARE @tablename sysname  --// 定义变量
FETCH NEXT FROM tables_cursor INTO @tablename   --//结果集中一行一行读取表名
WHILE (@@FETCH_STATUS <> -1)  --//判断游标状态 
BEGIN

   print 'UPDATE ' + @tablename + ' SET company_code = 3006' + CHAR(10) + 'GO'   --//清空表中的数据
   FETCH NEXT FROM tables_cursor INTO @tablename  --//下一行数据
END

DEALLOCATE tables_cursor  --//关闭游标

