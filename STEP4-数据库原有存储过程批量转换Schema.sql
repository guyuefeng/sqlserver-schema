 /*
 ���ݿ�ԭ�д洢������������SCHEMA
 */
   
    declare @name sysname

    declare csr1 cursor

    for

    select name from sys.procedures 

    open csr1

 

    FETCH NEXT FROM csr1 INTO @name

    while (@@FETCH_STATUS=0)

    BEGIN

    SET @name='dbo.' + @name

 

    print 'Alter SCHEMA SBIPlant TRANSFER ' + @name + CHAR(10) + 'GO'

    fetch next from csr1 into @name

    END

    CLOSE csr1

    DEALLOCATE csr1
    