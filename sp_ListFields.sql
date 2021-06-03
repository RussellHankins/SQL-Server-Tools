-- LIST TABLES IN A DATABASE OR LIST FIELDS IN A TABLE.
-- ALSO LISTS TABLE DESCRIPTIONS AND FIELD DESCRIPTIONS.
-- TO ADD A TABLE DESCRIPTION, ADD AN EXTENDED PROPERTY TO IT.
-- TO ADD A FIELD DESCRIPTION, ADD A DESCRIPTION TO THE FIELD
-- WHEN DESIGNING THE TABLE.
CREATE PROCEDURE [dbo].[sp_ListFields]
	@TableName SYSNAME = NULL
AS
BEGIN
-- =============================================
-- Create date: 1/1/2009
-- Description:	List fields in a database with the comments.
-- =============================================
DECLARE @iTableID INT
DECLARE @ForeignKeys TABLE
(
	RowID INT IDENTITY(1,1),
	PrimaryTableName SYSNAME,
	PrimaryFieldName SYSNAME,
	ForeignTableName SYSNAME,
	ForeignFieldName SYSNAME,
	PrimaryColID INT,
	ForeignColID INT,
	PrimaryTableID INT,
	ForeignTableID INT
)
DECLARE @ForeignKeyOutput TABLE
(
	ColID INT,	
	HasForeignKeysAt NVARCHAR(4000)
)
DECLARE @PrimaryKeyOutput TABLE
(
	ColID INT,
	HasPrimaryKeyAt NVARCHAR(4000)
)

	SET NOCOUNT ON
	DECLARE @iRowLoop INT
	DECLARE @iRowCount INT
	DECLARE @sKeyTableName SYSNAME
	DECLARE @sKeyFieldName SYSNAME
	DECLARE @iKeyColID INT
	DECLARE @iKeyTableID INT
	DECLARE @sForeignKeyInfo NVARCHAR(4000)

	IF ISNULL(@TableName,'') <> ''
	BEGIN
		SELECT @iTableID = id
		FROM sysobjects
		WHERE [name] = @TableName
		AND xtype='u'		
	END
	IF ISNULL(@iTableID,0) = 0
	BEGIN
		-- LIST TABLE
		SELECT SO.[name] AS TableName
		,ISNULL(SP.value,'') as Description
		from sysobjects AS SO
		LEFT OUTER JOIN sys.extended_properties as SP
		ON SO.id = SP.major_id
		AND SP.minor_id=0
		where SO.xtype='u'
		order by SO.name
	END ELSE
	BEGIN
		-- GET THE FOREIGN KEYS
		INSERT INTO @ForeignKeys (PrimaryTableName,PrimaryFieldName
		,ForeignTableName,ForeignFieldName
		,PrimaryColID,ForeignColID
		,PrimaryTableID,ForeignTableID)
		SELECT PT.name as PrimaryTableName
		,cp.name as PrimaryFieldName
		,FT.name as ForeignTableName
		,cf.NAME AS ForeignFieldName		
		,K.rkey AS PColID
		,K.fkey AS FColID
		,K.rkeyid as PrimaryTableID
		,K.fkeyid as ForeignTableID
		FROM sysforeignkeys AS K
		INNER JOIN sysobjects AS PT
		ON K.rkeyid = PT.id
		INNER JOIN sysobjects AS FT
		ON K.fkeyid = FT.id
		INNER JOIN syscolumns AS CP
		ON K.rkeyid = CP.id AND K.rkey = CP.colid
		INNER JOIN syscolumns AS CF
		ON K.fkeyid = CF.id AND K.fkey = CF.colid
		WHERE K.fkeyid  = @iTableID
		OR K.rkeyid = @iTableID

		-- LOOP THROUGH THE FOREIGN KEYS.
		SELECT @iRowCount = MAX(RowID) FROM @ForeignKeys
		
		-- FIND THE FIELDS THAT ARE PRIMARY KEYS.
		SET @iRowLoop = 1
		
		WHILE @iRowLoop <= @iRowCount
		BEGIN
			SELECT @sKeyTableName = ForeignTableName
			,@sKeyFieldName = ForeignFieldName
			,@iKeyColID = PrimaryColID
			,@iKeyTableID = PrimaryTableID
			FROM @ForeignKeys
			WHERE RowID = @iRowLoop

			IF @iKeyTableID = @iTableID
			BEGIN				
				-- THIS FIELD IS A PRIMARY KEY TO SOME FOREIGN KEY IN A DIFFERENT TABLE.
				SET @sForeignKeyInfo = NULL

				SELECT @sForeignKeyInfo = HasForeignKeysAt
				FROM @ForeignKeyOutput
				WHERE ColID = @iKeyColID

				SET @sForeignKeyInfo = ISNULL(@sForeignKeyInfo,'')
				IF LEN(@sForeignKeyInfo) > 0
				BEGIN
					SET @sForeignKeyInfo = @sForeignKeyInfo + N','
				END
				SET @sForeignKeyInfo = @sForeignKeyInfo + @sKeyTableName + N'.' + @sKeyFieldName

				DELETE FROM @ForeignKeyOutput
				WHERE ColID = @iKeyColID

				INSERT INTO @ForeignKeyOutput (ColID,HasForeignKeysAt)
				VALUES (@iKeyColID,@sForeignKeyInfo)
			END

			SET @iRowLoop = @iRowLoop + 1
		END

		-- FIND THE FIELDS THAT ARE FOREIGN KEYS.
		SET @iRowLoop = 1
		
		WHILE @iRowLoop <= @iRowCount
		BEGIN
			SELECT @sKeyTableName = PrimaryTableName
			,@sKeyFieldName = PrimaryFieldName
			,@iKeyColID = ForeignColID
			,@iKeyTableID = ForeignTableID
			FROM @ForeignKeys
			WHERE RowID = @iRowLoop

			IF @iKeyTableID = @iTableID
			BEGIN				
				-- THIS FIELD IS A PRIMARY KEY TO SOME FOREIGN KEY IN A DIFFERENT TABLE.
				SET @sForeignKeyInfo = NULL

				SELECT @sForeignKeyInfo = HasPrimaryKeyAt
				FROM @PrimaryKeyOutput
				WHERE ColID = @iKeyColID

				SET @sForeignKeyInfo = ISNULL(@sForeignKeyInfo,'')
				IF LEN(@sForeignKeyInfo) > 0
				BEGIN
					SET @sForeignKeyInfo = @sForeignKeyInfo + N','
				END
				SET @sForeignKeyInfo = @sForeignKeyInfo + @sKeyTableName + N'.' + @sKeyFieldName

				DELETE FROM @PrimaryKeyOutput
				WHERE ColID = @iKeyColID

				INSERT INTO @PrimaryKeyOutput (ColID,HasPrimaryKeyAt)
				VALUES (@iKeyColID,@sForeignKeyInfo)
			END

			SET @iRowLoop = @iRowLoop + 1
		END		

		-- LIST FIELDS IN THE TABLE.
		SELECT SC.name as [Column Name]
		,ST.name AS [Data Type]
		,SC.length as [Character Maximum Length]
		,SC.isnullable as [Is Nullable]
		,ISNULL(SP.value,'') As [Column Description]
		,ISNULL(SCO.[text],'') as [Column Default]
		,ISNULL(PKO.HasPrimaryKeyAt,'') As [Has Primary Key At]
		,ISNULL(FKO.HasForeignKeysAt,'') AS [Has Foreign Keys At]
		FROM syscolumns AS SC	
		INNER JOIN systypes AS ST
		ON SC.xtype = ST.xtype
		LEFT OUTER JOIN @ForeignKeyOutput AS FKO
		ON SC.colid = FKO.colid
		LEFT OUTER JOIN @PrimaryKeyOutput AS PKO
		ON SC.colid = PKO.colid
		LEFT OUTER JOIN syscomments as SCO
		ON SC.cdefault = SCO.id 
		LEFT OUTER JOIN sys.extended_properties as SP
		ON SC.colid = SP.minor_id
		AND SC.id = SP.major_id
		AND SP.name = 'MS_Description'
		WHERE ST.name <> 'sysname'
		and SC.id = @iTableID
		ORDER BY SC.colid
	END
END