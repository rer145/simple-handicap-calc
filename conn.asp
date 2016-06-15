<%
	Dim conn : Set conn = Server.CreateObject("ADODB.Connection")
	conn.Open("provider=sqloledb;server=elvertbarnes;uid=sa;pwd=1ers1;database=Golf")
	
	Dim rs : Set rs = Server.CreateObject("ADODB.Recordset")
	rs.ActiveConnection = conn
%>