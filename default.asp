<!-- #include file="conn.asp" -->
<!-- #include file="handicap.asp" -->
<html>
<head>
	<title>ERS Golf Scores</title>
	<link rel="stylesheet" type="text/css" href="master.css" />
</head>

<body>

<!-- #include file="navigation.htm" -->

<table border="1" cellspacing="0" cellpadding="3" width="100%">
<thead>
<tr>
	<td>Golfer/Date</td>
	<%
		sql = "SELECT e.event_id, e.date_time, c.front_nine_par, c.back_nine_par FROM event e INNER JOIN course c ON c.course_id = e.course_id ORDER BY e.date_time ASC"
		rs.Open sql
		If Not rs.EOF Then
			aEvents = rs.GetRows()
		End If
		rs.Close()
		
		If IsArray(aEvents) Then
			For i = LBound(aEvents,2) To UBound(aEvents,2)
				Response.Write "<td>"
				Response.Write FormatDateTime(aEvents(1,i), vbShortDate) & "<br />"
				Response.Write "Par: " & aEvents(2,i) & "-" & aEvents(3,i)
				Response.Write "</td>"
			Next
		End If
	%>
	<td>ESTIMATED<br />9-hole Handicap</td>
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
			If IsArray(aEvents) Then
				For j = LBound(aEvents,2) To UBound(aEvents,2)
					Response.Write "<td>" & GetScore(aGolfers(0,i), aEvents(0,j)) & "</td>"
				Next
			End If
			Response.Write "<td>" & GetHandicap(aGolfers(0,i)) & "</td>"
			Response.Write "</tr>"
		Next
	End If
%>
</tbody>
</table>


</body>
</html>