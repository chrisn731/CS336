<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Create Account</title>
</head>
<body>
	<h2 style="text-align: center">Register a new account:</h2>
	<form method="post" action="RegisterAccount.jsp">
		<table style="margin: 0px auto;">
		<tr>
			<td>Username: <input type="text" name="username" value="" maxlength="30" required/></td>
		</tr>
		<tr>
			<td>Password: <input type="text" name="password" value="" maxlength="30" required/></td>
		</tr>
		<tr>
			<td><input type="submit" value="Create Account" style="width: 100%;"/></td>
		</tr>
		<tr>
			<td><p style="text-align: center">Have an account? <a href="Login.jsp">Sign in</a></p></td>
		</tr>
		<% if (request.getParameter("msg") != null) { %>
			<tr>
				<td><p style="text-align: center; color: red"><%=request.getParameter("msg")%></p></td>
			</tr>
		<% } %>
		
		</table>
	</form>
</body>
</html>