<!-- #include file="conn.asp" -->
<%
	If Request.Form.Count > 0 Then
		m = Request.Form("month")
		d = Request.Form("day")
		y = Request.Form("year")
		c = Request.Form("course")
		
		sql = "INSERT INTO event (date_time, course_id) VALUES ('" & m & "/" & d & "/" & y & "', " & c & ")"
		conn.Execute(sql)
		
		Response.Redirect "events.asp"
	End If
%>
<html>
<head>
	<title>Add Golf Event</title>
	<link rel="stylesheet" type="text/css" href="master.css" />
</head>

<body>

<!-- #include file="navigation.htm" -->
	
	<h2>Add Golf Event</h2>
	
	<form name="frm" action="<%= Request.ServerVariables("SCRIPT_NAME") %>" method="post">
		<p>
			<b>Date (mm/dd/yyyy): </b>
			<input type="text" name="month" size="5" /> / 
			<input type="text" name="day" size="5" /> / 
			<input type="text" name="year" size="10" />
		</p>
		
		<p>
			<b>Course: </b>
			<select name="course" size="1">
			<%
				sql = "SELECT course_id, name FROM course ORDER BY name"
				rs.Open sql
				If Not rs.EOF Then
					aCourses = rs.GetRows()
				End If
				rs.Close()
				
				If IsArray(aCourses) Then
					For i = LBound(aCourses, 2) To UBound(aCourses,2)
						Response.Write "<option value=""" & aCourses(0,i) & """>" & aCourses(1,i) & "</option>"
					Next
				End If
			%>
			</select>
		</p>
		
		<p>
			<input type="submit" name="submit" value="submit" />
		</p>
	</form>
	
</body>
</html>