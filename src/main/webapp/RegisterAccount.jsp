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
	<jsp:forward page="Login.jsp">
	<jsp:param name="registerRet" value="Account successfully created."/> 
	</jsp:forward>
	<% 
		} catch (SQLException e) {
			String code = e.getSQLState();
			if (code.equals("23000")) {
				%>
				<jsp:forward page="Register.jsp">
				<jsp:param name="msg" value="This username is already exists."/> 
				</jsp:forward>
				<%
			} else {
				%>
				<jsp:forward page="Register.jsp">
				<jsp:param name="msg" value="Error creating account. Please try again."/> 
				</jsp:forward>
				<%
			}
		} catch (Exception e) {
			out.print("Unknown exception.");
			%>
			<jsp:forward page="Register.jsp">
			<jsp:param name="msg" value="Error creating account. Please try again."/> 
			</jsp:forward>
			<%
		}
	%>
</body>
</html>