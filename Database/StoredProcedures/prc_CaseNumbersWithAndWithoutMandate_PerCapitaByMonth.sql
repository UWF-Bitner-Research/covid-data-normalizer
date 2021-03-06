/****** Object:  StoredProcedure [dbo].[prc_CaseNumbersWithAndWithoutMandate]    Script Date: 4/9/21 10:48:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		zpope
-- Create date: 2021-04-04
-- Description:	Returns case numbers with a mandate vs without
-- =============================================
CREATE PROCEDURE [dbo].[prc_CaseNumbersWithAndWithoutMandate_PerCapitaByMonth]
	
AS
BEGIN
	
	SET NOCOUNT ON;

	if object_id( 'tempdb..#Cases') is not null
		drop table #Cases
	create table #Cases (CasesInStatesWithMandate int, CasesInStatesWithoutMandate int, [Month] varchar(10), MonthNumber int)
	insert into #Cases
	select	
		sum(case when m.MandateExists = 1 then scd.NewCases else 0 end) as CasesInStatesWithMandate,
		sum(case when m.MandateExists = 0 then scd.NewCases else 0 end) as CasesInStatesWithoutMandate,
		DATENAME(month,scd.SubmissionDate),
		DATEPART(month,scd.SubmissionDate)
	from StateCaseData scd
	join States s on s.StateCode = scd.StateCode
	outer apply (select case when exists (select sm.StateCode from StateMandate sm where sm.StateCode = scd.StateCode and sm.MandateTypeID = 1) then 1 else 0 end as MandateExists) m
	where scd.SubmissionDate between '2020-04-01' and '2020-12-31 23:59:59.999'
	group by DATENAME(month,scd.SubmissionDate),DATEPART(month,scd.SubmissionDate)

	if object_id( 'tempdb..#Population') is not null
		drop table #Population
	create table #Population (PopulationInStatesWithMandate int, PopulationInStatesWithoutMandate int)
	insert into #Population
	select	
		sum(case when m.MandateExists = 1 then convert(bigint,s.Population2018) else 0 end) as PopulationInStatesWithMandate,
		sum(case when m.MandateExists = 0 then convert(bigint,s.Population2018) else 0 end) as PopulationInStatesWithoutMandate
	from States s
	outer apply (select case when exists (select sm.StateCode from StateMandate sm where sm.StateCode = s.StateCode and sm.MandateTypeID = 1) then 1 else 0 end as MandateExists) m

	select convert(float, c.CasesInStatesWithMandate) / convert(float, p.PopulationInStatesWithMandate) as CasesPerCapitaInStatesWithMandate,
	convert(float, c.CasesInStatesWithoutMandate) / convert(float, p.PopulationInStatesWithoutMandate) as CasesPerCapitaInStatesWithoutMandate,
	c.[Month]
	from #Population p, #Cases c
	order by c.MonthNumber
END
