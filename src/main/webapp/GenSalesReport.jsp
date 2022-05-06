<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.dbapp.*" %>
<%@ page import="java.sql.Timestamp, java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Viewing Sales Report</title>
<style>
.center {
	margin-left: auto;
	margin-right: auto;
}

table, th, td {
  	border: 1px solid;
  	border-collapse: collapse;
  	padding: 8px;
}
</style>
</head>
<body>
<a href="AdminHome.jsp"><= Exit Sales Report</a>
	<%
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		String start = request.getParameter("date1");
		String end = request.getParameter("date2");
		SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
		SimpleDateFormat printer = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss");
		
		Timestamp date1 = new Timestamp(fmt.parse(start).getTime());
		Timestamp date2 = new Timestamp(fmt.parse(end).getTime());
		try {
			PreparedStatement ps = con.prepareStatement(
				"SELECT SUM(price) " +
				"FROM listings l " +
				"WHERE " +
					"dt >= (?) AND dt <= (?) AND closed=1 " +
					"AND l.l_id IN (SELECT g.l_id FROM generates g)"
			);
			ps.setTimestamp(1, date1);
			ps.setTimestamp(2, date2);
			ResultSet rs = ps.executeQuery();
			String total_earnings = "0.00";
			if (rs.next()) {
				total_earnings = rs.getString(1);
			}
	%>
	<div style="text-align:center">
	<h1>Viewing Sale Report</h1>
	<h3>From: <%= printer.format(fmt.parse(start)) %></h3>
	<h3>To: <%= printer.format(fmt.parse(end)) %></h3>
	<hr>
	<h3>Total Earnings: $<%= total_earnings %></h3>
	<%
		ps = con.prepareStatement(
			"SELECT l.itemname, l.subcategory, SUM(price), COUNT(*) " +
			"FROM listings l " +
			"WHERE " +
				"dt >= (?) AND dt <= (?) AND closed=1 " +
				"AND l.l_id IN (SELECT g.l_id FROM generates g) " +
			"GROUP BY l.itemname " +
			"ORDER BY SUM(l.price) DESC"
		);
		ps.setTimestamp(1, date1);
		ps.setTimestamp(2, date2);
		rs = ps.executeQuery();
	%>
	<br>
	<h4>Best Selling Items</h4>
	<table class="center">
		<tr>
			<th>Item</th>
			<th>Category</th>
			<th>Earnings</th>
			<th>Number Sold</th>
		</tr>
	<%	while (rs.next()) {	%>
		<tr>
			<td><%= rs.getString(1) %></td>
			<td><%= rs.getString(2) %></td>
			<td>$<%= rs.getString(3) %></td>
			<td><%= rs.getString(4) %></td>
		</tr>
	<%	} %>
	</table>
	
	<%
		ps = con.prepareStatement(
			"SELECT l.subcategory, SUM(price), COUNT(*) " +
			"FROM listings l " +
			"WHERE " +
				"dt >= (?) AND dt <= (?) AND closed=1 " +
				"AND l.l_id IN (SELECT g.l_id FROM generates g) " +
			"GROUP BY l.subcategory " +
			"ORDER BY SUM(l.price) DESC"
		);
		ps.setTimestamp(1, date1);
		ps.setTimestamp(2, date2);
		rs = ps.executeQuery();
	%>
	<br>
	<h4>Best Selling Categories</h4>
	<table class="center">
		<tr>
			<th>Category</th>
			<th>Earnings</th>
			<th>Number Items Sold</th>
		</tr>
	<%	while (rs.next()) {	%>
		<tr>
			<td><%= rs.getString(1) %></td>
			<td>$<%= rs.getString(2) %></td>
			<td><%= rs.getString(3) %></td>
		</tr>
	<%	} %>
	</table>
	
	<%
		ps = con.prepareStatement(
				"SELECT p.username, SUM(l.price), COUNT(*) " +
				"FROM listings l " +
				"INNER JOIN bidson bd ON l.l_id = bd.l_id " +
				"INNER JOIN bids b ON bd.b_id = b.b_id " + 
				"INNER JOIN places p ON p.b_id = b.b_id " +
				"WHERE l.closed=1 AND l.price=b.price AND l.l_id IN (SELECT g.l_id FROM generates g) " +
				"AND dt >= (?) AND dt <= (?) " +
				"GROUP BY p.username " +
				"ORDER BY SUM(l.price) DESC"
		);
		ps.setTimestamp(1, date1);
		ps.setTimestamp(2, date2);
		rs = ps.executeQuery();
	%>
	<br>
	<h4>Biggest Spenders</h4>
	<table class="center">
		<tr>
			<th>Username</th>
			<th>Total Spent</th>
			<th>Number Items Bought</th>
		</tr>
	<%	while (rs.next()) {	%>
		<tr>
			<td><%= rs.getString(1) %></td>
			<td>$<%= rs.getString(2) %></td>
			<td><%= rs.getString(3) %></td>
		</tr>
	<%	} %>
	</table>
	<%
		ps = con.prepareStatement(
				"SELECT p.username, SUM(l.price), COUNT(*) " +
				"FROM listings l " +
				"INNER JOIN posts p ON p.l_id = l.l_id " +
				"WHERE l.closed=1 AND l.l_id IN (SELECT g.l_id FROM generates g) " +
				"AND dt >= (?) AND dt <= (?) " +
				"GROUP BY p.username " +
				"ORDER BY SUM(l.price) DESC"
		);
		ps.setTimestamp(1, date1);
		ps.setTimestamp(2, date2);
		rs = ps.executeQuery();
	%>
	<br>
	<h4>Biggest Earners</h4>
	<table class="center">
		<tr>
			<th>Username</th>
			<th>Total Earnings</th>
			<th>Number Items Bought</th>
		</tr>
	<%	while (rs.next()) {	%>
		<tr>
			<td><%= rs.getString(1) %></td>
			<td>$<%= rs.getString(2) %></td>
			<td><%= rs.getString(3) %></td>
		</tr>
	<%	} %>
	</table>
	
	<%
		} catch (SQLException e) {
			e.printStackTrace();
		}
	%>
	</div>
</body>
</html>