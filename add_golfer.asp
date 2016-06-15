<!-- #include file="conn.asp" -->
<%
	If Request.Form.Count > 0 Then
		n = Request.Form("name")
		n = Replace(n, "'", "''")
		
		sql = "INSERT INTO golfer (name) VALUES ('" & n & "')"
		conn.Execute(sql)
		
		Response.Redirect "golfers.asp"
	End If
%>
<html>
<head>
	<title>Add Golfer</title>
	<link rel="stylesheet" type="text/css" href="master.css" />
</head>

<body>

<!-- #include file="navigation.htm" -->
	
	<h2>Add Golfer</h2>
	
	<form name="frm" action="<%= Request.ServerVariables("SCRIPT_NAME") %>" method="post">
		<p>
			<b>Name: </b>
			<input type="text" name="name" size="20" />
		</p>
		
		<p>
			<input type="submit" name="submit" value="submit" />
		</p>
	</form>
	
</body>
</html>