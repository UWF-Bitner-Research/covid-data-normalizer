Imports System
Imports System.Data
Imports System.IO
Imports CovidDataClasses
Module Main
    Sub Main(args As String())
        AddStates()
        AddStateMandateData()
        AddStateCovidData()
    End Sub

    Private Sub AddStates()
        Dim csvArray As String() = File.ReadAllLines("\Datasources\States.csv") 'You will likely need to change this file path
        Dim dt As DataTable = CreateDataTableFromArray(csvArray)

        For Each dr As DataRow In dt.Rows
            Dim s As New State With {
                .StateName = dr("State"),
                .StateCode = dr("State Abbreviation"),
                .Population = dr("Population 2018"),
                .PopulationDensity = dr("Population density"),
                .SquareMiles = dr("Square Miles")
            }

            s.Save()
        Next
    End Sub

    Private Sub AddStateMandateData() 
        Dim stateMandate As New StateMandate
        Dim csvArray As String() = File.ReadAllLines("\Datasources\StateMandates.csv") 'You will likely need to change this file path
        Dim dt As DataTable = CreateDataTableFromArray(csvArray)
        Dim dtCodes As DataTable = stateMandate.GetMandateCodes()

        'FM_ALL,FM_ALL2,FM_EMP,FM_END --> These are all column values for mask mandates in the file we're parsing
        For Each dr As DataRow In dt.Rows
            'FM_ALL = General public mask mandate, FM_END = End to general public mask mandate
            If dr("FM_ALL") <> "0" Then
                Dim maskMandate = From m As DataRow In dtCodes.Rows
                                  Where m("Code") = "FM_ALL"
                                  Select m

                Dim maskMandateTypeID As Integer = maskMandate(0)("MandateTypeID")

                If dr("FM_END") <> "0" Then
                    Dim sm As New StateMandate With {
                        .StateCode = dr("POSTCODE"),
                        .MandateTypeID = maskMandateTypeID,
                        .StartDate = CDate(dr("FM_ALL")),
                        .EndDate = CDate(dr("FM_END"))
                    }

                    sm.Save()
                Else
                    Dim sm As New StateMandate With {
                        .StateCode = dr("POSTCODE"),
                        .MandateTypeID = maskMandateTypeID,
                        .StartDate = CDate(dr("FM_ALL")),
                        .EndDate = Date.MinValue
                    }

                    sm.Save()
                End If
            End If

            'FM_ALL2 = Second general public mask mandate - also signifies that a previous mask mandate was issued and ended
            If dr("FM_ALL2") <> "0" Then
                Dim maskMandate = From m As DataRow In dtCodes.Rows
                                  Where m("Code") = "FM_ALL2"
                                  Select m

                Dim maskMandateTypeID As Integer = maskMandate(0)("MandateTypeID")

                If dr("FM_END2") <> "0" Then
                    Dim sm As New StateMandate With {
                        .StateCode = dr("POSTCODE"),
                        .MandateTypeID = maskMandateTypeID,
                        .StartDate = CDate(dr("FM_ALL2")),
                        .EndDate = CDate(dr("FM_END2"))
                    }

                    sm.Save()
                Else
                    Dim sm As New StateMandate With {
                        .StateCode = dr("POSTCODE"),
                        .MandateTypeID = maskMandateTypeID,
                        .StartDate = CDate(dr("FM_ALL2")),
                        .EndDate = Date.MinValue
                    }

                    sm.Save()
                End If
            End If

            'FM_EMP = Separate from aforementioned mask mandates, this one only applies to public facing employees
            If dr("FM_EMP") <> "0" Then
                Dim maskMandate = From m As DataRow In dtCodes.Rows
                                  Where m("Code") = "FM_EMP"
                                  Select m

                Dim maskMandateTypeID As Integer = maskMandate(0)("MandateTypeID")

                Dim sm As New StateMandate With {
                    .StateCode = dr("POSTCODE"),
                    .MandateTypeID = maskMandateTypeID,
                    .StartDate = CDate(dr("FM_EMP")),
                    .EndDate = Date.MinValue
                }

                sm.Save()
            End If
        Next
    End Sub

    Private Sub AddStateCovidData()
        Dim state As New State
        Dim csvArray As String() = File.ReadAllLines("\Datasources\StateCovidCasesAndDeaths.csv") 'You will likely need to change this file path
        Dim listStates As List(Of State) = state.GetStates()
        Dim dtStateCases As DataTable = CreateDataTableFromArray(csvArray)

        For Each dr As DataRow In dtStateCases.Rows
            Dim isStateInDB = From s As State In listStates
                              Where s.StateCode = dr("State")
                              Select s

            If isStateInDB.Count > 0 Then
                Dim sc As New StateCovidData With {
                    .conf_cases = If(dr("conf_cases") = "", 0, dr("conf_cases")),
                    .conf_death = If(dr("conf_death") = "", 0, dr("conf_death")),
                    .created_at = dr("created_at"),
                    .new_case = If(dr("new_case") = "", 0, dr("new_case")),
                    .new_death = If(dr("new_death") = "", 0, dr("new_death")),
                    .pnew_case = If(dr("pnew_case") = "", 0, dr("pnew_case")),
                    .pnew_death = If(dr("pnew_death") = "", 0, dr("pnew_death")),
                    .prob_cases = If(dr("prob_cases") = "", 0, dr("prob_cases")),
                    .prob_death = If(dr("prob_death") = "", 0, dr("prob_death")),
                    .state = dr("state"),
                    .submission_date = dr("submission_date"),
                    .tot_cases = If(dr("tot_cases") = "", 0, dr("tot_cases")),
                    .tot_death = If(dr("tot_death") = "", 0, dr("tot_death"))
                }

                sc.Save()
            End If
        Next
    End Sub

    Private Function CreateDataTableFromArray(ByVal ar As String()) As DataTable
        Dim dt As New DataTable
        Dim columns As String() = ar(0).Split(",")

        For Each col As String In columns
            dt.Columns.Add(New DataColumn With {.ColumnName = col, .[ReadOnly] = False})
        Next

        Dim j As Integer = columns.Length
        Dim rowCount As Integer = 0
        For Each line In ar
            If rowCount > 0 Then
                Dim lineItems As String() = line.Split(",")
                Dim dr As DataRow = dt.NewRow
                For i As Integer = 0 To j - 1
                    dr(columns(i)) = lineItems(i)
                Next
                dt.Rows.Add(dr)
            End If

            rowCount += 1
        Next

        Return dt
    End Function
End Module
