<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.dbapp.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Admin Homepage</title>
</head>
<body>
	<%
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		String admin_id = (String) session.getAttribute("employeeid");
		if (admin_id == null) {
			response.sendRedirect("Login.jsp");
		}
		ResultSet resultset = stmt.executeQuery("SELECT id, password FROM customer_rep");
	%>
	<h1>Welcome back, Admin.</h1>
	<h2>Your Customer Represenatives</h2>
	<table>
		<tr>
			<th>Customer_Rep ID</th>
			<th>Password</th>
		</tr>
		<%
			if (!resultset.next()) {
		%>
		<tr>
			<td> No Customer Reps found! </td>
		</tr>
		<%
			} else {
				// Need to reset after the previous if check
				resultset.beforeFirst();
				while (resultset.next()) { %>
		<tr>
			<td> <%= resultset.getString(1) %></td>
			<td> <%= resultset.getString(2) %></td>
		</tr>
			<% } }%>
	</table>
	<h3>Add a Customer Rep to the Team!</h3>
	<form method="post" action="CreateRep.jsp">
		<table>
			<tr>
				<td>New Rep ID: <input type="text" name="id" value="" maxlength="3" required/></td>
			</tr>
			<tr>
				<td>Rep Password: <input type="text" name="password" value="" maxlength="30" required/></td>
			</tr>
			<tr>
				<td><input type="submit" value="Create!" style="width: 100%;"/></td>
			</tr>
			<% if (request.getParameter("CreateRet") != null) { %>
			<tr>
				<td><p style="text-align: center; 
					color: <%= request.getParameter("CreateRetCode").equals("0") ? "blue" : "red" %>">
						<%=request.getParameter("CreateRet")%>
					</p>
				</td>
			</tr>
			<% } %>
		</table>
	</form>
	<p>
	<a href="Logout.jsp">Logout</a>
</body>
</html>