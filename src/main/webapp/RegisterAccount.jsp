<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.dbapp.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Account Registration</title>
</head>
<body>
		<%
		try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			
			Statement stmt = con.createStatement();
			String username = request.getParameter("username");
			String password = request.getParameter("password");
			String insert = "INSERT INTO users(username, password) " 
							+ "VALUES(?, ?)";
			PreparedStatement ps = con.prepareStatement(insert);
			ps.setString(1, username);
			ps.setString(2, password);
			ps.executeUpdate();

	%>
	<p>
		Account successfully registered. Return to home and sign in.
	</p>
		<% 
		} catch (SQLException e) {
			String code = e.getSQLState();
			if (code.equals("23000"))
				out.print("Error: User already exists!");
			else
				out.print("SQL Error code: " + code);
		} catch (Exception e) {
			out.print("Unknown exception.");
		}
		%>
</body>
</html>