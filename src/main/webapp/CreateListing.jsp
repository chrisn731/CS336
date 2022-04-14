<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Create Listing</title>
</head>
<body>
    <div style="text-align: center">
    	<h1>Create A Listing</h1>
    	<form method="post" action="VerifyListing.jsp">
	    	<table align="center">
	    		<tr>  
					<td>Item Name: <input type="text" name="itemname" value="" maxlength="30" required/></td>
	   			</tr>
	   			<tr>  
	  				<label for="cars">Subcategory:</label>
	  				<select id="cars" name="subcategory">
	    				<option value="Figurines">Figurines</option>
	    				<option value="Cars">Cars</option>
	    				<option value="Construction">Construction</option>
	  				</select>					
	   			</tr>
	   			<tr>  
					<td>Subattribute: <input type="text" name="subattribute" value="" maxlength="30" required/></td>
	   			</tr>
	   			<tr>  
					<td>Starting Price: <input type="number" required name="price" min="0" value="0" step=".01"></td>
	   			</tr>
	   			<tr>  
					<td>Min. Bid Increment: <input type="number" required name="minincrement" min="0" value="0" step=".01"></td>
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
</body>
</html>