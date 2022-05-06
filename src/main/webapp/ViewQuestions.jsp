<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.dbapp.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Questions and Answers!</title>
<style>
.center {
	margin-left: auto;
	margin-right: auto;
}

table, th, td {
  	border: 1px solid;
  	border-collapse: collapse;
  	padding: 8px;
}
</style>
</head>
<body>
	<a href="home.jsp"><= Back to Home</a>
	<div style="text-align: center">
	<h1>Questions asked by you and other users!</h1>
	<%
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		
	%>
	<form method="post" action="ViewQuestions.jsp">
    	<input type="text" name="search" class="form-control" placeholder="Search by keyword">
    	<button type="submit" name="save" class="btn btn-primary">Search</button>
  	</form>
  	
  	<%
  		String keyword = request.getParameter("search");
  		ResultSet resultset;
  		
  		if (keyword == null || keyword.isBlank()) {
  			resultset = stmt.executeQuery("SELECT q_id, q_text FROM question");
  		} else {
  			PreparedStatement ps = con.prepareStatement(
  				"SELECT q_id, q_text FROM question WHERE q_text LIKE '%" + keyword + "%'"
  			);
  			resultset = ps.executeQuery();
  		}
  	%>
  	<hr>
  	<%
  		if (keyword != null && !keyword.isBlank()) {
  	%>
  	<h3>Showing results for: <%= keyword %></h3>
  	<%
  		}
  	%>
	<form action="UserExamineQuestion.jsp">
		<table class="center">
		<tr>
			<th></th>
			<th>Question</th>
		</tr>
		 <% while (resultset.next()) { %>
			<tr>
				<td><button name="q_id" type="submit" value="<%= resultset.getString(1) %>">>></button></td>
				<td style="max-width: 300px;: 18px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;"><%= resultset.getString(2) %></td>
			</tr>
		<% } %>
		</table>
		</form>
	</div>
</body>
</html>