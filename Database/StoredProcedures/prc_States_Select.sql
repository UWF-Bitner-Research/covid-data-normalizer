/****** Object:  StoredProcedure [dbo].[prc_States_Select]    Script Date: 7/29/21 1:01:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		zpope
-- Create date: 2021-03-07
-- Description:	Returns a list of states
-- =============================================
ALTER PROCEDURE [dbo].[prc_States_Select]
	
AS
BEGIN
	SET NOCOUNT ON;

    SELECT
		StateCode,
		StateName,
		PopulationDensity,
		Population2018,
		AreaSquareMiles
	FROM States
END
