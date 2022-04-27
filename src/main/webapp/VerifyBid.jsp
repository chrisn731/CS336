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
			
			Statement stmt = con.createStatement();//update listing
			Statement stmt2 = con.createStatement();//insert into bids
			Statement stmt3 = con.createStatement();//insert into bidson
			
			String username = request.getParameter("username"); //user making the bid
			String lid = request.getParameter("lid");
			String bid = request.getParameter("bid");
			String price = request.getParameter("price");
			Double b = Double.parseDouble(bid);
			Double p = Double.parseDouble(price);
			
            p = Math.floor(p * 100)/100;
            b = Math.floor(b * 100)/100;
			if(bid.equals("NONE")){
				%>
				<jsp:forward page="examinelisting.jsp?username=<%=username%>">
				<jsp:param name="msg" value="You must input a bid."/> 
				<jsp:param name="lid" value="<%=lid%>"/> 
				</jsp:forward>
			<%}else if(p>=b){%>
				<jsp:forward page="examinelisting.jsp?username=<%=username%>">
				<jsp:param name="msg" value="You must input a valid bid."/> 
				<jsp:param name="lid" value="<%=lid%>"/> 
				</jsp:forward><%
			}else{//BID SUCCESS
				//update listing
				String insert = "UPDATE listings SET price = " + b + " WHERE l_id = " + lid;
				PreparedStatement ps = con.prepareStatement(insert);
				ps.executeUpdate();
				
				//insert into bids
				//insert = "INSERT INTO bids(price, dtime)" 
					//	+ "VALUES(?,?)";
				//ps = con.prepareStatement(insert);
				//ps.setString(1, price);
				//DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd hh:mm:ss");
				//ps.setTimestamp(2, Timestamp.valueOf(new LocalDateTime().now()));
				//ps.executeUpdate();
			} 		
			
			%>
			<jsp:forward page="examinelisting.jsp?username=<%=username%>">
			<jsp:param name="makeBidRet" value="Bid success!"/>
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
