<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.car.tuneshift.models.User" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.FileReader" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - Admin Dashboard</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            display: flex;
        }

        .sidebar {
            width: 250px;
            background: #2c3e50;
            color: white;
            padding: 20px;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            padding: 30px;
            background: #f5f6fa;
        }

        .nav-item {
            padding: 12px;
            margin: 8px 0;
            border-radius: 4px;
            cursor: pointer;
            color: white;
            text-decoration: none;
            display: block;
        }

        .nav-item:hover {
            background: #34495e;
        }

        .active {
            background: #3498db;
        }

        .dashboard-card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .table-container {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ecf0f1;
        }

        th {
            background: #3498db;
            color: white;
        }

        tr:hover {
            background: #f8f9fa;
        }

        .user-details {
            margin-bottom: 20px;
        }

        .user-name {
            font-weight: bold;
            font-size: 18px;
            color: #2c3e50;
        }

        .user-email {
            color: #7f8c8d;
            font-size: 14px;
        }

        .user-phone {
            color: #7f8c8d;
            font-size: 14px;
        }

        .car-details {
            margin-top: 10px;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 4px;
        }

        .car-model {
            font-weight: 600;
            color: #2c3e50;
        }

        .car-info {
            color: #7f8c8d;
            font-size: 14px;
        }

        .no-cars {
            color: #7f8c8d;
            font-style: italic;
        }

        .delete-btn {
            background: #e74c3c;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: background 0.3s ease;
        }

        .delete-btn:hover {
            background: #c0392b;
        }

        .delete-btn i {
            font-size: 14px;
        }
    </style>
</head>
<body>
<div class="sidebar">
    <h2>Admin Panel</h2>
    <a href="admin-dashboard.jsp" class="nav-item<%= request.getRequestURI().endsWith("admin-dashboard.jsp") ? " active" : "" %>">Dashboard</a>
    <a href="admin-services.jsp" class="nav-item<%= request.getRequestURI().endsWith("admin-services.jsp") ? " active" : "" %>">Manage Services</a>
    <a href="admin-users.jsp" class="nav-item<%= request.getRequestURI().endsWith("admin-users.jsp") ? " active" : "" %>">Manage Users</a>
    <a href="${pageContext.request.contextPath}/AdminLogoutServlet" class="nav-item" onclick="return confirm('Are you sure you want to log out?');">Logout</a>
</div>

<div class="main-content">
    <h1>Manage Users</h1>
    
    <div class="dashboard-card">
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>User Details</th>
                        <th>Vehicle Information</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            // Read users file
                            String usersFilePath = "C:/Users/Dell/Desktop/tuneshift/data/users.txt";
                            java.io.File usersFile = new java.io.File(usersFilePath);
                            
                            if (usersFile.exists()) {
                                try (java.io.BufferedReader br = new java.io.BufferedReader(new java.io.FileReader(usersFile))) {
                                    String line;
                                    while ((line = br.readLine()) != null) {
                                        if (line.trim().isEmpty()) continue;
                                        String[] userData = line.split(",");
                                        if (userData.length >= 5) {
                                            String fullName = userData[0];
                                            String email = userData[1];
                                            String phone = userData[2];
                                            String username = userData[3];
                                            
                                            // Read cars for this user
                                            String carsFilePath = "C:/Users/Dell/Desktop/tuneshift/data/cars.txt";
                                            java.io.File carsFile = new java.io.File(carsFilePath);
                                            List<String[]> userCars = new ArrayList<>();
                                            
                                            if (carsFile.exists()) {
                                                try (java.io.BufferedReader carBr = new java.io.BufferedReader(new java.io.FileReader(carsFile))) {
                                                    String carLine;
                                                    while ((carLine = carBr.readLine()) != null) {
                                                        if (carLine.trim().isEmpty()) continue;
                                                        String[] carData = carLine.split("\\|");
                                                        if (carData.length >= 4 && carData[0].equals(username)) {
                                                            userCars.add(carData);
                                                        }
                                                    }
                                                }
                                            }
                    %>
                    <tr>
                        <td>
                            <div class="user-details">
                                <div class="user-name"><%= fullName %></div>
                                <div class="user-email"><%= email %></div>
                                <div class="user-phone"><%= phone %></div>
                            </div>
                        </td>
                        <td>
                            <% if (userCars.isEmpty()) { %>
                                <div class="no-cars">No vehicles registered</div>
                            <% } else { %>
                                <% for (String[] car : userCars) { %>
                                    <div class="car-details">
                                        <div class="car-model"><%= car[1] %></div>
                                        <div class="car-info">
                                            Year: <%= car[2] %> | 
                                            License: <%= car[3] %>
                                        </div>
                                    </div>
                                <% } %>
                            <% } %>
                        </td>
                        <td>
                            <form action="${pageContext.request.contextPath}/DeleteUserServlet" method="post" style="display: inline;">
                                <input type="hidden" name="username" value="<%= username %>">
                                <button type="submit" class="delete-btn" onclick="return confirm('Are you sure you want to delete this user? This will also delete all their cars and bookings.')">
                                    <i class="fas fa-trash"></i> Delete User
                                </button>
                            </form>
                        </td>
                    </tr>
                    <%
                                        }
                                    }
                                }
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='3'>Error loading users: " + e.getMessage() + "</td></tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    // Add Font Awesome for the trash icon
    const link = document.createElement('link');
    link.rel = 'stylesheet';
    link.href = 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css';
    document.head.appendChild(link);
</script>
</body>
</html>