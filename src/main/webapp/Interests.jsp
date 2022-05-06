<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.dbapp.*" %>
<!DOCTYPE html>
<html>
<head>
	<style>
	.center {
	    margin-left: auto;
	    margin-right: auto;
	}
	
	table, th, td {
	      border: 1px solid;
	      border-collapse: collapse;
	      padding: 0px;
	}
	
	</style>
	<meta charset="utf-8">
	<title>Your Interests</title>
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
		PreparedStatement ps = con.prepareStatement(
				"SELECT interest " +
				"FROM interests " +
				"WHERE username=(?)");
		ps.setString(1, username);
		ResultSet rs = ps.executeQuery();
			
    %>
    <div style="text-align: center">
    	<h1>Your Interests</h1>
    	<a href= "Account.jsp">Back</a>
    	<hr>
    	<form method="post" action="AddInterest.jsp">
    		<input type="text" name="interest">
    		<input type="submit" value="Add Interest">
    	</form>
    	<br>
    	<table class="center">
    		<tr>
	    		<th>
	    			Your Interests
	    		</th>
    		</tr>
    		<% while (rs.next()) { %>
    			<tr> 
    				<td><%=rs.getString(1)%></td>
    			</tr>
    		<% } %>
    	</table>
    </div>
</body>
</html>