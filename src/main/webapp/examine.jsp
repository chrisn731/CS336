<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.dbapp.*" %>

	 <% 
    		//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();

			Statement stmt = con.createStatement();
            ResultSet resultset = stmt.executeQuery("SELECT * from listings WHERE subcategory='Cars';") ; 
        %>

	<TABLE align="center" BORDER="1">
            <TR>
            	<TH>Listing ID</TH>
                <TH>NAME</TH>
                <TH>Color</TH>
                <TH>Price</TH>
            </TR>
            <% while(resultset.next()){ %>
            <TR>
              
				<TD> <%= resultset.getString(1) %></TD>
                <TD><%=resultset.getString(2)%></TD>
                <TD> <%= resultset.getString(4) %></TD>
                <TD> <%= resultset.getString(5) %> </TD>
               
            </TR>
            <% } %>
        </TABLE>
