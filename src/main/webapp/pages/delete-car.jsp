<%@ page import="com.car.tuneshift.models.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Delete Car</title>
    <style>
        .container {
            max-width: 500px;
            margin: 40px auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 8px;
            text-align: center;
        }

        .btn {
            display: inline-block;
            padding: 10px 15px;
            margin: 10px;
            border-radius: 4px;
            text-decoration: none;
            color: white;
            cursor: pointer;
        }

        .btn-danger {
            background-color: #dc3545;
        }

        .btn-secondary {
            background-color: #6c757d;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

        .btn-secondary:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>

<%
    // Redirect to login if user is not logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }

    // Retrieve car details from request parameters
    String model = request.getParameter("model");
    String year = request.getParameter("year");
    String plate = request.getParameter("plate");

    if (model == null || year == null || plate == null) {
%>
<div class="container">
    <h2 style="color:red;">Invalid car data. Please go back and try again.</h2>
    <a href="<%= request.getContextPath() %>/pages/my-cars.jsp" class="btn btn-secondary">Back to My Cars</a>
</div>
<%
        return;
    }
%>

<div class="container">
    <h2>Delete Car</h2>
    <p>Are you sure you want to delete this car?</p>

    <div style="margin: 20px 0; text-align: left;">
        <p><strong>Model:</strong> <%= model %></p>
        <p><strong>Year:</strong> <%= year %></p>
        <p><strong>License Plate:</strong> <%= plate %></p>
    </div>

    <form action="<%= request.getContextPath() %>/DeleteCarServlet" method="post">
        <input type="hidden" name="model" value="<%= model %>">
        <input type="hidden" name="year" value="<%= year %>">
        <input type="hidden" name="plate" value="<%= plate %>">

        <div style="margin-top: 20px;">
            <button type="submit" class="btn btn-danger">Delete Car</button>
            <a href="<%= request.getContextPath() %>/pages/my-cars.jsp" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>

</body>
</html>