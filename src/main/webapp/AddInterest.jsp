<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.dbapp.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Add Interest</title>
</head>
<body>
	<% 
    	//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		String username = (String) session.getAttribute("username");
		if (username == null) {
			response.sendRedirect("Login.jsp");
		}
		
		String interest = request.getParameter("interest");
		
	    PreparedStatement ps = con.prepareStatement("INSERT INTO interests(username, interest) VALUES(?, ?)");
	    ps.setString(1, username);
	    ps.setString(2, interest);
	    ps.executeUpdate();
	    response.sendRedirect("Interests.jsp");		
    %>
    
    
</body>
</html>