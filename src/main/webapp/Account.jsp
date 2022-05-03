<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.dbapp.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Your Account</title>
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
    	<h1>Account Options</h1>
    	<h3>Active User: <%=username%></h3>
    	<table align="center">
    		<tr>  
    			<td><a href="home.jsp">Home</a></td>
        		<td>|</td>
				<td><a href="Logout.jsp">Logout</a></td>
   			</tr>
   			<tr>
   				<td><td><br><a href="CreateListing.jsp">Create Listing</a></td>
   			</tr>
   			<tr>
   				<td><td><br><a href="AskQuestion.jsp">Ask a Question</a></td>
   			</tr>    			
   			<tr>
   				<td><td><br><a href="Logout.jsp">Delete Account</a></td>
   			</tr>   			
    	</table>
    	
    	<table align="center">
    		<% if (request.getParameter("msg") != null) { %>
			<tr>
				<td><p style="text-align: center; color: red"><%=request.getParameter("msg")%></p></td>
			</tr>
			<% } %>
			
					
			<% if (request.getParameter("createListingRet") != null) { %>
			<tr>
				<td><p style="text-align: center; color: blue"><%=request.getParameter("createListingRet")%></p></td>
			</tr>
			<% } %>
			
			<% if (request.getParameter("askQuestionRet") != null) { %>
			<tr>
				<td><p style="text-align: center; color: blue"><%=request.getParameter("askQuestionRet")%></p></td>
			</tr>
			<% } %>
    	</table>
    	
    </div>
</body>
</html>