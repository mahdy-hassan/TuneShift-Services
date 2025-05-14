<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.car.tuneshift.models.User" %>
<%@ page import="com.car.tuneshift.models.Service" %>
<%@ page import="com.car.tuneshift.utils.ServiceUtil" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Our Services</title>
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
        .page-header p {
            color: #666;
            font-size: 16px;
            max-width: 600px;
            margin: 0 auto;
        }
        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 30px;
            margin-top: 30px;
        }
        .service-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            overflow: hidden;
            transition: all 0.3s ease;
        }
        .service-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.12);
        }
        .service-header {
            background: var(--primary);
            color: white;
            padding: 20px;
            text-align: center;
        }
        .service-header h3 {
            margin: 0;
            font-size: 20px;
            font-weight: 600;
        }
        .service-body {
            padding: 25px;
        }
        .service-price {
            color: var(--success);
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .service-duration {
            color: var(--dark);
            font-size: 16px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .service-description {
            color: #666;
            font-size: 15px;
            line-height: 1.6;
            margin-bottom: 20px;
        }
        .service-actions {
            display: flex;
            justify-content: center;
            gap: 10px;
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
        }
        .btn-primary {
            background: var(--primary);
            color: white;
            border: none;
            cursor: pointer;
            box-shadow: 0 2px 4px rgba(255, 107, 53, 0.2);
        }
        .btn-primary:hover {
            background: var(--primary-light);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(255, 107, 53, 0.3);
        }
        .nav-links {
            margin-top: 40px;
            text-align: center;
            display: flex;
            justify-content: center;
            gap: 20px;
        }
        .nav-links a {
            color: var(--info);
            text-decoration: none;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }
        .nav-links a:hover {
            color: var(--primary);
            transform: translateY(-2px);
        }
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .service-card {
            animation: fadeIn 0.5s ease forwards;
        }
        .service-card:nth-child(2) {
            animation-delay: 0.1s;
        }
        .service-card:nth-child(3) {
            animation-delay: 0.2s;
        }
        .service-card:nth-child(4) {
            animation-delay: 0.3s;
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

    List<Service> services = ServiceUtil.getAllServices();
%>

<div class="container">
    <div class="page-header">
        <h1><i class="fas fa-tools"></i> Our Services</h1>
        <p>Choose from our range of professional car maintenance and repair services</p>
    </div>

    <div class="services-grid">
        <% for (Service service : services) { %>
            <div class="service-card">
                <div class="service-header">
                    <h3><%= service.getServiceName() %></h3>
                </div>
                <div class="service-body">
                    <div class="service-price">
                        <i class="fas fa-tag"></i>
                        <% try {
                            double price = Double.parseDouble(String.valueOf(service.getPrice()));
                            out.print(String.format("%.2f$", price));
                        } catch (Exception e) {
                            out.print(service.getPrice() + "$");
                        } %>
                    </div>
                    <div class="service-duration">
                        <i class="fas fa-clock"></i>
                        <%= service.getDuration() %> minutes
                    </div>
                    <div class="service-description">
                        <%= service.getDescription() %>
                    </div>
                    <div class="service-actions">
                        <a href="<%= request.getContextPath() %>/pages/book-service.jsp" class="btn btn-primary">
                            <i class="fas fa-calendar-check"></i> Book Now
                        </a>
                    </div>
                </div>
            </div>
        <% } %>
    </div>

    <div class="nav-links">
        <a href="<%= request.getContextPath() %>/pages/profile.jsp">
            <i class="fas fa-user"></i> Back to Profile
        </a>
        <a href="<%= request.getContextPath() %>/pages/my-bookings.jsp">
            <i class="fas fa-calendar"></i> View My Bookings
        </a>
    </div>
</div>
</body>
</html> 