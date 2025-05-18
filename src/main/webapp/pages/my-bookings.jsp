<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.car.tuneshift.models.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.FileReader" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Bookings</title>
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
        .bookings-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin: 20px 0;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
        }
        .bookings-table th {
            background: var(--primary);
            color: white;
            font-weight: 500;
            text-align: left;
            padding: 16px;
            font-size: 15px;
        }
        .bookings-table td {
            padding: 16px;
            border-bottom: 1px solid var(--border);
            font-size: 14px;
            color: var(--dark);
        }
        .bookings-table tr:last-child td {
            border-bottom: none;
        }
        .bookings-table tr:hover {
            background-color: #f8f9fa;
        }
        .status-pending {
            color: var(--warning);
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .status-completed {
            color: var(--success);
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .status-cancelled {
            color: var(--danger);
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .success-message {
            background-color: #d4edda;
            color: #155724;
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
        .no-bookings {
            text-align: center;
            padding: 60px 20px;
            background: #f8f9fa;
            border-radius: 12px;
            margin: 40px 0;
        }
        .no-bookings i {
            font-size: 48px;
            color: var(--primary);
            margin-bottom: 20px;
        }
        .no-bookings p {
            color: #666;
            margin-bottom: 20px;
            font-size: 16px;
        }
        .nav-links {
            margin-top: 40px;
            text-align: center;
            display: flex;
            justify-content: center;
            gap: 20px;
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
        .btn-danger {
            background: var(--danger);
            color: white;
            padding: 8px 16px;
            font-size: 13px;
            box-shadow: 0 2px 4px rgba(220, 53, 69, 0.2);
        }
        .btn-danger:hover {
            background: #c82333;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(220, 53, 69, 0.3);
        }
        .btn-warning {
            background: var(--warning);
            color: var(--dark);
            padding: 8px 16px;
            font-size: 13px;
            box-shadow: 0 2px 4px rgba(255, 193, 7, 0.2);
        }
        .btn-warning:hover {
            background: #e0a800;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(255, 193, 7, 0.3);
        }
        .action-buttons {
            display: flex;
            gap: 8px;
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
        .booking-id {
            font-family: monospace;
            background: #f8f9fa;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 13px;
        }
        .car-info {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }
        .car-model {
            font-weight: 500;
        }
        .car-details {
            color: #666;
            font-size: 13px;
        }
        .price {
            font-weight: 600;
            color: var(--success);
        }
        .date-time {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }
        .date {
            font-weight: 500;
        }
        .time {
            color: #666;
            font-size: 13px;
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

    // Display success message if available
    String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) {
        out.println("<div class='success-message'><i class='fas fa-check-circle'></i>" + successMessage + "</div>");
        session.removeAttribute("successMessage");
    }

    // Display error message if available
    String errorMessage = (String) session.getAttribute("errorMessage");
    if (errorMessage != null) {
        out.println("<div class='error-message'><i class='fas fa-exclamation-circle'></i>" + errorMessage + "</div>");
        session.removeAttribute("errorMessage");
    }

    // Class to store booking information
    class Booking {
        private String bookingId;
        private String carModel;
        private String carYear;
        private String carPlate;
        private String serviceType;
        private String servicePrice;
        private String serviceName;
        private String time;
        private String date;
        private String status;

        public Booking(String bookingId, String carModel, String carYear, String carPlate,
                       String serviceType, String servicePrice, String serviceName, String time, String date, String status) {
            this.bookingId = bookingId;
            this.carModel = carModel;
            this.carYear = carYear;
            this.carPlate = carPlate;
            this.serviceType = serviceType;
            this.servicePrice = servicePrice;
            this.serviceName = serviceName;
            this.time = time;
            this.date = date;
            this.status = status;
        }

        // Getters
        public String getBookingId() { return bookingId; }
        public String getCarModel() { return carModel; }
        public String getCarYear() { return carYear; }
        public String getCarPlate() { return carPlate; }
        public String getServiceType() { return serviceType; }
        public String getServicePrice() { return servicePrice; }
        public String getServiceName() { return serviceName; }
        public String getTime() { return time; }
        public String getDate() { return date; }
        public String getStatus() { return status; }
    }

    // Read bookings from file
    List<Booking> userBookings = new ArrayList<>();
    String filePath = "C:\\Users\\Dell\\Desktop\\tuneshift\\data\\bookings.txt";
    File bookingsFile = new File(filePath);

    if (bookingsFile.exists()) {
        try (BufferedReader br = new BufferedReader(new FileReader(bookingsFile))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split("\\|");
                if (parts.length >= 11 && parts[0].equals(user.getUsername())) {
                    userBookings.add(new Booking(
                            parts[1], // bookingId
                            parts[2], // carModel
                            parts[3], // carYear
                            parts[4], // carPlate
                            parts[5], // serviceType
                            parts[7], // servicePrice (was parts[6])
                            parts[6], // serviceName (was parts[7])
                            parts[8], // time
                            parts[9], // date
                            parts[10]  // status
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Sort bookings by date (newest first)
    Collections.sort(userBookings, new Comparator<Booking>() {
        @Override
        public int compare(Booking b1, Booking b2) {
            // First by status (Pending first, then Completed, then Cancelled)
            int statusCompare = getStatusPriority(b1.getStatus()) - getStatusPriority(b2.getStatus());
            if (statusCompare != 0) {
                return statusCompare;
            }

            // Then by date (latest first)
            return b2.getDate().compareTo(b1.getDate());
        }

        private int getStatusPriority(String status) {
            if ("Pending".equals(status)) return 0;
            if ("Completed".equals(status)) return 1;
            if ("Cancelled".equals(status)) return 2;
            return 3;
        }
    });
%>

<div class="container">
    <div class="page-header">
        <h1><i class="fas fa-calendar-check"></i> My Service Bookings</h1>
    </div>

<% if (userBookings.isEmpty()) { %>
<div class="no-bookings">
            <i class="fas fa-calendar-times"></i>
    <p>You have no service bookings yet.</p>
            <a href="<%= request.getContextPath() %>/pages/book-service.jsp" class="btn btn-primary">
                <i class="fas fa-plus"></i> Book a Service
            </a>
</div>
<% } else { %>
        <table class="bookings-table">
            <thead>
    <tr>
        <th>Booking ID</th>
        <th>Car</th>
                    <th>Service</th>
        <th>Price</th>
                    <th>Date & Time</th>
        <th>Status</th>
        <th>Action</th>
    </tr>
            </thead>
            <tbody>
    <% for (Booking booking : userBookings) { %>
    <tr>
                        <td><span class="booking-id"><%= booking.getBookingId() %></span></td>
                        <td>
                            <div class="car-info">
                                <span class="car-model"><%= booking.getCarModel() %></span>
                                <span class="car-details"><%= booking.getCarYear() %> - <%= booking.getCarPlate() %></span>
                            </div>
                        </td>
        <td><%= booking.getServiceName() %></td>
                        <td class="price"><%
            try {
                double price = Double.parseDouble(booking.getServicePrice());
                out.print(String.format("%.2f$", price));
            } catch (Exception e) {
                                out.print(booking.getServicePrice() + "$");
            }
        %></td>
                        <td>
                            <div class="date-time">
                                <span class="date"><%= booking.getDate() %></span>
                                <span class="time"><%= booking.getTime() %></span>
                            </div>
                        </td>
                        <td>
                            <% if (booking.getStatus().equals("Pending")) { %>
                                <span class="status-pending">
                                    <i class="fas fa-clock"></i> Pending
                                </span>
                            <% } else if (booking.getStatus().equals("Completed")) { %>
                                <span class="status-completed">
                                    <i class="fas fa-check-circle"></i> Completed
                                </span>
                            <% } else { %>
                                <span class="status-cancelled">
                                    <i class="fas fa-times-circle"></i> Cancelled
                                </span>
                            <% } %>
                        </td>
        <td>
            <% if (booking.getStatus().equals("Pending")) { %>
            <div class="action-buttons">
                <a href="<%= request.getContextPath() %>/pages/edit-booking.jsp?id=<%= booking.getBookingId() %>"
                   class="btn btn-warning">
                    <i class="fas fa-edit"></i> Edit
                </a>
                <a href="<%= request.getContextPath() %>/CancelBookingServlet?id=<%= booking.getBookingId() %>"
                   class="btn btn-danger"
                   onclick="return confirm('Are you sure you want to cancel this booking?')">
                    <i class="fas fa-times"></i> Cancel
                </a>
            </div>
            <% } %>
        </td>
    </tr>
    <% } %>
            </tbody>
</table>
<% } %>

<div class="nav-links">
        <a href="<%= request.getContextPath() %>/pages/book-service.jsp" class="btn btn-primary">
            <i class="fas fa-plus"></i> Book a Service
        </a>
        <a href="<%= request.getContextPath() %>/pages/profile.jsp" class="btn btn-primary">
            <i class="fas fa-user"></i> Back to Profile
        </a>
    </div>
</div>

</body>
</html>