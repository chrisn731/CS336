<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.time.LocalDateTime,java.time.format.DateTimeFormatter"%>
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
			
			String username = (String) session.getAttribute("username");
			if (username == null) {
				response.sendRedirect("Login.jsp");
			}
			
			String lid = request.getParameter("lid");
			String price = request.getParameter("price");
			String bidLimit = request.getParameter("bid_limit");
			String increment = request.getParameter("increment");

			Double lim = Double.parseDouble(bidLimit);
			Double incr = Double.parseDouble(increment);
			Double p = Double.parseDouble(price);
            p = Math.round(p * 100.0)/100.0;
            lim = Math.round(lim * 100.0)/100.0;
            incr = Math.round(incr * 100.0)/100.0;
            
			if (bidLimit.equals("NONE")) {
				%>
				<jsp:forward page="examinelisting.jsp">
				<jsp:param name="msg" value="You must input a bid limit."/> 
				<jsp:param name="lid" value="<%=lid%>"/> 
				</jsp:forward>
			<% } else if (p >= lim) { %>
				<jsp:forward page="examinelisting.jsp">
				<jsp:param name="msg" value="Bid limit must be greater than current bid."/> 
				<jsp:param name="lid" value="<%=lid%>"/> 
				</jsp:forward><%
			} else { //On success, create an auto bid for this user on this listing
				PreparedStatement ps = con.prepareStatement(
						"INSERT INTO auto_bids(u_id, l_id, increment, b_limit, current_price) " +
						"VALUES(?, ?, ?, ?, ?) " +
						"ON DUPLICATE KEY UPDATE increment = (?), b_limit = (?), current_price = (?)");
				ps.setString(1, username);
				ps.setString(2, lid);
				ps.setDouble(3, incr);
				ps.setDouble(4, lim);
				ps.setDouble(5, p);
				ps.setDouble(6, incr);
				ps.setDouble(7, lim);
				ps.setDouble(8, p);
				ps.executeUpdate();
			} 		
			
			%>
			<jsp:forward page="examinelisting.jsp">
			<jsp:param name="makeBidRet" value="Automatic bid added!"/>
			<jsp:param name="lid" value="<%=lid%>"/>
			 
			</jsp:forward>
			<% 
		} catch (SQLException e) {
			String code = e.getSQLState();
			if (code.equals("23000")) {
				%>
				<jsp:forward page="Account.jsp">
				<jsp:param name="msg" value="This bid already exists."/> 
				</jsp:forward>
				<%
			} else {
				%>
				<jsp:forward page="Account.jsp">
				<jsp:param name="msg" value="Error making bid... Please try again."/> 
				</jsp:forward>
				<%
			}
		} catch (Exception e) {
			out.print("Unknown exception.");
			%>
			<jsp:forward page="Account.jsp">
			<jsp:param name="msg" value="Error making bid. Please try again."/> 
			</jsp:forward>
			<%
		}
	%>
</body>
</html>
