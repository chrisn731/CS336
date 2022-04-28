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
	<%
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		String resolve_text = request.getParameter("resolve_text");
		String q_id = request.getParameter("q_id");
		String rep_id = request.getParameter("rep_id");
		
		PreparedStatement ps = con.prepareStatement(
				"INSERT INTO resolves VALUES(?, ?, ?)"
		);
		ps.setString(1, q_id);
		ps.setString(2, rep_id);
		ps.setString(3, resolve_text);
		ps.executeUpdate();
		
	%>
		<jsp:forward page="ExamineQuestion.jsp">
		<jsp:param name="rep_id" value="<%= rep_id %>"/> 
		<jsp:param name="q_id" value="<%= q_id %>"/>
		</jsp:forward>
</body>
</html>