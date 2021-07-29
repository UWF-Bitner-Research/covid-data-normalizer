SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		zpope
-- Create date: 2021-02-28
-- Description:	Gets a list of codes and associated mandates
-- =============================================
CREATE PROCEDURE prc_MandateCode_Select
	
AS
BEGIN
	SET NOCOUNT ON;

    SELECT
		dc.Code,
		dc.CodeDesc,
		mt.MandateTypeID,
		mt.MandateDescription
	FROM
		DatasetCodes dc
		JOIN MandateCodeMap mcm ON mcm.Code = dc.Code
		JOIN MandateType mt ON mt.MandateTypeID = mcm.MandateTypeID
END
GO
