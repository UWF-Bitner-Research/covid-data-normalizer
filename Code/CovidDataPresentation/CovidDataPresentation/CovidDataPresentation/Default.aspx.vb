Imports System.Data
Imports System.Data.SqlClient
Public Class _Default
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        gvAverageCases.DataSource = GetAverageCasesData()
        gvAverageCases.DataBind()

        gvBeforeAfterMandates.DataSource = GetBeforeAfterMandatesData()
        gvBeforeAfterMandates.DataBind()
    End Sub

    Private Function GetBeforeAfterMandatesData() As DataTable
        Dim dt As New DataTable
        Dim rd As SqlDataReader

        Dim sqlConn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("Covid").ToString)
        Dim Doc_cmd As SqlCommand = sqlConn.CreateCommand
        Doc_cmd.CommandType = CommandType.StoredProcedure

        Doc_cmd.CommandText = "prc_CaseNumbersWithAndWithoutMandate_ThreeWeeks"

        Try
            sqlConn.Open()
            rd = Doc_cmd.ExecuteReader()
            dt.Load(rd)
        Catch ex As Exception
            'Add something here for exception handling
        Finally
            sqlConn.Close()
        End Try

        Return dt
    End Function

    Private Function GetAverageCasesData() As DataTable
        Dim dt As New DataTable
        Dim rd As SqlDataReader

        Dim sqlConn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("Covid").ToString)
        Dim Doc_cmd As SqlCommand = sqlConn.CreateCommand
        Doc_cmd.CommandType = CommandType.StoredProcedure

        Doc_cmd.CommandText = "prc_CaseNumbersWithAndWithoutMandate"

        Try
            sqlConn.Open()
            rd = Doc_cmd.ExecuteReader()
            dt.Load(rd)
        Catch ex As Exception
            'Add something here for exception handling
        Finally
            sqlConn.Close()
        End Try

        Return dt
    End Function
End Class