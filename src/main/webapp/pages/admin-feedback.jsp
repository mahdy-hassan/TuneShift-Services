<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - User Feedback</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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

        .star-rating {
            color: #FFD700;
        }

        .feedback-content {
            max-width: 400px;
            word-wrap: break-word;
        }

        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            text-align: center;
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
    </style>
</head>
<body>
<div class="sidebar">
    <h2>Admin Panel</h2>
    <a href="admin-dashboard.jsp" class="nav-item">Dashboard</a>
    <a href="admin-services.jsp" class="nav-item">Manage Services</a>
    <a href="admin-users.jsp" class="nav-item">Manage Users</a>
    <a href="admin-feedback.jsp" class="nav-item active">View Feedback</a>
    <a href="${pageContext.request.contextPath}/AdminLogoutServlet" class="nav-item" onclick="return confirm('Are you sure you want to log out?');">Logout</a>
</div>

<div class="main-content">
    <h1>User Feedback</h1>

    <%
        // Calculate feedback statistics
        int totalFeedback = 0;
        double averageRating = 0;

        try {
            String feedbackFilePath = "C:/Users/Dell/Desktop/tuneshift/data/feedback.txt";
            java.io.File feedbackFile = new java.io.File(feedbackFilePath);
            if (feedbackFile.exists()) {
                try (java.io.BufferedReader br = new java.io.BufferedReader(new java.io.FileReader(feedbackFile))) {
                    String line;
                    double totalRating = 0;
                    while ((line = br.readLine()) != null) {
                        if (line.trim().isEmpty()) continue;
                        String[] parts = line.split("\\|");
                        if (parts.length >= 4) {
                            totalFeedback++;
                            int rating = Integer.parseInt(parts[1]);
                            totalRating += rating;
                        }
                    }
                    if (totalFeedback > 0) {
                        averageRating = totalRating / totalFeedback;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>

    <div class="stats-container">
        <div class="stat-card">
            <div class="stat-value"><%= totalFeedback %></div>
            <div class="stat-label">Total Feedback</div>
        </div>
        <div class="stat-card">
            <div class="stat-value"><%= String.format("%.1f", averageRating) %></div>
            <div class="stat-label">Average Rating</div>
        </div>
        <div class="stat-card">
            <div class="stat-value" style="color: #FFD700;">
                <% for (int i = 0; i < Math.round(averageRating); i++) { %>
                    <i class="fas fa-star"></i>
                <% } %>
            </div>
            <div class="stat-label">Overall Rating</div>
        </div>
    </div>

    <div class="dashboard-card">
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
                                    while ((line = br.readLine()) != null) {
                                        if (line.trim().isEmpty()) continue;
                                        String[] parts = line.split("\\|");
                                        if (parts.length >= 4) {
                    %>
                    <tr>
                        <td>
                            <strong><%= parts[0] %></strong>
                        </td>
                        <td>
                            <div class="star-rating">
                                <% for (int i = 0; i < Integer.parseInt(parts[1]); i++) { %>
                                    <i class="fas fa-star"></i>
                                <% } %>
                            </div>
                        </td>
                        <td class="feedback-content"><%= parts[2] %></td>
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
        </div>
    </div>
</div>
</body>
</html> 