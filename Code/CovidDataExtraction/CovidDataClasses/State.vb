Option Infer On
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Linq

Public Class State
#Region "Properties"
    Public Property StateCode As String
    Public Property StateName As String
    Public Property PopulationDensity As Double
    Public Property Population As Integer
    Public Property SquareMiles As Double
#End Region
#Region "Database Actions"
    Public Function Save() As String
        Dim returnMessage As String
        Dim sqlConn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("Covid").ToString)
        Dim Doc_cmd As SqlCommand = sqlConn.CreateCommand
        Doc_cmd.CommandType = CommandType.StoredProcedure

        Doc_cmd.CommandText = "prc_States_Insert"

        Doc_cmd.Parameters.Add(New SqlParameter("@StateCode", Me.StateCode))
        Doc_cmd.Parameters.Add(New SqlParameter("@StateName", Me.StateName))
        Doc_cmd.Parameters.Add(New SqlParameter("@PopulationDensity", Me.PopulationDensity))
        Doc_cmd.Parameters.Add(New SqlParameter("@Population2018", Me.Population))
        Doc_cmd.Parameters.Add(New SqlParameter("@AreaSquareMiles", Me.SquareMiles))

        Try
            sqlConn.Open()
            Doc_cmd.ExecuteNonQuery()
            returnMessage = "State successfully inserted"
        Catch ex As Exception
            returnMessage = $"State insert failed. Reason: {ex.Message}"
        Finally
            sqlConn.Close()
        End Try

        Return returnMessage
    End Function
    Public Function GetStates() As List(Of State)
        Dim dt As New DataTable
        Dim rd As SqlDataReader

        Dim sqlConn As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("Covid").ToString)
        Dim Doc_cmd As SqlCommand = sqlConn.CreateCommand
        Doc_cmd.CommandType = CommandType.StoredProcedure

        Doc_cmd.CommandText = "prc_States_Select"

        Try
            sqlConn.Open()
            rd = Doc_cmd.ExecuteReader()
            dt.Load(rd)
        Catch ex As Exception
            'Add something here for exception handling
        Finally
            sqlConn.Close()
        End Try

        Dim states = From c In dt.AsEnumerable().Select(Function(f) New State With {
            .StateCode = f.Field(Of String)("StateCode"),
            .StateName = f.Field(Of String)("StateName"),
            .PopulationDensity = f.Field(Of Double)("PopulationDensity"),
            .Population = f.Field(Of Integer)("Population2018"),
            .SquareMiles = f.Field(Of Double)("AreaSquareMiles")
        })

        Return states.ToList()
    End Function
#End Region
End Class