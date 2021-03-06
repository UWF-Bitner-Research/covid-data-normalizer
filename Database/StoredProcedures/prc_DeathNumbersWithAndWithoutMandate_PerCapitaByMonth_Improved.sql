/****** Object:  StoredProcedure [dbo].[prc_DeathNumbersWithAndWithoutMandate_PerCapitaByMonth_Improved]    Script Date: 7/29/21 1:00:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		zpope
-- Create date: 2021-04-04
-- Description:	Returns case numbers with a mandate vs without
-- =============================================
CREATE PROCEDURE [dbo].[prc_DeathNumbersWithAndWithoutMandate_PerCapitaByMonth_Improved]
	
AS
BEGIN
	
	SET NOCOUNT ON;

	if object_id( 'tempdb..#Deaths') is not null
		drop table #Deaths
	create table #Deaths (DeathsWithMandate int, DeathsWithoutMandate int, [Month] varchar(10), MonthNumber int, [Year] int, StateCode char(2), StatePopulation int)
	insert into #Deaths
	select	
		sum(case when m.MandateExists = 1 then scd.NewDeaths else 0 end) as DeathsWithMandate,
		sum(case when m.MandateExists = 1 then 0 else scd.NewDeaths end) as DeathsWithoutMandate,
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
	create table #MonthAggregate (DeathsWithMandate int, DeathsWithoutMandate int, [Month] varchar(10), MonthNumber int, [Year] int, [PopulationWithMandate] int, [PopulationWithoutMandate] int)
	insert into #MonthAggregate
	select
		sum(DeathsWithMandate),sum(DeathsWithoutMandate),[Month],MonthNumber,[Year],sum(case when DeathsWithMandate > 0 then StatePopulation else 0 end), sum(case when DeathsWithoutMandate > 0 then StatePopulation else 0 end)
	from #Deaths
	group by [Month],MonthNumber,[Year]

	select m.*,
	convert(float, m.DeathsWithMandate) / convert(float, (m.PopulationWithMandate/100000.00)) as DeathsPerHundredThousandWithMandate,
	convert(float, m.DeathsWithoutMandate) / convert(float, (m.PopulationWithoutMandate/100000.00)) as DeathsPerHundredThousandWithoutMandate
	from #MonthAggregate m
	ORDER BY m.[Year],m.MonthNumber
END
