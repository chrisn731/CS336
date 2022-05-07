<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.dbapp.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Home</title>
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
        <h1>Welcome to BuyMe: Toys</h1>
       
       <table style="margin: 0px auto;">
		<tr>
			<td><a href="Figurines.jsp">Figurines</a></td>
			<td>|</td>
			<td><a href="Cars.jsp">Cars</a></td>
			<td>|</td>
			<td><a href="Construction.jsp">Construction</a></td>
		</tr>
		</table>
       
        <br><br>
        <table align="center">
    		<tr>
    			<td><a href="ViewQuestions.jsp">Q&A</a>
    			<td>|</td>
				<td><a href="Account.jsp">Account</a></td>
				<td>|</td>
				<td><a href="Logout.jsp">Logout</a></td>
   			</tr>
    	</table>
    	
    	<% 
    		//table that shows which listings the user no longer has the highest bid in
    		PreparedStatement ps = con.prepareStatement(
    			"SELECT l.itemname, l.price, MAX(b.price) AS user_max_bid " +
				"FROM places p " +
    			"INNER JOIN bidson bo ON bo.b_id = p.b_id " + 
				"INNER JOIN bids b ON b.b_id = p.b_id " +
				"INNER JOIN listings l ON bo.l_id = l.l_id " + 
				"WHERE p.username =(?) AND l.closed=0 " +
				"GROUP BY l.l_id " +
				"HAVING user_max_bid < l.price");
    		ps.setString(1, username);
    		ResultSet lostBids = ps.executeQuery();
    		
    		//table that shows which automatic bids are no longer valid
    		ps = con.prepareStatement(
    			"SELECT l.itemname, l.price, ab.b_limit " +
    			"FROM auto_bids ab " +
    			"INNER JOIN listings l ON ab.l_id = l.l_id " +
    			"WHERE ab.u_id =(?) AND l.closed=0 " +
    			"HAVING l.price > ab.b_limit");
    		ps.setString(1, username);
    		ResultSet lostAutoBids = ps.executeQuery();	
    		
    		//table that shows a user's won auctions
    		ps = con.prepareStatement(
    			"SELECT DISTINCT l.itemname, l.price " +
  				"FROM listings l " +
  				"INNER JOIN bidson bd ON l.l_id = bd.l_id " +
  				"INNER JOIN bids b ON bd.b_id = b.b_id " + 
  				"INNER JOIN places p ON p.b_id = b.b_id " +
  				"WHERE l.closed=1 AND l.price=b.price AND l.l_id IN (SELECT g.l_id FROM generates g) AND p.username=(?)");
    		ps.setString(1, username);
    		ResultSet wonAuctions = ps.executeQuery();
    		
    		//table that shows listings of a user's interests up for auction
    		ps = con.prepareStatement(
        		"SELECT l.itemname " +
    			"FROM listings l " +
        		"INNER JOIN interests i ON i.interest = l.itemname " + 
    			"WHERE i.username =(?) AND l.closed=0");
        	ps.setString(1, username);
        	ResultSet interests = ps.executeQuery();
       	 %>

    	<table align="center" border="1" style="width: 300px; max-width:300px; margin-top: 20px;">
    		<tr><td><b>Notifications</b></td></tr>
   			<% while(lostBids.next()) { %>
            	<tr>
            		<td>
            			<span style="color:red">Alert! </span>Your bid on '<%= lostBids.getString(1) %>' is no longer the highest bid!
            			<p style="padding: 0">Your bid: $<%= lostBids.getString(3) %><br>Max bid: $<%= lostBids.getString(2) %></p>
            		</td>
           	</tr>
            <% } %>
            <% while(lostAutoBids.next()) { %>
            	<tr>
            		<td>
            			<span style="color:red">Alert! </span>Your auto bid limit on '<%= lostAutoBids.getString(1) %>' is below the current bid price.
            			<p style="padding: 0">Your limit: $<%= lostAutoBids.getString(3) %><br>Max bid: $<%= lostAutoBids.getString(2) %></p>
            		</td>
           	</tr>
            <% } %>
            <% while(wonAuctions.next()) { %>
            	<tr>
            		<td>
            			<span style="color:green">Winner Winner Chicken Dinner!</span> You won the auction '<%=wonAuctions.getString(1)%>'
            				with your bid of $<%=wonAuctions.getString(2)%>
            		</td>
           		</tr>
            <% } %>
            <% while(interests.next()) { %>
            	<tr>
            		<td>
            			<span style="color:blue">Availability Alert! </span>Your interest '<%=interests.getString(1)%>' is up for auction!
            		</td>
           	</tr>
            <% } %>
    	</table>
    </div>
</body>
</html>