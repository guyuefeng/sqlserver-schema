 SELECT a.name ,
        b.rows
 FROM   sysobjects AS a
        INNER JOIN sysindexes AS b ON a.id = b.id
 WHERE  ( a.type = 'U' )
        AND ( b.indid IN ( 0, 1 ) )
 ORDER BY b.rows DESC
