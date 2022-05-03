<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.dbapp.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Customer Represenative Home</title>
</head>
<body>
	<%
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
	%>
	<h1>Welcome back!</h1>
	<h2>Questions</h2>
		<%
			String rep_id = (String) session.getAttribute("employeeid");
			if (rep_id == null) {
				response.sendRedirect("Login.jsp");
			}
			Statement stmt = con.createStatement();
			ResultSet resultset = stmt.executeQuery("SELECT q_id, q_text FROM question");
		%>
		<form action="ExamineQuestion.jsp">
		<table border=1>
		<tr>
			<th></th>
			<th>Question</th>
		</tr>
		 <% while (resultset.next()) { %>
			<tr>
				<td><button name="q_id" type="submit" value="<%= resultset.getString(1) %>">>></button></td>
				<td><%= resultset.getString(2) %></td>
			</tr>
		<% } %>
		</table>
		</form>
	<hr>
	<h2>Bids and Auctions</h2>
	
	<hr>
	<h2>User Account Access</h2>
	<hr>
	<a href="Logout.jsp">Logout</a>
</body>
</html>