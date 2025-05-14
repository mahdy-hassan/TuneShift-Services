<%@ page import="java.io.File, java.io.FileReader, java.io.BufferedReader, java.io.IOException" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.car.tuneshift.models.User, com.car.tuneshift.models.Car" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Cars</title>
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
            max-width: 1200px;
            margin: 0 auto;
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
        .btn-danger {
            background: var(--danger);
            color: white;
            box-shadow: 0 2px 4px rgba(220, 53, 69, 0.2);
        }
        .btn-danger:hover {
            background: #c82333;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(220, 53, 69, 0.3);
        }
        .car-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 30px;
            margin-top: 40px;
        }
        .car-card {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            position: relative;
        }
        .car-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.12);
        }
        .car-header {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-light) 100%);
            color: white;
            padding: 25px;
            position: relative;
            overflow: hidden;
        }
        .car-header::after {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 150px;
            height: 150px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            transform: translate(50%, -50%);
        }
        .car-model {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .car-model i {
            font-size: 20px;
        }
        .car-year {
            font-size: 15px;
            opacity: 0.9;
        }
        .car-body {
            padding: 25px;
        }
        .car-info {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 25px;
        }
        .info-item {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        .info-label {
            color: #666;
            font-size: 13px;
            font-weight: 500;
        }
        .info-value {
            color: var(--dark);
            font-size: 16px;
            font-weight: 600;
        }
        .car-actions {
            display: flex;
            gap: 12px;
        }
        .empty-state {
            text-align: center;
            padding: 80px 20px;
            background: var(--light);
            border-radius: 16px;
            margin: 40px 0;
        }
        .empty-state i {
            font-size: 64px;
            color: var(--primary);
            margin-bottom: 20px;
            opacity: 0.8;
        }
        .empty-state h3 {
            color: var(--dark);
            font-size: 24px;
            margin-bottom: 10px;
        }
        .empty-state p {
            color: #666;
            margin-bottom: 30px;
            font-size: 16px;
        }
        .nav-links {
            margin-top: 40px;
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
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }

    String carsFilePath = "C:\\Users\\Dell\\Desktop\\tuneshift\\data\\cars.txt";
    List<Car> userCars = new ArrayList<>();

    File carsFile = new File(carsFilePath);
    if (carsFile.exists()) {
        try (BufferedReader reader = new BufferedReader(new FileReader(carsFile))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split("\\|");
                if (parts.length == 4 && parts[0].equals(user.getUsername())) {
                    Car car = new Car(parts[0], parts[1], parts[2], parts[3]);
                    userCars.add(car);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
            out.println("<div class='error-message'><i class='fas fa-exclamation-circle'></i>Error reading car data. Please try again later.</div>");
        }
    }
%>

<div class="container">
    <div class="page-header">
        <h1><i class="fas fa-car"></i> My Cars</h1>
    </div>

    <div class="nav-links">
        <a href="<%= request.getContextPath() %>/pages/profile.jsp" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Back to Profile
        </a>
        <a href="<%= request.getContextPath() %>/pages/add-car.jsp" class="btn btn-primary">
            <i class="fas fa-plus"></i> Add New Car
        </a>
    </div>

    <% if (userCars.isEmpty()) { %>
        <div class="empty-state">
            <i class="fas fa-car"></i>
            <h3>No Cars Added Yet</h3>
            <p>Add your car to book services and manage maintenance</p>
            <a href="<%= request.getContextPath() %>/pages/add-car.jsp" class="btn btn-primary">
                <i class="fas fa-plus"></i> Add Your First Car
            </a>
        </div>
    <% } else { %>
        <div class="car-grid">
            <% for (Car car : userCars) { %>
                <div class="car-card">
                    <div class="car-header">
                        <div class="car-model">
                            <i class="fas fa-car"></i>
                            <%= car.getModel() %>
                        </div>
                        <div class="car-year">
                            <i class="fas fa-calendar"></i>
                            <%= car.getYear() %>
                        </div>
                    </div>
                    <div class="car-body">
                        <div class="car-info">
                            <div class="info-item">
                                <span class="info-label">License Plate</span>
                                <span class="info-value"><%= car.getPlateNumber() %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Status</span>
                                <span class="info-value" style="color: var(--success);">
                                    <i class="fas fa-check-circle"></i> Active
                                </span>
                            </div>
                        </div>
                        <div class="car-actions">
                            <a href="<%= request.getContextPath() %>/pages/edit-car.jsp?carModel=<%= URLEncoder.encode(car.getModel(), "UTF-8") %>&year=<%= URLEncoder.encode(car.getYear(), "UTF-8") %>&licensePlate=<%= URLEncoder.encode(car.getPlateNumber(), "UTF-8") %>" 
                               class="btn btn-secondary">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                            <form action="<%= request.getContextPath() %>/DeleteCarServlet" method="post" style="display: inline;">
                                <input type="hidden" name="model" value="<%= car.getModel() %>">
                                <input type="hidden" name="year" value="<%= car.getYear() %>">
                                <input type="hidden" name="plate" value="<%= car.getPlateNumber() %>">
                                <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this car?')">
                                    <i class="fas fa-trash"></i> Delete
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    <% } %>
</div>

</body>
</html>