<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Dashboard</title>
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

    .stats-container {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 20px;
      margin-bottom: 30px;
    }

    .stat-card {
      background: white;
      border-radius: 8px;
      padding: 20px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .stat-value {
      font-size: 24px;
      font-weight: bold;
      color: #3498db;
    }

    .stat-label {
      color: #7f8c8d;
      margin-top: 5px;
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

    .action-btn {
      padding: 6px 12px;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      margin: 0 4px;
    }

    .edit-btn {
      background: #27ae60;
      color: white;
    }

    .delete-btn {
      background: #e74c3c;
      color: white;
    }

    .price-tag {
      color: #27ae60;
      font-weight: bold;
    }

    .stock-in {
      color: #27ae60;
    }

    .stock-out {
      color: #e74c3c;
    }
  </style>
</head>
<body>
<div class="sidebar">
  <h2>Admin Panel</h2>
  <a href="admin-dashboard.jsp" class="nav-item<%= request.getRequestURI().endsWith("admin-dashboard.jsp") ? " active" : "" %>">Dashboard</a>
  <a href="admin-services.jsp" class="nav-item<%= request.getRequestURI().endsWith("admin-services.jsp") ? " active" : "" %>">Manage Services</a>
  <a href="admin-users.jsp" class="nav-item<%= request.getRequestURI().endsWith("admin-users.jsp") ? " active" : "" %>">Manage Users</a>
  <a href="admin-feedback.jsp" class="nav-item<%= request.getRequestURI().endsWith("admin-feedback.jsp") ? " active" : "" %>">View Feedback</a>
  <a href="${pageContext.request.contextPath}/AdminLogoutServlet" class="nav-item" onclick="return confirm('Are you sure you want to log out?');">Logout</a>
</div>

<div class="main-content">
  <h1>Admin Dashboard</h1>
  
  <%
    // Count total users
    int totalUsers = 0;
    try {
        String usersFilePath = "C:/Users/Dell/Desktop/tuneshift/data/users.txt";
        java.io.File usersFile = new java.io.File(usersFilePath);
        if (usersFile.exists()) {
            try (java.io.BufferedReader br = new java.io.BufferedReader(new java.io.FileReader(usersFile))) {
                String line;
                while ((line = br.readLine()) != null) {
                    if (line.trim().isEmpty()) continue;
                    totalUsers++;
                }
            }
        }
    } catch (Exception e) { totalUsers = 0; }

    // Count active bookings (pending bookings)
    int activeBookings = 0;
    try {
        String bookingsFilePath = "C:/Users/Dell/Desktop/tuneshift/data/bookings.txt";
        java.io.File bookingsFile = new java.io.File(bookingsFilePath);
        if (bookingsFile.exists()) {
            try (java.io.BufferedReader br = new java.io.BufferedReader(new java.io.FileReader(bookingsFile))) {
                String line;
                while ((line = br.readLine()) != null) {
                    if (line.trim().isEmpty()) continue;
                    String[] parts = line.split("\\|");
                    if (parts.length >= 11) {
                        String status = parts[10];
                        if (status.equals("Pending")) {
                            activeBookings++;
                        }
                    }
                }
            }
        }
    } catch (Exception e) { activeBookings = 0; }
  %>

  <div class="stats-container">
    <div class="stat-card">
      <div class="stat-value"><%= totalUsers %></div>
      <div class="stat-label">Total Users</div>
    </div>
    <div class="stat-card">
      <div class="stat-value"><%= activeBookings %></div>
      <div class="stat-label">Active Bookings</div>
    </div>
  </div>


  <div class="dashboard-card">
    <h2>Pending Bookings</h2>
    <div class="table-container">
      <table>
        <thead>
          <tr>
            <th>User</th>
            <th>Booking ID</th>
            <th>Service</th>
            <th>Car Details</th>
            <th>Date & Time</th>
            <th>Price</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <%
            try {
                String bookingsFilePath = "C:/Users/Dell/Desktop/tuneshift/data/bookings.txt";
                java.io.File bookingsFile = new java.io.File(bookingsFilePath);
                if (bookingsFile.exists()) {
                    try (java.io.BufferedReader br = new java.io.BufferedReader(new java.io.FileReader(bookingsFile))) {
                        String line;
                        int index = 0;
                        while ((line = br.readLine()) != null) {
                            if (line.trim().isEmpty()) continue;
                            String[] parts = line.split("\\|");
                            if (parts.length >= 11) {
                                String status = parts[10];
                                // Only show pending bookings
                                if (status.equals("Pending")) {
          %>
          <tr>
            <td>
              <strong><%= parts[0] %></strong>
            </td>
            <td><%= parts[1] %></td>
            <td>
              <%= parts[6] %><br>
              <small>Service ID: <%= parts[5] %></small>
            </td>
            <td>
              <%= parts[2] %> (<%= parts[3] %>)<br>
              License: <%= parts[4] %>
            </td>
            <td>
              <%= parts[8] %><br>
              <%= parts[9] %>
            </td>
            <td><%= String.format("%.2f$", Double.parseDouble(parts[7])) %></td>
            <td>
              <span class="stock-in">Pending</span>
            </td>
            <td>
              <form action="${pageContext.request.contextPath}/ApproveBookingServlet" method="post" style="display: inline;">
                <input type="hidden" name="index" value="<%= index %>">
                <button type="submit" class="action-btn edit-btn">Complete Service</button>
              </form>
            </td>
          </tr>
          <%
                                }
                            }
                            index++;
                        }
                    }
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='8'>Error loading bookings: " + e.getMessage() + "</td></tr>");
            }
          %>
        </tbody>
      </table>
    </div>
  </div>

  <div class="dashboard-card">
    <h2>Completed Services</h2>
    <div class="table-container">
      <table>
        <thead>
          <tr>
            <th>User</th>
            <th>Booking ID</th>
            <th>Service</th>
            <th>Car Details</th>
            <th>Date & Time</th>
            <th>Price</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          <%
            try {
                String bookingsFilePath = "C:/Users/Dell/Desktop/tuneshift/data/bookings.txt";
                java.io.File bookingsFile = new java.io.File(bookingsFilePath);
                if (bookingsFile.exists()) {
                    try (java.io.BufferedReader br = new java.io.BufferedReader(new java.io.FileReader(bookingsFile))) {
                        String line;
                        while ((line = br.readLine()) != null) {
                            if (line.trim().isEmpty()) continue;
                            String[] parts = line.split("\\|");
                            if (parts.length >= 11) {
                                String status = parts[10];
                                // Only show completed bookings
                                if (status.equals("Completed")) {
          %>
          <tr>
            <td>
              <strong><%= parts[0] %></strong>
            </td>
            <td><%= parts[1] %></td>
            <td>
              <%= parts[6] %><br>
              <small>Service ID: <%= parts[5] %></small>
            </td>
            <td>
              <%= parts[2] %> (<%= parts[3] %>)<br>
              License: <%= parts[4] %>
            </td>
            <td>
              <%= parts[8] %><br>
              <%= parts[9] %>
            </td>
            <td><%= String.format("%.2f$", Double.parseDouble(parts[7])) %></td>
            <td>
              <span class="stock-out">Completed</span>
            </td>
          </tr>
          <%
                                }
                            }
                        }
                    }
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='7'>Error loading bookings: " + e.getMessage() + "</td></tr>");
            }
          %>
        </tbody>
      </table>
    </div>
  </div>

  <div class="dashboard-card">
    <h2>Recent User Feedback</h2>
    <div class="table-container">
      <table>
        <thead>
          <tr>
            <th>User</th>
            <th>Rating</th>
            <th>Feedback</th>
            <th>Date</th>
          </tr>
        </thead>
        <tbody>
          <%
            try {
                String feedbackFilePath = "C:/Users/Dell/Desktop/tuneshift/data/feedback.txt";
                java.io.File feedbackFile = new java.io.File(feedbackFilePath);
                if (feedbackFile.exists()) {
                    try (java.io.BufferedReader br = new java.io.BufferedReader(new java.io.FileReader(feedbackFile))) {
                        String line;
                        int count = 0;
                        while ((line = br.readLine()) != null && count < 5) { // Show only 5 most recent feedbacks
                            if (line.trim().isEmpty()) continue;
                            String[] parts = line.split("\\|");
                            if (parts.length >= 4) {
                                count++;
          %>
          <tr>
            <td>
              <strong><%= parts[0] %></strong>
            </td>
            <td>
              <div style="color: #FFD700;">
                <% for (int i = 0; i < Integer.parseInt(parts[1]); i++) { %>
                  <i class="fas fa-star"></i>
                <% } %>
              </div>
            </td>
            <td><%= parts[2] %></td>
            <td><%= parts[3] %></td>
          </tr>
          <%
                            }
                        }
                    }
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='4'>Error loading feedback: " + e.getMessage() + "</td></tr>");
            }
          %>
        </tbody>
      </table>
      <div style="text-align: center; padding: 15px;">
        <a href="admin-feedback.jsp" class="action-btn edit-btn" style="text-decoration: none;">View All Feedback</a>
      </div>
    </div>
  </div>
</div>
</body>
</html>