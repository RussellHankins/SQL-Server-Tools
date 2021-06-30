-- Input: a comma delimited list of integers like 1,4,9,16
-- Output: the list split by the comma and put into a table
-- This is designed for PK because it has a primary key.
-- This is important for speed when joining with large tables.
CREATE FUNCTION [fn_SplitPK]
(
	@sDelimiter CHAR(1),
	@sList TEXT
)
RETURNS @tblList TABLE
(
	Id INT NOT NULL,
	PRIMARY KEY(Id)
)
AS
BEGIN
	DECLARE @iLoop INTEGER
	DECLARE @iStart INTEGER
	DECLARE @sLetter VARCHAR(1)
		
	SET @iLoop = 1
	SET @iStart = 1
	WHILE 1 = 1
	BEGIN
		SET @sLetter = SUBSTRING(@sList,@iLoop,1) 
		IF ASCII(@sLetter) IS NULL
		BEGIN
			IF @iStart < @iLoop
			BEGIN
				INSERT INTO @tblList (Id)
				VALUES (CONVERT(INTEGER,SUBSTRING(@sList,@iStart,@iLoop- @iStart+1)))
			END
			BREAK			
		END
		IF @sLetter = @sDelimiter
		BEGIN
			IF @iStart < @iLoop
			BEGIN
				INSERT INTO @tblList (Id)
				VALUES (CONVERT(INTEGER,SUBSTRING(@sList,@iStart,@iLoop - @iStart)))
			END

			SET @iStart = @iLoop + 1			
		END
		SET @iLoop = @iLoop + 1
	END

	RETURN
END