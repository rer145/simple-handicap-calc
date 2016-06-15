<!-- #include file="conn.asp" -->
<%
	id = Request("id")
	
	sql = "SELECT e.date_time, c.name, c.front_nine_par, c.back_nine_par FROM event e INNER JOIN course c ON c.course_id = e.course_id WHERE e.event_id = " & id
	rs.Open sql
	If Not rs.EOF Then
		edate = rs.Fields(0).Value
		course = rs.Fields(1).Value
		frontpar = rs.Fields(2).Value
		backpar = rs.Fields(3).Value
	End If
	rs.Close()
%>
<html>
<head>
	<title>Event Scores</title>
	<link rel="stylesheet" type="text/css" href="master.css" />
</head>

<body>

<!-- #include file="navigation.htm" -->
	
	<h2>Scores for <%= FormatDateTime(edate, vbShortDate) %></h2>
	<h3>Course: <%= course %></h3>
	<h4>Front Par : <%= frontpar %></h4>
	<h4>Back Par : <%= backpar %></h4>
	
	<table border="1" cellspacing="0" cellpadding="3" width="100%">
	<thead>
	<tr>
		<td>Golfer</td>
		<td>Front 9</td>
		<td>Back 9</td>
		<td>+/-</td>
	</tr>
	</thead>
	<tbody>
	<%
		sql = "SELECT g.name, ISNULL(s.front_nine, 0), ISNULL(s.back_nine, 0) FROM golfer g INNER JOIN score s ON s.golfer_id = g.golfer_id WHERE s.event_id = " & id & " ORDER BY ISNULL(s.front_nine, 0)ASC , ISNULL(s.back_nine, 0) ASC"
		rs.Open sql
		If Not rs.EOF Then
			aScores = rs.GetRows()
		End If
		rs.Close()
		
		If IsArray(aScores) Then
			For i = LBound(aScores,2) To UBound(aScores,2)
				Response.Write "<tr>"
				Response.Write "<td>" & aScores(0,i) & "</td>"
				Response.Write "<td>" & aScores(1,i) & "</td>"
				Response.Write "<td>" & aScores(2,i) & "</td>"
				Response.Write "<td>"
				temp = 0
				If aScores(1,i) > 0 Then
					temp = aScores(1,i) - frontpar
				End If
				If aScores(2,i) > 0 Then
					temp = temp + (aScores(2,i) - backpar)
				End If
				Response.Write temp
				Response.Write "</td>"
				Response.Write "</tr>"
			Next
		End If
	%>
	</tbody>
	</table>
	
	
</body>
</html>