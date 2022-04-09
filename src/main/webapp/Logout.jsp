<%
	session.invalidate();
	//session.getAttribute("user");   //this will throw an error
	response.sendRedirect("Login.jsp"); 
%>