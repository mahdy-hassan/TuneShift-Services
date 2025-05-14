<%@ page import="com.car.tuneshift.models.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Car</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #FF6B35;
            --primary-light: #ff8c5a;
            --dark: #2A2A2A;
            --light: #F8F9FA;
            --border: #e0e0e0;
            --danger: #dc3545;
            --success: #28a745;
            --info: #3498db;
            --warning: #ffc107;
        }
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            min-height: 100vh;
        }
        .container {
            max-width: 600px;
            margin: 40px auto;
            padding: 40px;
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        .page-header {
            text-align: center;
            margin-bottom: 40px;
        }
        .page-header h1 {
            color: var(--dark);
            font-size: 32px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }
        .page-header h1 i {
            color: var(--primary);
        }
        .form-group {
            margin-bottom: 24px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            color: var(--dark);
            font-weight: 500;
            font-size: 15px;
        }
        input[type="text"] {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid var(--border);
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s ease;
            box-sizing: border-box;
        }
        input[type="text"]:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(255, 107, 53, 0.1);
        }
        .btn {
            padding: 12px 24px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            font-size: 15px;
            border: none;
            cursor: pointer;
        }
        .btn-primary {
            background: var(--primary);
            color: white;
            box-shadow: 0 2px 4px rgba(255, 107, 53, 0.2);
        }
        .btn-primary:hover {
            background: var(--primary-light);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(255, 107, 53, 0.3);
        }
        .btn-secondary {
            background: var(--light);
            color: var(--dark);
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .btn-secondary:hover {
            background: #e9ecef;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 16px;
            margin-bottom: 20px;
            border-radius: 8px;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            animation: slideIn 0.3s ease;
        }
        .nav-links {
            margin-top: 30px;
            text-align: center;
            display: flex;
            justify-content: center;
            gap: 20px;
        }
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
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
    String oldCarModel = request.getParameter("carModel");
    String oldYear = request.getParameter("year");
    String oldLicensePlate = request.getParameter("licensePlate");

    if (oldCarModel == null || oldYear == null || oldLicensePlate == null) {
%>
<div class="container">
    <div class="error-message">
        <i class="fas fa-exclamation-circle"></i>
        Invalid car data. Please go back and try again.
    </div>
    <div class="nav-links">
        <a href="<%= request.getContextPath() %>/pages/my-cars.jsp" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Back to My Cars
        </a>
    </div>
</div>
<%
        return;
    }
%>

<div class="container">
    <div class="page-header">
        <h1><i class="fas fa-car"></i> Edit Car</h1>
    </div>

    <form action="<%= request.getContextPath() %>/UpdateCarServlet" method="post">
        <!-- Hidden fields to track old values -->
        <input type="hidden" name="oldCarModel" value="<%= oldCarModel %>">
        <input type="hidden" name="oldYear" value="<%= oldYear %>">
        <input type="hidden" name="oldLicensePlate" value="<%= oldLicensePlate %>">

        <div class="form-group">
            <label for="carModel">Car Model:</label>
            <input type="text" id="carModel" name="carModel" value="<%= oldCarModel %>" required>
        </div>

        <div class="form-group">
            <label for="year">Year:</label>
            <input type="text" id="year" name="year" value="<%= oldYear %>" required>
        </div>

        <div class="form-group">
            <label for="licensePlate">License Plate:</label>
            <input type="text" id="licensePlate" name="licensePlate" value="<%= oldLicensePlate %>" required>
        </div>

        <div class="nav-links">
            <button type="submit" class="btn btn-primary">
                <i class="fas fa-save"></i> Update Car
            </button>
            <a href="<%= request.getContextPath() %>/pages/my-cars.jsp" class="btn btn-secondary">
                <i class="fas fa-times"></i> Cancel
            </a>
        </div>
    </form>
</div>

</body>
</html>
