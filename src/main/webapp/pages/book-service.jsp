<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.car.tuneshift.models.User" %>
<%@ page import="com.car.tuneshift.models.Car" %>
<%@ page import="com.car.tuneshift.models.Service" %>
<%@ page import="com.car.tuneshift.utils.ServiceUtil" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Book Service</title>
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
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            transition: transform 0.3s ease;
        }
        .container:hover {
            transform: translateY(-5px);
        }
        h1 {
            color: var(--dark);
            font-size: 28px;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        h1 i {
            color: var(--primary);
        }
        .form-group {
            margin-bottom: 25px;
            position: relative;
        }
        label {
            display: block;
            margin-bottom: 10px;
            font-weight: 500;
            color: var(--dark);
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        select, input {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid var(--border);
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: #f8f9fa;
            font-family: 'Poppins', sans-serif;
        }
        select:focus, input:focus {
            outline: none;
            border-color: var(--primary);
            background: white;
            box-shadow: 0 0 0 4px rgba(255, 107, 53, 0.1);
        }
        select:hover, input:hover {
            border-color: var(--primary-light);
        }
        .btn {
            padding: 14px 28px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            font-size: 16px;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
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
        .service-info {
            margin-top: 20px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 12px;
            border-left: 4px solid var(--info);
            transition: all 0.3s ease;
            animation: slideIn 0.3s ease;
        }
        .service-info:hover {
            transform: translateX(5px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }
        .price {
            color: var(--success);
            font-weight: 600;
            font-size: 20px;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .duration {
            color: var(--dark);
            margin: 10px 0;
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
        }
        .description {
            color: #666;
            margin-top: 15px;
            line-height: 1.6;
            font-size: 15px;
        }
        .no-cars-message {
            text-align: center;
            padding: 40px;
            background: #f8f9fa;
            border-radius: 12px;
            margin-bottom: 30px;
            border: 2px dashed var(--border);
        }
        .no-cars-message i {
            font-size: 48px;
            color: var(--primary);
            margin-bottom: 20px;
        }
        .no-cars-message p {
            color: #666;
            margin-bottom: 20px;
            font-size: 16px;
        }
        .nav-links {
            margin-top: 30px;
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
    </style>
</head>
<body>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }

    // Get user's cars
    List<Car> userCars = new ArrayList<>();
    String carsFilePath = System.getProperty("user.home") + "/Desktop/tuneshift/data/cars.txt";
    File carsFile = new File(carsFilePath);

    if (carsFile.exists()) {
        try (BufferedReader br = new BufferedReader(new FileReader(carsFile))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split("\\|");
                if (parts.length == 4 && parts[0].equals(user.getUsername())) {
                    userCars.add(new Car(parts[0], parts[1], parts[2], parts[3]));
                }
            }
        }
    }

    // Get available services
    List<Service> services = ServiceUtil.getAllServices();
%>

<div class="container">
    <h1><i class="fas fa-tools"></i> Book a Service</h1>

    <% if (userCars.isEmpty()) { %>
        <div class="no-cars-message">
            <i class="fas fa-car"></i>
            <p>You need to add a car before booking a service.</p>
            <a href="<%= request.getContextPath() %>/pages/add-car.jsp" class="btn btn-primary">
                <i class="fas fa-plus"></i> Add Car
            </a>
        </div>
    <% } else { %>
        <form action="<%= request.getContextPath() %>/BookServiceServlet" method="post">
            <div class="form-group">
                <label for="carId">
                    <i class="fas fa-car"></i> Select Your Car
                </label>
                <select id="carId" name="carId" required>
                    <% for (Car car : userCars) { %>
                        <option value="<%= car.getModel() %>|<%= car.getYear() %>|<%= car.getPlateNumber() %>">
                            <%= car.getModel() %> (<%= car.getYear() %>) - <%= car.getPlateNumber() %>
                        </option>
                    <% } %>
                </select>
            </div>

            <div class="form-group">
                <label for="serviceId">
                    <i class="fas fa-wrench"></i> Select Service
                </label>
                <select id="serviceId" name="serviceId" required onchange="updateServiceInfo()">
                    <option value="">Select a service</option>
                    <% for (Service service : services) { %>
                        <option value="<%= service.getServiceId() %>" 
                                data-price="<%
                                    try {
                                        double price = Double.parseDouble(String.valueOf(service.getPrice()));
                                        out.print(String.format("%.2f$", price));
                                    } catch (Exception e) {
                                        out.print(service.getPrice() + "$" );
                                    }
                                %>"
                                data-duration="<%= service.getDuration() %>"
                                data-description="<%= service.getDescription() %>">
                            <%= service.getServiceName() %> - <%
                                try {
                                    double price = Double.parseDouble(String.valueOf(service.getPrice()));
                                    out.print(String.format("%.2f$", price));
                                } catch (Exception e) {
                                    out.print(service.getPrice() + "$" );
                                }
                            %>
                        </option>
                    <% } %>
                </select>
                <div id="serviceInfo" class="service-info" style="display: none;">
                    <div class="price">
                        <i class="fas fa-tag"></i>
                        Price: $<span id="selectedPrice">0.00</span>
                    </div>
                    <div class="duration">
                        <i class="fas fa-clock"></i>
                        Duration: <span id="selectedDuration">0</span> minutes
                    </div>
                    <div class="description" id="selectedDescription"></div>
                </div>
            </div>

            <div class="form-group">
                <label for="date">
                    <i class="fas fa-calendar"></i> Date
                </label>
                <input type="date" id="date" name="date" required>
            </div>

            <div class="form-group">
                <label for="time">
                    <i class="fas fa-clock"></i> Time
                </label>
                <input type="time" id="time" name="time" required>
            </div>

            <button type="submit" class="btn btn-primary">
                <i class="fas fa-check"></i> Book Service
            </button>
        </form>
    <% } %>

    <div class="nav-links">
        <a href="<%= request.getContextPath() %>/pages/services.jsp">
            <i class="fas fa-list"></i> View All Services
        </a>
        <a href="<%= request.getContextPath() %>/pages/profile.jsp">
            <i class="fas fa-user"></i> Back to Profile
        </a>
    </div>
</div>

<script>
    function updateServiceInfo() {
        const select = document.getElementById('serviceId');
        const serviceInfo = document.getElementById('serviceInfo');
        const selectedPrice = document.getElementById('selectedPrice');
        const selectedDuration = document.getElementById('selectedDuration');
        const selectedDescription = document.getElementById('selectedDescription');
        
        const selectedOption = select.options[select.selectedIndex];
        if (selectedOption.value) {
            serviceInfo.style.display = 'block';
            selectedPrice.textContent = selectedOption.getAttribute('data-price');
            selectedDuration.textContent = selectedOption.getAttribute('data-duration');
            selectedDescription.textContent = selectedOption.getAttribute('data-description');
        } else {
            serviceInfo.style.display = 'none';
        }
    }

    // Set minimum date to today
    document.getElementById('date').min = new Date().toISOString().split('T')[0];
</script>
</body>
</html>
</html>