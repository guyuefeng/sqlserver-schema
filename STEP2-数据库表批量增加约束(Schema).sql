/*
  ��������Ϊ�洢���� �Ӳ��� ���ʹ��
  
  ��ǰ���ݿ� ���������ֶ�
  
  ����Ҫ���ӵ��ֶ�
*/

-- Ĭ������ �����ֶ� company_code
--DECLARE @oper VARCHAR(200) =' ADD company_code varchar(4) not null '

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
        SET @str = 'ALTER TABLE dbo.' + @tablename + ' ADD  CONSTRAINT [DF_dbo_' +@tablename +'_company_code]  DEFAULT ([SBIPlant].[F_GetCompanyCode]()) FOR [company_code]' + CHAR(10) + 'GO'
          --Print @str
          --Print '----------------------------' 
          PRINT @str 
        --EXEC (@str)
        FETCH NEXT FROM rs INTO @tablename 
    END
CLOSE rs 
DEALLOCATE rs