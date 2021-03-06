/****** Object:  StoredProcedure [dbo].[prc_CaseNumbersWithAndWithoutMandate]    Script Date: 4/9/21 1:07:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		zpope
-- Create date: 2021-04-04
-- Description:	Returns case numbers with a mandate vs without
-- =============================================
CREATE PROCEDURE [dbo].[prc_CaseNumbersWithAndWithoutMandate]
	
AS
BEGIN
	
	SET NOCOUNT ON;

	if object_id( 'tempdb..#CaseNumbers') is not null
		drop table #CaseNumbers
	
	create table #CaseNumbers (StateCode char(2),CasesWithoutMandate int, CasesWithMandate int, DaysWithMandate int, DaysWithoutMandate int)
	insert into #CaseNumbers
	select scd.StateCode,
	sum(case when sm.StateCode is null then NewCases
		else 
			case when scd.SubmissionDate between startsm.StartDate and endsm.EndDate then 0 else NewCases end
		end
	) as CasesWithoutMandate,
	sum(case when sm.StateCode is null then 0
		else 
			case when scd.SubmissionDate between startsm.StartDate and endsm.EndDate then NewCases else 0 end
		end
	) as CasesWithMandate,
	isnull(DATEDIFF(day,startsm.StartDate,endsm.EndDate), 0) as DaysWithMandate,
	isnull(DATEDIFF(day,'2020-04-01','2021-01-01') - DATEDIFF(day,startsm.StartDate,endsm.EndDate), DATEDIFF(day,'2020-04-01','2021-01-01')) as DaysWithoutMandate
	from StateCaseData scd
	left join StateMandate sm on sm.StateCode = scd.StateCode and sm.MandateTypeID = 1
	outer apply (select case when sm.EndDate is null then cast('2021-01-01' as date) else sm.EndDate end as EndDate) endsm
	outer apply (select case when sm.StartDate < cast('2020-04-01' as date) then cast('2020-04-01' as date) else sm.StartDate end as StartDate) startsm
	where scd.StateCode <> 'UT' and SubmissionDate between '2020-04-01'  and '2020-12-31 23:59:59.999'
	group by scd.StateCode,startsm.StartDate,endsm.EndDate
	order by scd.StateCode


	select StateCode,
		case when DaysWithoutMandate = 0 then 0 else CasesWithoutMandate / DaysWithoutMandate end as CasesPerDayWithoutMandate,
		case when DaysWithMandate = 0 then 0 else CasesWithMandate / DaysWithMandate end as CasesPerDayWithMandate
	from #CaseNumbers
END
