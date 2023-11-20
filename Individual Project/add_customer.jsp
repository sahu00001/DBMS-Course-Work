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
    String customer_name = request.getParameter("customer_name");
    String address = request.getParameter("address");
    String category = request.getParameter("category");

    /*
     * If the user hasn't filled out all the time, movie name and duration. This is very simple checking.
     */
    if (customer_name.equals("") || address.equals("") || category.equals ("")) {
        response.sendRedirect("add_movie_form.jsp");
    } else {
        int categoryno = Integer.parseInt(category);
        
        // Now perform the query with the data from the form.
        boolean success = handler.addCustomer(customer_name, address, categoryno);
        if (!success) { // Something went wrong
            %>
                <h2>There was a problem inserting the course</h2>
            <%
        } else { // Confirm success to the user
            %>
            <h2>Customer Database:</h2>

            <ul>
                <li>Start Time: <%=customer_name%></li>
                <li>Movie Name: <%=address%></li>
                <li>Duration: <%=category%></li>
       
            </ul>

            <h2>Was successfully inserted.</h2>
            
            <a href="get_all_movies.jsp">Get all customers.</a>
            <%
        }
    }
    %>
    </body>
</html>
