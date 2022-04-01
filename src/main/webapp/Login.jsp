<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Dirty Bubble</title>
</head>
<body>
	<h2>Please input your login:</h2>
	<form method="post" action="VerifyLogin.jsp">
		<table>
		<tr>
			<td>Username: <input type="text" name="username" value=""/></td>
		</tr>
		<tr>
			<td>Password: <input type="text" name="password" value=""/></td>
		</tr>
		<tr>
			<td><input type="submit" value="submit" /></td>
		</tr>
		</table>
	</form>
	
	<h2>Register a new account:</h2>
	<form method="post" action="RegisterAccount.jsp">
		<table>
		<tr>
			<td>Username: <input type="text" name="username" value=""/></td>
		</tr>
		<tr>
			<td>Password: <input type="text" name="password" value=""/></td>
		</tr>
		<tr>
			<td><input type="submit" value="submit" /></td>
		</tr>
		</table>
	</form>
</body>
</html>