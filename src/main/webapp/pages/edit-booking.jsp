<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.car.tuneshift.models.User" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.FileReader" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Booking</title>
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
            max-width: 800px;
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
        .form-group {
            margin-bottom: 24px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: var(--dark);
            font-weight: 500;
        }
        .form-control {
            width: 100%;
            padding: 12px;
            border: 1px solid var(--border);
            border-radius: 8px;
            font-size: 15px;
            transition: border-color 0.3s ease;
        }
        .form-control:focus {
            outline: none;
            border-color: var(--primary);
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
            cursor: pointer;
            border: none;
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
            background: #6c757d;
            color: white;
            box-shadow: 0 2px 4px rgba(108, 117, 125, 0.2);
        }
        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(108, 117, 125, 0.3);
        }
        .form-actions {
            display: flex;
            gap: 16px;
            justify-content: center;
            margin-top: 32px;
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
        }
    </style>
</head>
<body>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }

    String bookingId = request.getParameter("id");
    if (bookingId == null || bookingId.trim().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/pages/my-bookings.jsp");
        return;
    }

    // Read booking details
    String filePath = "C:\\Users\\Dell\\Desktop\\tuneshift\\data\\bookings.txt";
    File bookingsFile = new File(filePath);
    String[] bookingDetails = null;

    if (bookingsFile.exists()) {
        try (BufferedReader br = new BufferedReader(new FileReader(bookingsFile))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split("\\|");
                if (parts.length >= 11 && parts[0].equals(user.getUsername()) && parts[1].equals(bookingId)) {
                    bookingDetails = parts;
                    break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    if (bookingDetails == null) {
        response.sendRedirect(request.getContextPath() + "/pages/my-bookings.jsp");
        return;
    }

    // Read available services
    List<String[]> services = new ArrayList<>();
    File servicesFile = new File("C:\\Users\\Dell\\Desktop\\tuneshift\\data\\services.txt");
    if (servicesFile.exists()) {
        try (BufferedReader br = new BufferedReader(new FileReader(servicesFile))) {
            String line;
            while ((line = br.readLine()) != null) {
                services.add(line.split("\\|"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<div class="container">
    <div class="page-header">
        <h1><i class="fas fa-edit"></i> Edit Booking</h1>
    </div>

    <form action="<%= request.getContextPath() %>/UpdateBookingServlet" method="post">
        <input type="hidden" name="bookingId" value="<%= bookingId %>">
        
        <div class="form-group">
            <label for="car">Car</label>
            <input type="text" id="car" class="form-control" value="<%= bookingDetails[2] %> <%= bookingDetails[3] %> - <%= bookingDetails[4] %>" readonly>
        </div>

        <div class="form-group">
            <label for="service">Service</label>
            <select id="service" name="serviceId" class="form-control" required>
                <% for (String[] service : services) { %>
                    <option value="<%= service[0] %>" 
                            data-price="<%= String.format("%.2f", Double.parseDouble(service[3])) %>"
                            <%= service[0].equals(bookingDetails[5]) ? "selected" : "" %>>
                        <%= service[1] %> - <%= String.format("%.2f$", Double.parseDouble(service[3])) %>
                    </option>
                <% } %>
            </select>
        </div>

        <div class="form-group">
            <label for="date">Date</label>
            <input type="date" id="date" name="date" class="form-control" value="<%= bookingDetails[9].replaceAll("(\\d{4})-(\\d{2})-(\\d{2})", "$1-$2-$3") %>" required>
        </div>

        <div class="form-group">
            <label for="time">Time</label>
            <input type="time" id="time" name="time" class="form-control" value="<%= bookingDetails[8] %>" required>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn btn-primary">
                <i class="fas fa-save"></i> Update Booking
            </button>
            <a href="<%= request.getContextPath() %>/pages/my-bookings.jsp" class="btn btn-secondary">
                <i class="fas fa-times"></i> Cancel
            </a>
        </div>
    </form>
</div>

<script>
    // Add any necessary JavaScript for form validation or dynamic updates
    document.getElementById('service').addEventListener('change', function() {
        const selectedOption = this.options[this.selectedIndex];
        const price = selectedOption.getAttribute('data-price');
        // You can update price display if needed
    });
</script>

</body>
</html>
