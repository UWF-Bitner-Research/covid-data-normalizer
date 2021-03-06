/****** Object:  StoredProcedure [dbo].[prc_CaseNumbersWithAndWithoutMandate_PerCapitaByMonth_Improved]    Script Date: 7/29/21 1:00:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		zpope
-- Create date: 2021-04-04
-- Description:	Returns case numbers with a mandate vs without
-- =============================================
CREATE PROCEDURE [dbo].[prc_CaseNumbersWithAndWithoutMandate_PerCapitaByMonth_Improved]
	
AS
BEGIN
	
	SET NOCOUNT ON;

	if object_id( 'tempdb..#Cases') is not null
		drop table #Cases
	create table #Cases (CasesWithMandate int, CasesWithoutMandate int, [Month] varchar(10), MonthNumber int, [Year] int, StateCode char(2), StatePopulation int)
	insert into #Cases
	select	
		sum(case when m.MandateExists = 1 then scd.NewCases else 0 end) as CasesWithMandate,
		sum(case when m.MandateExists = 1 then 0 else scd.NewCases end) as CasesWithoutMandate,
		DATENAME(month,scd.SubmissionDate),
		DATEPART(month,scd.SubmissionDate),
		DATEPART(year,scd.SubmissionDate),
		s.StateCode,
		s.Population2018
	from StateCaseData scd
	join States s on s.StateCode = scd.StateCode
	outer apply (
		select case when exists (select * from StateMandate sm where scd.SubmissionDate between sm.StartDate and isnull(sm.EndDate, '2021-04-01') and sm.StateCode = scd.StateCode) then cast(1 as bit) else cast(0 as bit) end as MandateExists
	) m
	where scd.SubmissionDate between '2020-04-01' and '2021-03-31 23:59:59.999'
	group by DATENAME(month,scd.SubmissionDate),DATEPART(month,scd.SubmissionDate),DATEPART(year,scd.SubmissionDate), s.StateCode, s.Population2018

	if object_id( 'tempdb..#MonthAggregate') is not null
		drop table #MonthAggregate
	create table #MonthAggregate (CasesWithMandate int, CasesWithoutMandate int, [Month] varchar(10), MonthNumber int, [Year] int, [PopulationWithMandate] int, [PopulationWithoutMandate] int)
	insert into #MonthAggregate
	select
		sum(CasesWithMandate),sum(CasesWithoutMandate),[Month],MonthNumber,[Year],sum(case when CasesWithMandate > 0 then StatePopulation else 0 end), sum(case when CasesWithoutMandate > 0 then StatePopulation else 0 end)
	from #Cases
	group by [Month],MonthNumber,[Year]

	select m.*,
	convert(float, m.CasesWithMandate) / convert(float, m.PopulationWithMandate) as CasesPerCapitaWithMandate,
	convert(float, m.CasesWithoutMandate) / convert(float, m.PopulationWithoutMandate) as CasesPerCapitaWithoutMandate
	from #MonthAggregate m
	ORDER BY m.[Year],m.MonthNumber
END
