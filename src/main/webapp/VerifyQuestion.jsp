<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.dbapp.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Verify Listing</title>
</head>
<body>
	<%
		try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			Statement stmt = con.createStatement();
			
			String username = request.getParameter("username"); //asker
			String question = request.getParameter("question"); //their question
			
			//Statement 1: Insert into questions table
			String insert = "INSERT INTO questions(question) " 
					+ "VALUES(?)";
			
			PreparedStatement ps = con.prepareStatement(insert);
			ps.setString(1, question);
			ps.executeUpdate();
			
			//Statement 2: Insert into asks table
			insert = "INSERT INTO asks(asker, q_id) " 
					+ "VALUES(?, (SELECT MAX(q_id) FROM questions))";
			
			ps = con.prepareStatement(insert);
			ps.setString(1, username);
			ps.executeUpdate();
			
			%>
			<jsp:forward page="Account.jsp?username=<%=username%>">
			<jsp:param name="askQuestionRet" value="Question posted!"/> 
			</jsp:forward>
			<% 
		} catch (SQLException e) {
			String code = e.getSQLState();
			if (code.equals("23000")) {
				%>
				<jsp:forward page="AskQuestion.jsp">
				<jsp:param name="msg" value="ERROR"/> 
				</jsp:forward>
				<%
			} else {
				%>
				<jsp:forward page="AskQuestion.jsp">
				<jsp:param name="msg" value="ERROR"/> 
				</jsp:forward>
				<%
			}
		} catch (Exception e) {
			out.print("Unknown exception.");
			%>
			<jsp:forward page="AskQuestion.jsp">
			<jsp:param name="msg" value="ERROR"/> 
			</jsp:forward>
			<%
		}
	%>
</body>
</html>
