SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		zpope
-- Create date: 2021-02-28
-- Description:	Selects all the mandates
-- =============================================
CREATE PROCEDURE prc_StateMandate_Select_All
	
AS
BEGIN
	SET NOCOUNT ON;

    SELECT
		sm.StateCode,
		s.StateName,
		mt.MandateDescription,
		sm.StartDate
	FROM StateMandate sm
		JOIN States s ON s.StateCode = sm.StateCode
		JOIN MandateType mt on mt.MandateTypeID = sm.MandateTypeID
END
GO
