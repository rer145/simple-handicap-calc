<!-- #include file="conn.asp" -->
<%
	id = Request("id")
	
	If Request.Form.Count > 0 Then
		aGolfers = Split(Request.Form("golfers"), ",")
		
		sql = "DELETE FROM score WHERE event_id = " & id
		conn.Execute(sql)
		
		For i = LBound(aGolfers) To UBound(aGolfers)
			front = CInt(Request.Form("front_" & aGolfers(i)))
			back = CInt(Request.Form("back_" & aGolfers(i)))
			
			If front > 0 Or back > 0 Then
				sql = "INSERT INTO score (event_id, golfer_id, front_nine, back_nine) VALUES (" & id & ", " & aGolfers(i) & ", " & front & ", " & back & ")"
				conn.Execute(sql)
			End If
		Next
		
		Response.Redirect "events.asp"
	End If
	
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
	<title>Edit Scores</title>
	<link rel="stylesheet" type="text/css" href="master.css" />
</head>

<body>

<!-- #include file="navigation.htm" -->

	<h2>Edit Scores for <%= FormatDateTime(edate, vbShortDate) %></h2>
	<h3>Course: <%= course %></h3>
	<h4>Front Par : <%= frontpar %></h4>
	<h4>Back Par : <%= backpar %></h4>
	
	<form name="frm" action="<%= Request.ServerVariables("SCRIPT_NAME") %>" method="post">
		
	<table border="1" cellspacing="0" cellpadding="3" width="100%">
	<thead>
	<tr>
		<td>Golfer</td>
		<td>Front 9</td>
		<td>Back 9</td>
	</tr>
	</thead>
	<tbody>
	<%
		sql = "SELECT g.golfer_id, g.name, ISNULL(s.front_nine,0), ISNULL(s.back_nine,0) FROM golfer g LEFT OUTER JOIN (SELECT golfer_id, front_nine, back_nine FROM score s WHERE s.event_id = " & id & ") s ON s.golfer_id = g.golfer_id ORDER BY g.name ASC"
		rs.Open sql
		If Not rs.EOF Then
			aScores = rs.GetRows()
		End If
		rs.Close()
		
		golfers = ""
		If IsArray(aScores) Then
			For i = LBound(aScores,2) To Ubound(aScores,2)
				golfers = golfers & "," & aScores(0,i)
				
				Response.Write "<tr>"
				Response.Write "<td>" & aScores(1,i) & "</td>"
				Response.Write "<td><input size=""5"" type=""text"" name=""front_" & aScores(0,i) & """ value=""" & aScores(2,i) & """ /></td>"
				Response.Write "<td><input size=""5"" type=""text"" name=""back_" & aScores(0,i) & """ value=""" & aScores(3,i) & """ /></td>"
				Response.Write "</tr>"
			Next
		End If
		
		golfers = Right(golfers,Len(golfers)-1)
	%>
	</tbody>
	</table>
	
	<p>
		<input type="hidden" name="id" value="<%= id %>" />
		<input type="hidden" name="golfers" value="<%= golfers %>" />
		<input type="submit" name="submit" value="submit" />
	</p>
		
	</form>

</body>
</html>