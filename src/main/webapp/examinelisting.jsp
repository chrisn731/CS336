<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.dbapp.*" %>

<head>
<style>
.center {
	margin-left: auto;
	margin-right: auto;
}
</style>
</head>
<body>
	<%
    		//Get the database connection
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();
			String username = (String) session.getAttribute("username"); //asker
			if (username == null) {
				response.sendRedirect("Login.jsp");
			}
			String lid = request.getParameter("lid");
			Statement stmt = con.createStatement();
            ResultSet resultset = stmt.executeQuery("SELECT * from listings WHERE l_id='"+lid+"';") ;
        	// 1-l_id, 2-name, 3-subcategory, 4-subattribute, 5-price, 6-minincrement

       	   	String name = null;//listing name
            String subcat = null;//subcategory
            String subattr = null;//subattribute
            String price = null;//price
            String minsale = null;//min. sale price
            String cdt = null;//closing datetime
            String status = null;//listing status
            Double p = null; //price
            Double m = null; //min incr
            Double minbid = null; //min bid
            Double minprice = null;

            Statement stmt2 = con.createStatement();
          	ResultSet fetchposter = stmt2.executeQuery("SELECT username from posts WHERE l_id="+lid+";");
            String postedby = null; //user who posted listing

            while(resultset.next()){
	            //String lid created above
	            name = resultset.getString(2);
	            subcat = resultset.getString(3);
	            subattr = resultset.getString(4);
	            price = resultset.getString(5);
	            minsale = resultset.getString(6);
	            cdt = resultset.getString(7);
	            status = resultset.getString(8);

	            p = Double.parseDouble(price);
	            p = Math.round(p * 100.0)/100.0;
				minbid = p+.01;
				minbid = Math.round(minbid * 100.0)/100.0;

				minprice = Double.parseDouble(minsale);
				minprice = Math.round(minprice * 100.0)/100.0;
           }

           while(fetchposter.next()){
  	        	//String lid created above
  	            postedby = fetchposter.getString(1);
  	       }
          %>

        <div style="text-align: center">
        	<a href="home.jsp">Home</a>
    		<h1><%=name%></h1>
    		<% if (status.equals("0")) { %>
    			<p><b>Current Price: $<%=price%></b></p>
    		<% } %>
			
			<!-- Start of Bid Inputs -->
    		<% if (!postedby.equals(username)) { %>
    		<form method="post" action="VerifyBid.jsp">
	    		<table align="center" style="margin-bottom: 0px">
	   			<tr>
					<td><input type="hidden" name="lid" value="<%=lid%>" /></td>
	   			</tr>
	   			<tr>
					<td><input type="hidden" name="price" value="<%=price%>" /></td>
	   			</tr>
			
	   			<% if(status.equals("0")){ //listing is open %>
					<!-- Manual bids -->
					<tr>
						<td>Bid: <input type="number" required name="bid" min="0" value="<%=minbid%>" step=".01"></td>
					</tr>
					<tr>
						<td><input type="submit" value="Make Bid" style="width: 100%;"/></td>
					</tr>
				<% } %>
				</table>
			</form>
			<form method="post" action="VerifyAutoBid.jsp">
	    		<table align="center" style="margin-top: 0px">
	   			<tr>
					<td><input type="hidden" name="lid" value="<%=lid%>" /></td>
	   			</tr>
	   			<tr>
					<td><input type="hidden" name="price" value="<%=price%>" /></td>
	   			</tr>

	   			<% if(status.equals("0")){ //listing is open %>
					<!-- Automatic bids -->
					<tr>
						<td style="text-align: center"> or </td>
					</tr>
					<tr>
						<td>Bid Limit: <input type="number" required name="bid_limit" min="0" step=".01"></td>
  					</tr>
					<tr>
						<td>Increment: <input type="number" required name="increment" min="0" step=".01"></td>
  					</tr>
  					<tr>
						<td><input type="submit" value="Set Automatic Bid" style="width: 100%;"/></td>
					</tr>
					<% } %>
				</table>
			</form>
			<% } %>
			<!-- End of Bid Inputs -->
			
			<% if (p >= minprice && status.equals("1") ) {//listing closed - SALE %>
				<table class="center">
					<tr>
						<td><h4>ITEM SOLD!</h4></td>
					</tr>
					<tr>
						<td>Sale Price: $<%=price%></td>
					</tr>
				</table>
	   		<% } else if (status.equals("1")) { //listing closed - no winner %>
	   			<table class="center">
					<tr>
						<td><h4>Auction Closed: No Winner ;(</h4></td>
					</tr>
					<tr>
						<td>Final Price: $<%=price%></td>
					</tr>
					<tr>
						<td>Desired Minimum: $<%=minprice%></td>
					</tr>
				</table>
	   		<% } %>
   			<% if (request.getParameter("msg") != null) { //IF BID ERROR RETURNED %>
   				<table>
   					<tr>
						<td style="text-align: center; color: red"><%=request.getParameter("msg")%></td>
					</tr>
				</table>
			<% } %>

    		<% if (request.getParameter("makeBidRet") != null) { //IF VALID BID COMPLETED %>
				<tr>
					<td><p style="text-align: center; color: blue"><%=request.getParameter("makeBidRet")%></p></td>
				</tr>
			<% } %>
    	</div>



    	<hr>
    	<h3><u>Details:</u></h3>
    	<p><b>Seller: </b><%=postedby%></p>
    	<p><b>Closing Date/Time: </b><%=cdt%></p>
    	<p><b>Subcategory: </b><%=subcat%></p>
    	<p><b>Subattribute: </b><%=subattr%></p>
    	<hr>
		<div style="text-align: center">
		<h3>Bid History</h3>
		<%
			Statement stmt3 = con.createStatement();
	        ResultSet bidhist = stmt3.executeQuery("SELECT b.b_id, price, username, dtime from bids b "+
	        		"LEFT JOIN bidson bo on bo.b_id = b.b_id LEFT JOIN places p on p.b_id = bo.b_id " +
	        		"WHERE l_id= " +lid+";");
		%>

		<table align="center" BORDER="1">
            <TR>
                <TH>Price</TH>
                <TH>Bidder</TH>
                <TH>Date/Time</TH>
            </TR>
            <% while(bidhist.next()){ %>
            <TR>
             	<TD><%=bidhist.getString(2)%></TD>
                <TD><%=bidhist.getString(3)%></TD>
                <TD><%=bidhist.getString(4)%></TD>
            </TR>
            <% } %>
        </TABLE>
        <hr>
        <h3>Similar Items</h3>
        <%
			Statement stmt4 = con.createStatement();
	        ResultSet similar = stmt4.executeQuery("SELECT * from listings WHERE l_id != "+lid+" AND (itemname LIKE '%"+name+"%' OR subattribute LIKE '%"+subattr+"%');");
		%>
		<form method="post" action="examinelisting.jsp">
    	<table align="center" BORDER="1">	
            <TR>
            	<TH>View</TH>
                <TH>Item Name</TH>
                <TH>Subcategory</TH>
                <TH>Attribute</TH>
            </TR>
            <% while(similar.next()){ 
            %>
            <TR>
            	<TD> <button name="lid" type="submit" value="<%= similar.getString(1) %>">>></button></TD>
           		<TD><%=similar.getString(2)%></TD>
           		<TD><%=similar.getString(3)%></TD>
           		<TD><%=similar.getString(4)%></TD>
            </TR>
            <% } %>
        </TABLE>
    	</form>
		</div>
</body>
</html>
