SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		zpope
-- Create date: 2021-03-07
-- Description:	Inserts into the StateCaseData table
-- =============================================
CREATE PROCEDURE prc_StateCaseData_Insert
	@StateCode char(2),
	@SubmissionDate date,
	@TotalCases int,
	@ConfirmedCases int,
	@ProbableCases int,
	@NewCases int,
	@ProbableNewCases int,
	@TotalDeaths int,
	@ConfirmedDeaths int,
	@ProbableDeaths int,
	@NewDeaths int,
	@ProbableNewDeaths int,
	@Created date
AS
BEGIN
	SET NOCOUNT ON;

    INSERT INTO StateCaseData
		(StateCode,
		SubmissionDate,
		TotalCases,
		ConfirmedCases,
		ProbableCases,
		NewCases,
		ProbableNewCases,
		TotalDeaths,
		ConfirmedDeaths,
		ProbableDeaths,
		NewDeaths,
		ProbableNewDeaths,
		Created)
	VALUES 
		(@StateCode,
		@SubmissionDate,
		@TotalCases,
		@ConfirmedCases,
		@ProbableCases,
		@NewCases,
		@ProbableNewCases,
		@TotalDeaths,
		@ConfirmedDeaths,
		@ProbableDeaths,
		@NewDeaths,
		@ProbableNewDeaths,
		@Created)
END
GO
