<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.dbapp.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Create Listing</title>
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
    	<h1>Create A Listing</h1>
    	<form method="post" action="VerifyListing.jsp">
	    	<table align="center">
	    		<tr>  
					<td>Item Name: <input type="text" name="itemname" value="" maxlength="30" required/></td>
	   			</tr>
	   			<tr>  
	  				<label for="subcategory">Subcategory:</label>
	  				<select name="subcategory" id="subcategory" onchange="func()">
	    				<option value="NONE">-SELECT AN OPTION-</option>
	    				<option value="Figurines">Figurines</option>
	    				<option value="Cars">Cars</option>
	    				<option value="Construction">Construction</option>
	  				</select>					
	   			</tr>
	   			<tr>  
					<td><label for="subattribute" id="Subattr">Subattribute:</label><input type="text" name="subattribute" value="" maxlength="30" required/></td>
	   			</tr>
	   			<tr>  
					<td>Starting Price: <input type="number" required name="price" min="0" value="0" step=".01"></td>
	   			</tr>
	   			<tr>  
					<td>Min. Sale Price (Hidden): <input type="number" required name="minsale" min="0.01" value="0" step=".01"></td>
	   			</tr>
	   			<tr>  
					<td>Closing Date/Time: <input type="datetime-local" required name="dt"></td>
	   			</tr>
	   			<tr>
					<td><input type="submit" value="Create" style="width: 100%;"/></td>
				</tr>
	   			<tr>
	   				<td><a href="Account.jsp">Back</a></td>
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