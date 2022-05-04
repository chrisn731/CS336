<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.dbapp.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<%
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		String user = request.getParameter("username");
		PreparedStatement ps = con.prepareStatement(
			"SELECT password FROM users WHERE username=(?)"
		);
		ps.setString(1, user);
		ResultSet rs = ps.executeQuery();
		rs.next();
	%>
	<p><a href="CustomerRepHome.jsp"><< Quit User Examination</a></p>
	<div style="text-align: center">
	<h1>Examining: <%= user %></h1>
	<form action="RepEditUser.jsp">
		<p>Current Username: <%= user %></p>
		<p>Current password: <%= rs.getString(1) %><p>
		<br>
		<p>New Username: <input type="text" name="new_user" value="" maxlength="30"></p>
		<br>
		<p>New Password: <input type="text" name="new_pass" value="" maxlength="30"></p>
		<br>
		<button type="submit">Confirm Edits</button>
		<hr>
		<button name="delete" type="submit" value="true">DELETE USER</button>
		<input type="hidden" name="old_user" value="<%= user %>"/>
	</form>
		
	</div>
</body>
</html>