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
<style>
table, th, td {
  	border: 1px solid;
  	border-collapse: collapse;
}
</style>
</head>
<body>
	<%
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		String rep_id = (String) session.getAttribute("employeeid");
		if (rep_id == null) {
			response.sendRedirect("Login.jsp");
		}
	%>
	<h1>Welcome back!</h1>
	<h2>Questions</h2>
		<%
			Statement stmt = con.createStatement();
			ResultSet resultset = stmt.executeQuery("SELECT q_id, q_text FROM question");
		%>
		<form action="ExamineQuestion.jsp">
		<table border=1>
		<tr>
			<th></th>
			<th>Question</th>
		</tr>
		<%
			if (!resultset.next()) {
		%>
		<tr>
			<td colspan="2">No one has asked a question yet!</td>
		</tr>
		<%
			} else {
				resultset.beforeFirst();
			 	while (resultset.next()) { 
		%>
			<tr>
				<td><button name="q_id" type="submit" value="<%= resultset.getString(1) %>">>></button></td>
				<td style="max-width: 300px;: 18px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;"><%= resultset.getString(2) %></td>
			</tr>
		<% 	
				} // end while
			} // end if
		%>
		</table>
		</form>
	<hr>
	<h2>Bids and Auctions</h2>
		<%
			resultset = stmt.executeQuery("SELECT l_id, itemname, subcategory, price FROM listings");
		%>
		<form action="RepEditListing.jsp">
		<table border=1>
		<tr>
			<th></th>
			<th>Item</th>
			<th>Subcategory</th>
			<th>Price</th>
		</tr>
		<%
			if (!resultset.next()) {
		%>
		<tr>
			<td colspan="4">No one has posted a listing yet!</td>
		</tr>
		<%
			} else {
				resultset.beforeFirst();
			 	while (resultset.next()) { 
		%>
			<tr>
				<td><button name="lid" type="submit" value="<%= resultset.getString(1) %>">>></button></td>
				<td style="max-width: 300px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;"><%= resultset.getString(2) %></td>
				<td style="max-width: 300px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;"><%= resultset.getString(3) %></td>
				<td style="max-width: 300px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;"><%= resultset.getString(4) %></td>
			</tr>
		<% 	
				} // end while
			} // end if
		%>
		</table>
		</form>
	<hr>
	<h2>User Account Access</h2>
		<%
			resultset = stmt.executeQuery("SELECT username FROM users");
		%>
		<form action="RepExamineUser.jsp">
		<table border=1>
		<tr>
			<th></th>
			<th>Username</th>
		</tr>
		<%
			if (!resultset.next()) {
		%>
		<tr>
			<td colspan="4">No one has registered yet!</td>
		</tr>
		<%
			} else {
				resultset.beforeFirst();
			 	while (resultset.next()) { 
		%>
			<tr>
				<td><button name="username" type="submit" value="<%= resultset.getString(1) %>">>></button></td>
				<td style="max-width: 300px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;"><%= resultset.getString(1) %></td>
			</tr>
		<% 	
				} // end while
			} // end if
		%>
		</table>
		</form>
	<hr>
	<a href="Logout.jsp">Logout</a>
</body>
</html>