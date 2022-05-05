<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.dbapp.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Search Results</title>
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
		String subcat = request.getParameter("subcat");
		String searchVal = request.getParameter("search");
	%>

    <div style="text-align: center">
    	<h1>Search Results: <%=subcat%></h1>
    	<table align="center">
    		<tr>  
    			<td><a href="home.jsp">Home</a></td>
        		<td>|</td>
				<td><a href="Account.jsp">Account</a></td>
				<td>|</td>
				<td><a href="Logout.jsp">Logout</a></td>
   			</tr>
    	</table>
	    
<div class="container">
  	<br>
  
	<form class="form-inline" method="post" action="search.jsp?subcat=<%=subcat%>&search=<%=searchVal%>">
		<select name="sortby" id="sortby">
			<option value="None">---</option>
	    	<option value="Name">Name</option>
	    	<option value="lowToHigh">Price (Ascending)</option>
	    	<option value="highToLow">Price (Descending)</option>
	    	<option value="Tag">Tag</option>
	    	<option value="Open">Status: Open</option>
	    	<option value="Closed">Status: Closed</option>
		</select>	
    <button type="submit" name="sortBy" >Sort By</button>
  </form>
</div>
    	
    	 <% 
			Statement stmt = con.createStatement();
    	 	String sortParam = request.getParameter("sortby");
    	 	ResultSet resultset = null;
    	 	if(sortParam == null){
    	 		resultset = stmt.executeQuery("SELECT * from listings WHERE subcategory='"+subcat+"' AND itemname LIKE '%"+searchVal+"%';");
    	 	}else if(sortParam.equals("Name")){
    	 		resultset = stmt.executeQuery("SELECT * from listings WHERE subcategory='"+subcat+"' AND itemname LIKE '%"+searchVal+"%' ORDER BY itemname;");
    	 	}else if(sortParam.equals("lowToHigh")){
    	 		resultset = stmt.executeQuery("SELECT * from listings WHERE subcategory='"+subcat+"' AND itemname LIKE '%"+searchVal+"%' ORDER BY price;");
    	 	}else if(sortParam.equals("highToLow")){
    	 		resultset = stmt.executeQuery("SELECT * from listings WHERE subcategory='"+subcat+"' AND itemname LIKE '%"+searchVal+"%' ORDER BY price DESC;");
    	 	}else if(sortParam.equals("Tag")){
    	 		resultset = stmt.executeQuery("SELECT * from listings WHERE subcategory='"+subcat+"' AND itemname LIKE '%"+searchVal+"%' ORDER BY subattribute;");
    	 	}else if(sortParam.equals("Open")){
    	 		resultset = stmt.executeQuery("SELECT * from listings WHERE subcategory='"+subcat+"' AND closed='0' AND itemname LIKE '%"+searchVal+"%' ORDER BY itemname;");
    	 	}else if(sortParam.equals("Closed")){
    	 		resultset = stmt.executeQuery("SELECT * from listings WHERE subcategory='"+subcat+"' AND closed='1' AND itemname LIKE '%"+searchVal+"%' ORDER BY itemname;");
    	 	}else{
    	 		resultset = stmt.executeQuery("SELECT * from listings WHERE subcategory='"+subcat+"' AND itemname LIKE '%"+searchVal+"%';");
    	 	}
             
       	 %>
    	<br><br>
    	<form method="post" action="examinelisting.jsp">
    	<TABLE align="center" BORDER="1">
            <TR>
            	<TH></TH>
                <TH>Name</TH>
                <TH>Tag</TH>
                <TH>Price</TH>
                <TH>Status</TH>
            </TR>
            <% while(resultset.next()){ 
            	String status = resultset.getString(8);
            %>
            <TR>
            	<TD> <button name="lid" type="submit" value="<%= resultset.getString(1) %>">>></button></TD>
           		<TD> <%=resultset.getString(2)%></TD>
                <TD> <%= resultset.getString(4) %></TD>
                <TD> <%= resultset.getString(5) %></TD>
                <%if(status.equals("0")){
                	%>
                	<TD bgcolor="green">Open</TD>
                	<%
                }else{
                	%>
            		<TD bgcolor="red">CLOSED</TD>
            		<%
                } %>
            </TR>
            <% } %>
        </TABLE>
    	</form>
    </div>
</body>
</html>
