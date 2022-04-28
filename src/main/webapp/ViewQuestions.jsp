<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.dbapp.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<div style="text-align: center">
	<h1>Questions asked by you and other users!</h1>
	<%
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		ResultSet resultset = stmt.executeQuery("SELECT q_id, q_text FROM question");
	%>
	<form action="UserExamineQuestion.jsp">
		<table style="margin: 0px auto;" border=1>
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