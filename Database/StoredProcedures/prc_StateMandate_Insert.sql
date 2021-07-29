SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		zpope
-- Create date: 2021-02-28
-- Description:	Inserts a new state mandate record
-- =============================================
CREATE PROCEDURE prc_StateMandate_Insert
	@StateCode char(2),
	@MandateTypeID int,
	@StartDate date,
	@EndDate date = NULL
AS
BEGIN
	SET NOCOUNT ON;

    INSERT INTO StateMandate
			(StateCode, 
			MandateTypeID,
			StartDate,
			EndDate)
	VALUES (@StateCode,
			@MandateTypeID,
			@StartDate,
			@EndDate)
END
GO
