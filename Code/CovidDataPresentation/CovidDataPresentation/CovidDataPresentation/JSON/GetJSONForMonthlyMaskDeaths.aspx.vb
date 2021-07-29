Imports Newtonsoft.Json
Imports System.Data
Imports System.Data.SqlClient
Public Class GetJSONForMonthlyMaskDeaths
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim dt As DataTable = GetMonthlyMaskEfficacyData()

        If dt IsNot Nothing AndAlso dt.Rows.Count > 0 Then
            Dim jsonString As String = GetJson(dt)

            HttpContext.Current.Response.AddHeader("Access-Control-Allow-Origin", "*")
            HttpContext.Current.Response.ContentType = "text/html"
            HttpContext.Current.Response.Write(jsonString)
            HttpContext.Current.Response.Flush()
            HttpContext.Current.Response.End()
        End If
    End Sub

    Public Shared Function GetJson(ByVal dt As DataTable) As String
        Dim JsonText As String
        JsonText = JsonConvert.SerializeObject(dt)
        Return JsonText
    End Function

    Private Function GetMonthlyMaskEfficacyData() As DataTable
        Dim dt As New DataTable
        Dim rd As SqlDataReader

        Dim sqlConn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("Covid").ToString)
        Dim Doc_cmd As SqlCommand = sqlConn.CreateCommand
        Doc_cmd.CommandType = CommandType.StoredProcedure

        Doc_cmd.CommandText = "prc_DeathNumbersWithAndWithoutMandate_PerCapitaByMonth_Improved"

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