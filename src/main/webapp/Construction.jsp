<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.dbapp.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Construction Toys</title>
</head>
<body>
    <div style="text-align: center">
    	<h1>Subcategory: Construction</h1>
    	<table align="center">
    		<tr>  
    			<td><a href="home.jsp">Home</a></td>
        		<td>|</td>
				<td><a href="Account.jsp">Account</a></td>
				<td>|</td>
				<td><a href="Logout.jsp">Logout</a></td>
   			</tr>
    	</table>
    	    	
    	 <% 
    		//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();

			Statement stmt = con.createStatement();
            ResultSet resultset = stmt.executeQuery("SELECT * from listings WHERE subcategory='Construction';") ; 
        %>
    	<br><br>
    	<TABLE align="center" BORDER="1">
            <TR>
            	<TH>Listing ID</TH>
                <TH>Name</TH>
                <TH>Pieces</TH>
                <TH>Price</TH>
            </TR>
            <% while(resultset.next()){ %>
            <TR>
				<TD> <%= resultset.getString(1) %></TD>
                <TD> <%= resultset.getString(2) %></TD>
                <TD> <%= resultset.getString(4) %></TD>
                <TD> <%= resultset.getString(5) %></TD>
            </TR>
            <% } %>
        </TABLE>
    </div>
</body>
</html>