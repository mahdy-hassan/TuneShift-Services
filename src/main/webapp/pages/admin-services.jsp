<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Services - Admin Dashboard</title>
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
        .service-table-container {
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
        .edit-btn {
            background: #3498db;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 8px;
            transition: background 0.3s ease;
        }
        .edit-btn:hover {
            background: #217dbb;
        }
        .delete-btn {
            background: #e74c3c;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            transition: background 0.3s ease;
        }
        .delete-btn:hover {
            background: #c0392b;
        }
        .add-btn {
            background: #3498db;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            margin-bottom: 20px;
            transition: background 0.3s ease;
        }
        .add-btn:hover {
            background: #217dbb;
        }
        .actions-cell {
            display: flex;
            gap: 8px;
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
    <h1>Manage Services</h1>
    <div class="dashboard-card">
        <form action="add-service.jsp" method="get" style="margin-bottom: 20px;">
            <button type="submit" class="add-btn">Add New Service</button>
        </form>
        <div class="service-table-container">
            <table>
                <thead>
                    <tr>
                        <th>Service ID</th>
                        <th>Service Name</th>
                        <th>Description</th>
                        <th>Price ($)</th>
                        <th>Duration (min)</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    String servicesFilePath = "C:/Users/Dell/Desktop/tuneshift/data/services.txt";
                    File servicesFile = new File(servicesFilePath);
                    if (servicesFile.exists()) {
                        try (BufferedReader br = new BufferedReader(new FileReader(servicesFile))) {
                            String line;
                            while ((line = br.readLine()) != null) {
                                if (line.trim().isEmpty()) continue;
                                String[] parts = line.split("\\|");
                                if (parts.length >= 5) {
                %>
                    <tr>
                        <td><%= parts[0] %></td>
                        <td><%= parts[1] %></td>
                        <td><%= parts[2] %></td>
                        <td>$<%= String.format("%.2f", Double.parseDouble(parts[3])) %></td>
                        <td><%= parts[4] %></td>
                        <td class="actions-cell">
                            <form action="edit-service.jsp" method="get" style="display:inline;">
                                <input type="hidden" name="serviceId" value="<%= parts[0] %>">
                                <button type="submit" class="edit-btn">Edit</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/AdminServiceServlet" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="serviceId" value="<%= parts[0] %>">
                                <button type="submit" class="delete-btn" onclick="return confirm('Are you sure you want to delete this service?')">Delete</button>
                            </form>
                        </td>
                    </tr>
                <%
                                }
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='6'>Error loading services: " + e.getMessage() + "</td></tr>");
                        }
                    } else {
                        out.println("<tr><td colspan='6'>No services found.</td></tr>");
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html> 