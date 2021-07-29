SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		zpope
-- Create date: 2021-02-28
-- Description:	Adds a new state
-- =============================================
CREATE PROCEDURE prc_States_Insert
	@StateCode char(2),
	@StateName varchar(50),
	@PopulationDensity float,
	@Population2018 int,
	@AreaSquareMiles float
AS
BEGIN
	SET NOCOUNT ON;

    INSERT INTO States 
			(StateCode, 
			StateName, 
			PopulationDensity, 
			Population2018, 
			AreaSquareMiles)
	VALUES (@StateCode,
			@StateName,
			@PopulationDensity,
			@Population2018,
			@AreaSquareMiles)
END
GO
