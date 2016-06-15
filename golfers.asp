<!-- #include file="conn.asp" -->
<!-- #include file="handicap.asp" -->
<html>
<head>
	<title>Golfers</title>
	<link rel="stylesheet" type="text/css" href="master.css" />
</head>

<body>

<!-- #include file="navigation.htm" -->

	<h2>Golfers</h2>
	
	<table border="1" cellspacing="0" cellpadding="3" width="100%">
	<thead>
	<tr>
		<td>Name</td>
		<td>Rounds Played</td>
		<td>Average Round</td>
		<td>ESTIMATED<br />9 hole handicap</td>
	</tr>
	</thead>
	<tbody>
	<%
		sql = "SELECT g.golfer_id, g.name FROM golfer g ORDER BY g.name ASC"
		rs.Open sql
		If Not rs.EOF Then
			aGolfers = rs.GetRows()
		End If
		rs.Close()
		
		If IsArray(aGolfers) Then
			For i = LBound(aGolfers,2) To UBound(aGolfers,2)
				Response.Write "<tr>"
				Response.Write "<td>" & aGolfers(1,i) & "</td>"
				Response.Write "<td>" & GetRoundsPlayed(aGolfers(0,i)) & "</td>"
				Response.Write "<td>" & GetAverageRound(aGolfers(0,i)) & "</td>"
				Response.Write "<td>" & GetHandicap(aGolfers(0,i)) & "</td>"
				Response.Write "</tr>"
			Next
		End If
	%>
	</tbody>
	</table>

</body>
</html>