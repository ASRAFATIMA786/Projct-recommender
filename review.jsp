<%@page import="com.connection.DatabaseConnection"%>
<%@page import="java.sql.ResultSet"%>
<%-- <%@page import="com.mysql.xdevapi.Result"%> --%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

<%
String productname=request.getParameter("productname");
System.out.println(productname);
int productid=0;

String sql="select * from tblproduct where name='"+productname+"'";
ResultSet resultSet= DatabaseConnection.getResultForProducts(sql);
if(resultSet.next()){%>
	<form action="AddReview" method="post">
	<td class="invert"><img src=uploads/<%=resultSet.getString(7)%> style="width: 150px; height: 100px;"><br><%=resultSet.getString(8)%></td>
	<%productid= Integer.parseInt(resultSet.getString(1)); %>
	<input type="hidden" value="<%=resultSet.getString(1) %>" name="productid"/><br/><br/>
	<label>Enter you review</label><br/>
	<textarea rows="10" cols="50" name="review"></textarea>
	<input type="submit" value="submit"/>
	</form>
<% }%>

<p>Reviews </p>
<table border="1">
<tr>
</tr>
<%
String sql1="select * from review where productid='"+productid+"'";
ResultSet resultSet1= DatabaseConnection.getResultForProducts(sql1);
while(resultSet1.next()){%>
<tr>
<td><p><%=resultSet1.getString(3) %></p></td>
</tr>


<%} %>

</table>


</body>
</html>






















