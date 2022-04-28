<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.dbapp.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Ask a Question</title>
</head>
<body>

	<% 
    	//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		String username = request.getParameter("username");
			
    %>

    <div style="text-align: center">
    	<h1>Customer Rep. Help</h1>
    	<form method="post" action="VerifyQuestion.jsp?username=<%=username%>">
	    	<table align="center">
	    		<tr>  
					<td><p><label for="question">Please fill out the form below:</label></p>
  						<textarea id="question" name="question" rows="4" cols="50">Ask us anything!</textarea>
  					</td>
	   			</tr>
	   			<tr>
	   				<td><input type="submit" value="Post" style="width: 50%;"/></td>
	   			</tr>
	   			<tr>
	   				<td><a href="Account.jsp?username=<%=username%>">Back</a></td>
	   			</tr>					
	   			
	   			
	   			
	   			<% if (request.getParameter("msg") != null) { %>
				<tr>
					<td><p style="text-align: center; color: red"><%=request.getParameter("msg")%></p></td>
				</tr>
				<% } %>
	    	</table>
    	</form>
    </div>
    <script>
    	function func(){
    	    var idElement = document.getElementById("subcategory");
    	    var selectedValue = idElement.options[idElement.selectedIndex].text;   
    	    if(selectedValue=="Cars"){document.getElementById("Subattr").innerHTML = "Color: ";}
    	   	else if(selectedValue=="Figurines"){document.getElementById("Subattr").innerHTML = "Tag: ";}
    	   	else{document.getElementById("Subattr").innerHTML = "Pieces: ";}
    	}
    </script>
</body>
</html>