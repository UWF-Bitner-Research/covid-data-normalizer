/****** Object:  StoredProcedure [dbo].[prc_CaseNumbersWithAndWithoutMandate_ThreeWeeks]    Script Date: 4/9/21 1:02:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		zpope
-- Create date: 2021-04-09
-- Description:	Returns case numbers with a mandate vs without - two weeks before a mandate and three weeks after to five weeks after
-- =============================================
CREATE PROCEDURE [dbo].[prc_CaseNumbersWithAndWithoutMandate_ThreeWeeks]
	
AS
BEGIN
	
	SET NOCOUNT ON;

	if object_id( 'tempdb..#StateMandateCases') is not null
		drop table #StateMandateCases

	CREATE TABLE #StateMandateCases (StateCode char(2), CasesWithoutMandate int, CasesWithMandate int, MandateEnforced bit)
	insert into #StateMandateCases (StateCode, CasesWithoutMandate, CasesWithMandate, MandateEnforced)
	select scd.StateCode,
	sum(case when scd.SubmissionDate between DATEADD(WEEK, -2, sm.StartDate) and sm.StartDate then NewCases
		else 
			0
		end
	) as CasesWithoutMandate,
	sum(case when scd.SubmissionDate between DATEADD(week, 3, sm.StartDate) and DATEADD(week, 5, sm.StartDate) then NewCases
		else 
			0
		end
	) as CasesWithMandate,
	sm.MandateEnforced
	from StateCaseData scd
	join StateMandate sm on sm.StateCode = scd.StateCode and sm.MandateTypeID = 1
	group by scd.StateCode, sm.MandateEnforced
	order by scd.StateCode

	Select StateCode, CasesWithoutMandate, CasesWithMandate, m.DidMandateReduceCases, MandateEnforced
	from #StateMandateCases s
	outer apply (select case when CasesWithMandate >= CasesWithoutMandate then 0 else 1 end as DidMandateReduceCases) m
	order by m.DidMandateReduceCases desc
END
