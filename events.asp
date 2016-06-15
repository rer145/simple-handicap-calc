<!-- #include file="conn.asp" -->
<html>
<head>
	<title>Golf Events</title>
	<link rel="stylesheet" type="text/css" href="master.css" />
</head>

<body>

<!-- #include file="navigation.htm" -->

	<h2>Golf Events</h2>
	
	<table border="1" cellspacing="0" cellpadding="3" width="100%">
	<thead>
	<tr>
		<td>Date</td>
		<td>Course</td>
		<td>Scores</td>
		<td>Edit</td>
	</tr>
	</thead>
	<tbody>
	<%
		sql = "SELECT e.event_id, e.date_time, c.name FROM event e INNER JOIN course c ON c.course_id = e.course_id ORDER BY e.date_time ASC"
		rs.Open sql
		If Not rs.EOF Then
			aEvents = rs.GetRows()
		End If
		rs.Close()
		
		If IsArray(aEvents) Then
			For i = LBound(aEvents,2) To UBound(aEvents,2)
				Response.Write "<tr>"
				Response.Write "<td>" & aEvents(1,i) & "</td>"
				Response.Write "<td>" & aEvents(2,i) & "</td>"
				Response.Write "<td><a href=""event_scores.asp?id=" & aEvents(0,i) & """>view</a></td>"
				Response.Write "<td><a href=""edit_scores.asp?id=" & aEvents(0,i) & """>edit</a></td>"
				Response.Write "</tr>"
			Next
		End If
	%>
	</tbody>
	</table>

</body>
</html>