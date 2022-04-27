<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.dbapp.*" %>


<% 
    		//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			String username = request.getParameter("username"); //get current user
			String lid = request.getParameter("lid");
			Statement stmt = con.createStatement();
            ResultSet resultset = stmt.executeQuery("SELECT * from listings WHERE l_id='"+lid+"';") ; 
        	// 1-l_id, 2-name, 3-subcategory, 4-subattribute, 5-price, 6-minincrement
        	   	String name = null;//listing name
	            String subcat = null;//subcategory
	            String subattr = null;//subattribute
	            String price = null;//price
	            String minsale = null;//min. sale price
	            Double p = null; //price
	            Double m = null; //min incr
	            Double minbid = null; //min bid
	            
	            Statement stmt2 = con.createStatement();
	          	ResultSet fetchposter = stmt2.executeQuery("SELECT username from posts WHERE l_id="+lid+";");
	            String postedby = null; //user who posted listing
	           	
	           
        %>

                <%
                while(resultset.next()){
	            //String lid created above
	            name = resultset.getString(2);
	            subcat = resultset.getString(3);
	            subattr = resultset.getString(4);
	            price = resultset.getString(5);
	            minsale = resultset.getString(6);
	            
	            p = Double.parseDouble(price);
	            p = Math.floor(p * 100)/100;
				minbid = p+.01;
				minbid = Math.floor(minbid * 100)/100;
	            }//end while loop
                
                while(fetchposter.next()){
    	        	//String lid created above
    	            postedby = fetchposter.getString(1);
    	        }//end while loop
            	%>
        
        <div style="text-align: center">
        <a href="home.jsp?username=<%=username%>">Home</a>
    		<h1><%=name%></h1>
    		
    		<form method="post" action="VerifyBid.jsp?username=<%=username%>">
	    	<table align="center">
	   			<tr>  
					<td><input type="hidden" name="lid" value="<%=lid%>" /></td>
	   			</tr>
	   			<tr>  
					<td><input type="hidden" name="price" value="<%=price%>" /></td>
	   			</tr>
	   			<tr>  
					<td>Current Price: <%=price%></td>
	   			</tr>
	   			<tr>  
					<td>Bid: <input type="number" required name="bid" min="0" value="<%=minbid%>" step=".01"></td>
	   			</tr>
	   			<tr>
					<td><input type="submit" value="Make Bid" style="width: 100%;"/></td>
				</tr>
	   			
	   			
	   			
	   			<% //IF BID ERROR RETURNED
	   				if (request.getParameter("msg") != null) { %>
	   				<tr>
					<td style="text-align: center; color: red"><%=request.getParameter("msg")%></td>	
					</tr>	
				<% } %>
				
				
				
				
	    	</table>
    	</form>
    		<% //IF VALID BID COMPLETED
    			if (request.getParameter("makeBidRet") != null) { %>
				<tr>
					<td><p style="text-align: center; color: blue"><%=request.getParameter("makeBidRet")%></p></td>
				</tr>
				<% } %>
    	</div>
    	
    	
    	
    	
    	<h3><%= "Details:" %></h3>
    	<p><%= "Posted By: " + postedby%></p>
    	<p><%= "Closing Date/Time:"%></p>
    	<p><%= "Subcategory:" + subcat%></p>
    	<p><%="Subattribute: " + subattr%></p>
    	<p><%="Min. Sale Price (WILL BE HIDDEN): " + minsale%></p>
	
    
</body>
</html>
