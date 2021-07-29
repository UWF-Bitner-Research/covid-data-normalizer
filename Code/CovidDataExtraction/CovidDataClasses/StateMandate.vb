Imports System.Data.SqlClient
Imports System.Configuration
Public Class StateMandate
#Region "Properties"
    Public Property StateCode As String
    Public Property MandateTypeID As Integer
    Public Property StartDate As Date
    Public Property EndDate As Date
#End Region
#Region "Database Actions"
    Public Function Save() As String
        Dim returnMessage As String
        Dim sqlConn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("Covid").ToString)
        Dim Doc_cmd As SqlCommand = sqlConn.CreateCommand
        Doc_cmd.CommandType = CommandType.StoredProcedure

        Doc_cmd.CommandText = "prc_StateMandate_Insert"
        Doc_cmd.Parameters.Add(New SqlParameter("@StateCode", Me.StateCode))
        Doc_cmd.Parameters.Add(New SqlParameter("@MandateTypeID", Me.MandateTypeID))
        Doc_cmd.Parameters.Add(New SqlParameter("@StartDate", Me.StartDate))
        If Me.EndDate > Date.MinValue Then
            Doc_cmd.Parameters.Add(New SqlParameter("@EndDate", EndDate))
        End If

        Try
            sqlConn.Open()
            Doc_cmd.ExecuteNonQuery()
            returnMessage = "State mandate successfully inserted"
        Catch ex As Exception
            returnMessage = $"State mandate insert failed. Reason: {ex.Message}"
        Finally
            sqlConn.Close()
        End Try

        Return returnMessage
    End Function

    Public Function GetMandateCodes() As DataTable
        Dim dt As New DataTable
        Dim rd As SqlDataReader

        Dim sqlConn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("Covid").ToString)
        Dim Doc_cmd As SqlCommand = sqlConn.CreateCommand
        Doc_cmd.CommandType = CommandType.StoredProcedure

        Doc_cmd.CommandText = "prc_MandateCode_Select"

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
#End Region
End Class
