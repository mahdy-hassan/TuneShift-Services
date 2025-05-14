<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Service</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f5f6fa;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 500px;
            margin: 40px auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }
        h1 {
            text-align: center;
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 6px;
            font-weight: 500;
        }
        input, textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }
        .btn {
            background: #3498db;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 10px;
        }
        .btn:hover {
            background: #217dbb;
        }
        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #3498db;
            text-decoration: none;
        }
        .error-message {
            color: #e74c3c;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
<div class="container">
    <a href="admin-services.jsp" class="back-link">&larr; Back to Manage Services</a>
    <h1>Add New Service</h1>
    <form action="<%= request.getContextPath() %>/AdminServiceServlet" method="post">
        <input type="hidden" name="action" value="add">
        <div class="form-group">
            <label for="serviceName">Service Name</label>
            <input type="text" id="serviceName" name="serviceName" required>
        </div>
        <div class="form-group">
            <label for="description">Description</label>
            <textarea id="description" name="description" required></textarea>
        </div>
        <div class="form-group">
            <label for="price">Price ($)</label>
            <input type="number" id="price" name="price" step="0.01" min="0" required>
        </div>
        <div class="form-group">
            <label for="duration">Duration (minutes)</label>
            <input type="number" id="duration" name="duration" min="1" required>
        </div>
        <button type="submit" class="btn">Add Service</button>
    </form>
</div>
</body>
</html> 