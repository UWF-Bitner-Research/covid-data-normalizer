Imports System.Data.SqlClient
Imports System.Configuration
Public Class StateCovidData
#Region "Properties"
    Public Property submission_date As Date 'Date of counts
    Public Property state As String 'State where case data originated
    Public Property tot_cases As Integer 'Total number Of cases
    Public Property conf_cases As Integer 'Total confirmed cases
    Public Property prob_cases As Integer 'Total probable cases
    Public Property new_case As Integer 'Number of New cases
    Public Property pnew_case As Integer 'Number of New probable cases
    Public Property tot_death As Integer 'Total number Of deaths
    Public Property conf_death As Integer 'Total number Of confirmed deaths
    Public Property prob_death As Integer 'Total number Of probable deaths
    Public Property new_death As Integer 'Number of New deaths
    Public Property pnew_death As Integer 'Number of New probable deaths
    Public Property created_at As Date 'Date And time record was created
#End Region
#Region "Database Actions"
    Public Function Save() As String
        Dim returnMessage As String
        Dim sqlConn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("Covid").ToString)
        Dim Doc_cmd As SqlCommand = sqlConn.CreateCommand
        Doc_cmd.CommandType = CommandType.StoredProcedure

        Doc_cmd.CommandText = "prc_StateCaseData_Insert"

        Doc_cmd.Parameters.Add(New SqlParameter("@StateCode", Me.state))
        Doc_cmd.Parameters.Add(New SqlParameter("@SubmissionDate", Me.submission_date))
        Doc_cmd.Parameters.Add(New SqlParameter("@TotalCases", Me.tot_cases))
        Doc_cmd.Parameters.Add(New SqlParameter("@ConfirmedCases", Me.conf_cases))
        Doc_cmd.Parameters.Add(New SqlParameter("@ProbableCases", Me.prob_cases))
        Doc_cmd.Parameters.Add(New SqlParameter("@NewCases", Me.new_case))
        Doc_cmd.Parameters.Add(New SqlParameter("@ProbableNewCases", Me.pnew_case))
        Doc_cmd.Parameters.Add(New SqlParameter("@TotalDeaths", Me.tot_death))
        Doc_cmd.Parameters.Add(New SqlParameter("@ConfirmedDeaths", Me.conf_death))
        Doc_cmd.Parameters.Add(New SqlParameter("@ProbableDeaths", Me.prob_death))
        Doc_cmd.Parameters.Add(New SqlParameter("@NewDeaths", Me.new_death))
        Doc_cmd.Parameters.Add(New SqlParameter("@ProbableNewDeaths", Me.pnew_death))
        Doc_cmd.Parameters.Add(New SqlParameter("@Created", Me.created_at))

        Try
            sqlConn.Open()
            Doc_cmd.ExecuteNonQuery()
            returnMessage = "State case data record successfully inserted"
        Catch ex As Exception
            returnMessage = $"State case data record insert failed. Reason: {ex.Message}"
        Finally
            sqlConn.Close()
        End Try

        Return returnMessage
    End Function
#End Region
End Class
