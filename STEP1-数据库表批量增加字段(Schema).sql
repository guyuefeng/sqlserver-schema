/*
  ��������Ϊ�洢���� �Ӳ��� ���ʹ��
  
  ��ǰ���ݿ� ���������ֶ�
  
  ����Ҫ���ӵ��ֶ�
*/

-- Ĭ������ �����ֶ� company_no
DECLARE @oper VARCHAR(200) =' ADD company_code varchar(4) not null '

DECLARE @tablename VARCHAR(50)
DECLARE @str VARCHAR(200)
 
DECLARE rs CURSOR
FOR
 -- LOCAL SCROLL FOR 
 SELECT name
 FROM   sysobjects
 WHERE  xtype = 'U'

OPEN rs 
FETCH NEXT FROM rs INTO @tablename 
WHILE @@FETCH_STATUS <> -1 -- =0 
    BEGIN 
          --Print 'TableName:' 
          --Print '----------------------------' 
          --Print '' 
          --set @str='ALTER TABLE '+ @tablename +' ADD company_no varchar(4) not null default ''3006'''
        SET @str = 'ALTER TABLE ' + @tablename + ' ' + @oper + CHAR(10) + 'GO'
          --Print @str
          --Print '----------------------------' 
          PRINT @str 
        --EXEC (@str)
        FETCH NEXT FROM rs INTO @tablename 
    END
CLOSE rs 
DEALLOCATE rs