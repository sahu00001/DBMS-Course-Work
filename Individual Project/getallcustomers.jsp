<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
    <meta charset="UTF-8">
        <title>Customer Data</title>
    </head>
    <body>
        <%@page import="jspazuretest.DataHandle"%>
        <%@page import="java.sql.ResultSet"%>
        <%
            // We instantiate the data handler here, and get all the movies from the database
            final DataHandle handler = new DataHandle();
            final ResultSet customers = handler.getAllCustomer();
        %>
        <!-- The table for displaying all the movie records -->
        <table cellspacing="2" cellpadding="2" border="1">
            <tr> <!-- The table headers row -->
              <td align="center">
                <h4>customer_name</h4>
              </td>
              <td align="center">
                <h4>address</h4>
              </td>
              <td align="center">
                <h4>category</h4>
              </td>
            </tr>
            <%
               while(customers.next()) { // For each movie_night record returned...
                   // Extract the attribute values for every row returned
                   final String customer_name = customers.getString("customer_name");
                   final String address = customers.getString("customer_address");
                   final int category = customers.getInt("category");

                   
                   out.println("<tr>"); // Start printing out the new table row
                   out.println( // Print each attribute value
                        "<td align=\"center\">" + customer_name +
                        "</td><td align=\"center\"> " + address +
                        "</td><td align=\"center\"> " + category +
                         "</td>");
                   out.println("</tr>");
               }
               %>
          </table>
    </body>
</html>
