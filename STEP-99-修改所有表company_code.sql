
DECLARE tables_cursor CURSOR
   FOR
   SELECT name FROM sysobjects WHERE type = 'U' --//ѡ���û�����
OPEN tables_cursor --//���α�����

DECLARE @tablename sysname  --// �������
FETCH NEXT FROM tables_cursor INTO @tablename   --//�������һ��һ�ж�ȡ����
WHILE (@@FETCH_STATUS <> -1)  --//�ж��α�״̬ 
BEGIN

   print 'UPDATE ' + @tablename + ' SET company_code = 3006' + CHAR(10) + 'GO'   --//��ձ��е�����
   FETCH NEXT FROM tables_cursor INTO @tablename  --//��һ������
END

DEALLOCATE tables_cursor  --//�ر��α�

