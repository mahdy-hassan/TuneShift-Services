<%@ page import="com.car.tuneshift.models.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>Register Your Car</title>
</head>
<body>

<%
  User user = (User) session.getAttribute("user");
  if (user == null) {
    response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
    return;
  }
%>

<h1>Register Your Car</h1>

<form action="<%= request.getContextPath() %>/AddCarServlet" method="post">
  <input type="hidden" name="username" value="<%= user.getUsername() %>"/>

  <label>Car Model:</label><br>
  <input type="text" name="carModel" required><br><br>

  <label>Vehicle Year:</label><br>
  <input type="text" name="vehicleYear" required><br><br>

  <label>License Plate:</label><br>
  <input type="text" name="licensePlate" required><br><br>

  <input type="submit" value="Add Car">
</form>

<br>
<a href="<%= request.getContextPath() %>/pages/profile.jsp">Back to Profile</a>

</body>
</html>
