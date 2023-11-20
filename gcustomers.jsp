<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Query Result</title>
</head>
<body>
	<%@page import="jspazuretest.DataHandle"%>
	<%@page import="java.sql.ResultSet"%>
	<%@page import="java.sql.Array"%>
	<%
	// The handler is the one in charge of establishing the connection.
	DataHandle handler = new DataHandle();
	// Get the attribute values passed from the input form.
	String from = request.getParameter("from");
	String to = request.getParameter("to");

	/*
	* If the user hasn't filled out all the category numbers. This is very simple
	checking.
	*/
	if (from.equals("") || to.equals("")) {
		response.sendRedirect("Rcustomers.jsp");
	} else {
		int min_category = Integer.parseInt(from);
		int max_category = Integer.parseInt(to);
		// Now perform the query with the data from the form.
		final ResultSet Customer = handler.fetchCustomers(min_category, max_category);
	%>
	<!-- The table for displaying all the movie records -->
	<table cellspacing="2" cellpadding="2" border="1">
		<tr>
			<!-- The table headers row -->
			<td align="center">
				<h4>Name</h4>
			</td>
			<td align="center">
				<h4>Address</h4>
			</td>
			<td align="center">
				<h4>Category</h4>
			</td>
		</tr>
		<%
		while (Customer.next()) { // For each customer record returned...
			// Extract the attribute values for every row returned
			String name = Customer.getString("customer_name");
			String address = Customer.getString("customer_address");
			String category = Customer.getString("category");
			out.println("<tr>"); // Start printing out the new table row
			out.println( // Print each attribute value
			"<td align=\"center\">" + name + "<td align=\"center\">" + address + "<td align=\"center\">" + category
					+ "</td>");
			out.println("</tr>");
		}

		}
		%>
	
</body>
</html>