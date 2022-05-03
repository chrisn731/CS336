<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.dbapp.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Home</title>
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
			
    %>

    <div style="text-align: center">
        <h1>Welcome to BuyMe: Toys</h1>
       
       <table style="margin: 0px auto;">
		<tr>
			<td><a href="Figurines.jsp">Figurines</a></td>
			<td>|</td>
			<td><a href="Cars.jsp">Cars</a></td>
			<td>|</td>
			<td><a href="Construction.jsp">Construction</a></td>
		</tr>
		</table>
       
        <br><br>
        <table align="center">
    		<tr>
    			<td><a href="ViewQuestions.jsp">Q&A</a>
    			<td>|</td>
				<td><a href="Account.jsp">Account</a></td>
				<td>|</td>
				<td><a href="Logout.jsp">Logout</a></td>
   			</tr>
    	</table>
    </div>
</body>
</html>