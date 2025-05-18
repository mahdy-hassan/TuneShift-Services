<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.car.tuneshift.models.User" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add New Car</title>
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
        }
        body {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            color: var(--dark);
            padding-top: 60px;
            font-family: 'Poppins', sans-serif;
            margin: 0;
            min-height: 100vh;
        }
        .container {
            max-width: 1100px;
            margin: 0 auto;
            padding: 20px;
        }
        .section-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 2px solid var(--border);
            position: relative;
        }
        .section-title::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 100px;
            height: 2px;
            background: var(--primary);
        }
        .section-title h2 {
            font-size: 28px;
            font-weight: 700;
            color: var(--dark);
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .section-title h2 i {
            color: var(--primary);
        }
        .btn {
            padding: 12px 24px;
            border-radius: 8px;
            text-decoration: none;
            color: white;
            font-weight: 500;
            border: none;
            cursor: pointer;
            background: var(--primary);
            transition: all 0.3s ease;
            font-size: 15px;
            margin-right: 10px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 2px 4px rgba(255, 107, 53, 0.2);
        }
        .btn:hover {
            background: var(--primary-light);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(255, 107, 53, 0.3);
        }
        .form-container {
            background: white;
            border: 1px solid var(--border);
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            padding: 40px;
            max-width: 600px;
            margin: 20px auto;
            transition: transform 0.3s ease;
        }
        .form-container:hover {
            transform: translateY(-5px);
        }
        .form-group {
            margin-bottom: 25px;
            position: relative;
        }
        .form-group label {
            display: block;
            margin-bottom: 10px;
            font-weight: 500;
            color: var(--dark);
            font-size: 16px;
            transition: color 0.3s ease;
        }
        .form-group input {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid var(--border);
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }
        .form-group input:focus {
            outline: none;
            border-color: var(--primary);
            background: white;
            box-shadow: 0 0 0 4px rgba(255, 107, 53, 0.1);
        }
        .form-group input:hover {
            border-color: var(--primary-light);
        }
        .error-message {
            color: var(--danger);
            margin-bottom: 25px;
            padding: 15px;
            background: #fff5f5;
            border-left: 4px solid var(--danger);
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: slideIn 0.3s ease;
        }
        .back-link {
            margin-bottom: 25px;
            display: inline-block;
        }
        .back-link .btn {
            background: #6c757d;
            box-shadow: 0 2px 4px rgba(108, 117, 125, 0.2);
        }
        .back-link .btn:hover {
            background: #5a6268;
            box-shadow: 0 4px 8px rgba(108, 117, 125, 0.3);
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
        .form-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .form-header i {
            font-size: 48px;
            color: var(--primary);
            margin-bottom: 15px;
        }
        .form-header p {
            color: #666;
            margin-top: 10px;
        }
        .submit-btn {
            width: 100%;
            padding: 14px;
            font-size: 16px;
            margin-top: 10px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        .submit-btn:hover {
            background: var(--primary-light);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(255, 107, 53, 0.3);
        }
        .submit-btn i {
            font-size: 18px;
        }
    </style>
</head>
<body>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }

    String error = request.getParameter("error");
%>

<div class="container">
    <div class="back-link">
        <a href="<%= request.getContextPath() %>/pages/my-cars.jsp" class="btn">
            <i class="fas fa-arrow-left"></i> Back to My Cars
        </a>
    </div>
    
    <div class="section-title">
        <h2><i class="fas fa-car"></i> Add New Car</h2>
    </div>

    <div class="form-container">
        <div class="form-header">
            <i class="fas fa-car-side"></i>
            <h3>Add Your Vehicle Details</h3>
            <p>Fill in the information below to add your car to your profile</p>
        </div>

        <% if (error != null) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i>
                <span><%= error %></span>
            </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/AddCarServlet" method="post">
            <div class="form-group">
                <label for="carModel">
                    <i class="fas fa-car"></i> Car Model
                </label>
                <input type="text" id="carModel" name="carModel" required 
                       placeholder="Enter your car model">
            </div>

            <div class="form-group">
                <label for="year">
                    <i class="fas fa-calendar"></i> Year
                </label>
                <input type="number" id="year" name="year" required 
                       placeholder="Enter manufacturing year"
                       min="1900" max="<%= java.time.Year.now().getValue() %>">
            </div>

            <div class="form-group">
                <label for="licensePlate">
                    <i class="fas fa-id-card"></i> License Plate
                </label>
                <input type="text" id="licensePlate" name="licensePlate" required 
                       placeholder="Enter license plate number">
            </div>

            <button type="submit" class="submit-btn">
                <i class="fas fa-plus"></i> Add Car
            </button>
        </form>
    </div>
</div>
</body>
</html>
