<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.car.tuneshift.models.User" %>
<%@ page import="com.car.tuneshift.models.ServiceHistory" %>
<%@ page import="com.car.tuneshift.managers.ServiceHistoryManager" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.FileReader" %>
<%@ page import="java.io.File" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Profile</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #FF6B35;
            --primary-light: #ff8c5a;
            --dark: #2A2A2A;
            --light: #F8F9FA;
            --border: #e0e0e0;
            --success: #28a745;
            --danger: #dc3545;
            --warning: #ffc107;
            --info: #17a2b8;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background: var(--light);
            color: var(--dark);
            padding-top: 80px;
        }

        /* Fixed Navigation */
        .navbar {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            background: white;
            padding: 1rem 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            z-index: 1000;
        }

        .nav-brand {
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }

        .logo {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .logo-icon {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 45px;
            height: 45px;
            background: linear-gradient(135deg, var(--primary), #ff8c5a);
            border-radius: 12px;
            position: relative;
            overflow: hidden;
            font-family: 'Arial', sans-serif;
            font-weight: bold;
            box-shadow: 0 4px 15px rgba(255, 107, 53, 0.25);
        }

        .logo-icon::before {
            content: '';
            position: absolute;
            width: 100%;
            height: 100%;
            background: linear-gradient(45deg, transparent 48%, rgba(255,255,255,0.3) 50%, transparent 52%);
            animation: shine 3s infinite;
        }

        .logo-icon i {
            color: white;
            font-size: 1.4rem;
            position: relative;
            transform: translateY(-1px);
        }

        .logo-icon i::before {
            content: 'TS';
            font-style: normal;
            font-weight: 900;
            letter-spacing: -1px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.15);
        }

        .logo-icon i::after {
            content: '\f013';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            position: absolute;
            font-size: 0.9rem;
            bottom: -2px;
            right: -2px;
            color: rgba(255,255,255,0.95);
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
            animation: spin 10s linear infinite;
        }

        .logo-text {
            position: relative;
            font-weight: 800;
            letter-spacing: 0.5px;
            background: linear-gradient(135deg, var(--primary), #ff8c5a);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
        }

        .logo-text::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 100%;
            height: 2px;
            background: linear-gradient(90deg, var(--primary), #ff8c5a);
            transform: scaleX(0);
            transform-origin: right;
            transition: transform 0.3s ease;
        }

        .logo:hover .logo-text::after {
            transform: scaleX(1);
            transform-origin: left;
        }

        @keyframes shine {
            0% {
                transform: translateX(-100%) rotate(45deg);
            }
            100% {
                transform: translateX(100%) rotate(45deg);
            }
        }

        @keyframes spin {
            from {
                transform: rotate(0deg);
            }
            to {
                transform: rotate(360deg);
            }
        }

        .user-info {
            display: flex;
            flex-direction: column;
            position: relative;
            padding-left: 15px;
        }

        .user-info::before {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            transform: translateY(-50%);
            height: 70%;
            width: 2px;
            background: var(--border);
        }

        .welcome-text {
            font-size: 0.85rem;
            color: #666;
            margin-bottom: 2px;
        }

        .profile-name {
            font-weight: 600;
            color: var(--dark);
            font-size: 1.1rem;
        }

        .profile-email {
            display: none;
        }

        .nav-items {
            display: flex;
            align-items: center;
            gap: 2rem;
        }

        .nav-link {
            text-decoration: none;
            color: var(--dark);
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .nav-link:hover {
            color: var(--primary);
        }

        /* User Dropdown */
        .user-menu {
            position: relative;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--primary);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: transform 0.3s ease;
            font-weight: 600;
        }

        .user-avatar:hover {
            transform: scale(1.1);
        }

        .dropdown-menu {
            position: absolute;
            right: 0;
            top: 120%;
            background: white;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            min-width: 200px;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
            z-index: 1001;
        }

        .dropdown-menu.show {
            opacity: 1;
            visibility: visible;
            top: 100%;
        }

        .dropdown-header {
            padding: 1rem;
            border-bottom: 1px solid var(--border);
        }

        .dropdown-item {
            padding: 0.75rem 1.5rem;
            color: var(--dark);
            text-decoration: none;
            display: block;
            transition: all 0.3s ease;
        }

        .dropdown-item:hover {
            background: var(--light);
            color: var(--primary);
        }

        /* Existing Content Styles */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .section {
            background-color: white;
            border-radius: 16px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }

        .section-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid var(--border);
        }

        .section-title h2 {
            font-size: 20px;
            font-weight: 600;
            color: var(--dark);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title h2 i {
            color: var(--primary);
        }

        .btn {
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            color: white;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: none;
            cursor: pointer;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .btn-primary {
            background: var(--primary);
        }

        .btn-primary:hover {
            background: var(--primary-light);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(255, 107, 53, 0.2);
        }

        .btn-secondary {
            background: #6c757d;
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(108, 117, 125, 0.2);
        }

        .btn-sm {
            padding: 8px 16px;
            font-size: 14px;
        }

        .car-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }

        .car-card {
            border: 1px solid var(--border);
            border-radius: 12px;
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            background: white;
        }

        .car-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 24px rgba(0,0,0,0.12);
        }

        .car-header {
            background: var(--primary);
            color: white;
            padding: 18px;
            font-weight: 600;
            font-size: 18px;
            letter-spacing: 0.5px;
        }

        .car-body {
            padding: 20px;
        }

        .car-info {
            margin-bottom: 10px;
        }

        .car-info-item {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid var(--border);
            transition: background-color 0.2s ease;
        }

        .car-info-item:hover {
            background-color: var(--light);
            padding-left: 8px;
            padding-right: 8px;
            border-radius: 6px;
        }

        .car-info-label {
            font-weight: 500;
            color: #666;
        }

        .car-info-value {
            font-weight: 600;
            color: var(--dark);
        }

        .car-actions {
            display: flex;
            justify-content: space-between;
            margin-top: 15px;
        }

        .empty-state {
            text-align: center;
            padding: 50px 0;
            background: var(--light);
            border-radius: 12px;
            margin: 20px 0;
        }

        .empty-state i {
            font-size: 54px;
            color: #ccc;
            margin-bottom: 20px;
        }

        .empty-state h3 {
            font-size: 20px;
            margin-bottom: 15px;
            color: #666;
        }

        .empty-state p {
            color: #666;
            margin-bottom: 20px;
        }

        .bookings-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 10px;
        }

        .bookings-table th,
        .bookings-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid var(--border);
        }

        .bookings-table th {
            background-color: var(--light);
            font-weight: 600;
            color: var(--dark);
        }

        .bookings-table tr:hover {
            background-color: var(--light);
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }

        .status-completed {
            background-color: #d1e7dd;
            color: #0f5132;
        }

        .status-cancelled {
            background-color: #f8d7da;
            color: #842029;
        }

        .success-message, .error-message {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .success-message {
            background-color: #d1e7dd;
            color: #0f5132;
            border: 1px solid #badbcc;
        }

        .error-message {
            background-color: #f8d7da;
            color: #842029;
            border: 1px solid #f5c2c7;
        }

        /* Notification Button Styles */
        .notification-btn {
            position: fixed;
            top: 100px;
            right: 20px;
            background: var(--primary);
            color: white;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            transition: transform 0.3s ease;
            z-index: 999;
        }

        .notification-btn:hover {
            transform: scale(1.1);
        }

        .notification-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            background: var(--danger);
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: bold;
        }

        .notification-panel {
            position: fixed;
            top: 160px;
            right: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            width: 300px;
            max-height: 400px;
            overflow-y: auto;
            display: none;
            z-index: 998;
        }

        .notification-panel.show {
            display: block;
        }

        .notification-header {
            padding: 15px;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .notification-title {
            font-weight: 600;
            color: var(--dark);
        }

        .notification-clear {
            color: var(--primary);
            cursor: pointer;
            font-size: 14px;
        }

        .notification-item {
            padding: 15px;
            border-bottom: 1px solid var(--border);
            transition: background 0.3s ease;
        }

        .notification-item:hover {
            background: var(--light);
        }

        .notification-message {
            font-size: 14px;
            color: var(--dark);
            margin-bottom: 5px;
        }

        .notification-time {
            font-size: 12px;
            color: #666;
        }

        .notification-empty {
            padding: 20px;
            text-align: center;
            color: #666;
        }

        .nav-link.active {
            color: var(--secondary) !important;
            font-weight: bold;
            background: none !important;
            border-radius: 0;
            box-shadow: none;
            transition: color 0.2s;
        }

        .service-description {
            background: var(--light);
            border-left: 4px solid var(--primary);
            padding: 12px 16px;
            border-radius: 6px;
            margin-bottom: 12px;
            color: var(--dark);
            font-size: 15px;
            word-break: break-word;
        }

        /* Service History Section */
        .service-history {
            margin-top: 30px;
        }

        .service-history-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 15px;
        }

        .service-history-table th,
        .service-history-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid var(--border);
        }

        .service-history-table th {
            background-color: var(--light);
            font-weight: 600;
            color: var(--dark);
        }

        .service-history-table tr:hover {
            background-color: var(--light);
        }

        .service-status {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .status-completed {
            background-color: var(--success);
            color: white;
        }

        .status-pending {
            background-color: var(--warning);
            color: var(--dark);
        }

        /* Sort Controls */
        .sort-controls {
            display: flex;
            align-items: center;
            gap: 10px;
            background: var(--light);
            padding: 8px 16px;
            border-radius: 6px;
            border: 1px solid var(--border);
        }

        .sort-controls label {
            font-size: 14px;
            color: var(--dark);
            font-weight: 500;
            margin-right: 8px;
        }

        .form-control {
            padding: 6px 12px;
            border: 1px solid var(--border);
            border-radius: 4px;
            font-size: 14px;
            color: var(--dark);
            background: white;
            cursor: pointer;
            transition: all 0.3s ease;
            min-width: 140px;
        }

        .form-control:hover {
            border-color: var(--primary);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(255, 107, 53, 0.1);
        }

        .form-control option {
            padding: 8px;
        }

        /* Feedback Section Styles */
        .feedback-form {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
        }

        .star-rating {
            display: flex;
            flex-direction: row-reverse;
            justify-content: flex-end;
            gap: 5px;
            margin-bottom: 20px;
        }

        .star-rating input {
            display: none;
        }

        .star-rating label {
            cursor: pointer;
            font-size: 30px;
            color: #ddd;
            transition: color 0.2s ease;
        }

        .star-rating label:hover,
        .star-rating label:hover ~ label,
        .star-rating input:checked ~ label {
            color: #FFD700;
        }

        .feedback-textarea {
            width: 100%;
            min-height: 120px;
            padding: 12px;
            border: 1px solid var(--border);
            border-radius: 6px;
            margin-bottom: 20px;
            resize: vertical;
            font-family: inherit;
        }

        .feedback-textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(255, 107, 53, 0.1);
        }

        .feedback-submit {
            background: var(--primary);
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            transition: background 0.3s ease;
        }

        .feedback-submit:hover {
            background: #e65a2b;
        }

        .feedback-list {
            margin-top: 30px;
        }

        .feedback-item {
            background: white;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .feedback-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        .feedback-stars {
            color: #FFD700;
        }

        .feedback-date {
            color: #666;
            font-size: 0.9em;
        }

        .feedback-content {
            color: #333;
            line-height: 1.5;
        }
    </style>
</head>
<body>
<%! String initialSectionId = "carsSection"; %> <%-- Default section --%>
<% 
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }

    // Check for a 'section' parameter in the URL and set the initial section
    String requestedSection = request.getParameter("section");
    if (requestedSection != null && !requestedSection.trim().isEmpty()) {
        // Basic validation to ensure it's a valid section ID
        switch (requestedSection) {
            case "carsSection":
            case "servicesSection":
            case "bookingsSection":
            case "historySection":
            case "feedbackSection":
                initialSectionId = requestedSection;
                break;
            default:
                // If an invalid section is requested, default to carsSection
                initialSectionId = "carsSection";
        }
    }

    // Read success/error messages from URL parameters (optional, if not using session)
    // String successMessage = request.getParameter("success");
    // String errorMessage = request.getParameter("error");
    // If you switch to URL parameters, you might remove the session reading below

    // Check for completed services notifications and get user bookings
    List<String> notifications = new ArrayList<>();
    List<String[]> userBookings = new ArrayList<>();
    String bookingsFilePath = "C:\\Users\\Dell\\Desktop\\tuneshift\\data\\bookings.txt";
    File bookingsFile = new File(bookingsFilePath);

    if (bookingsFile.exists()) {
        try (BufferedReader br = new BufferedReader(new FileReader(bookingsFile))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split("\\|");
                if (parts.length >= 11) {
                    // Add to notifications if service is completed
                    if (parts[0].equals(user.getUsername()) && parts[10].equals("Completed")) {
                        String notification = "Your " + parts[6] + " service for " + parts[2] + " has been completed!";
                        notifications.add(notification);
                    }
                    // Add to user bookings
                    if (parts[0].equals(user.getUsername())) {
                        userBookings.add(parts);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Clear notifications from session after displaying them
    session.removeAttribute("notifications");
    session.setAttribute("notifications", notifications);

    String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) {
        out.println("<div class='container'><div class='success-message'>" + successMessage + "</div></div>");
        session.removeAttribute("successMessage");
    }

    String errorMessage = (String) session.getAttribute("errorMessage");
    if (errorMessage != null) {
        out.println("<div class='container'><div class='error-message'>" + errorMessage + "</div></div>");
        session.removeAttribute("errorMessage");
    }

    List<String[]> userCars = new ArrayList<>();
    String carsFilePath = "C:\\Users\\Dell\\Desktop\\tuneshift\\data\\cars.txt";
    File carsFile = new File(carsFilePath);

    if (carsFile.exists()) {
        try (BufferedReader br = new BufferedReader(new FileReader(carsFile))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] carData = line.split("\\|");
                if (carData.length == 4 && carData[0].equals(user.getUsername())) {
                    userCars.add(carData);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Read available services
    List<String[]> availableServices = new ArrayList<>();
    String servicesFilePath = "C:/Users/Dell/Desktop/tuneshift/data/services.txt";
    File servicesFile = new File(servicesFilePath);
    if (servicesFile.exists()) {
        try (BufferedReader br = new BufferedReader(new FileReader(servicesFile))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] serviceData = line.split("\\|");
                if (serviceData.length >= 5) {
                    availableServices.add(serviceData);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<!-- Fixed Navigation -->
<nav class="navbar">
    <div class="nav-brand">
        <a href="<%= request.getContextPath() %>/index.jsp" class="logo">
            <div class="logo-icon">
                <i></i>
            </div>
            <span class="logo-text">TuneShift</span>
        </a>
        <div class="user-info">
            <div class="welcome-text">Welcome back,</div>
            <div class="profile-name"><%= user.getFullName() %></div>
        </div>
    </div>

    <div class="nav-items">
        <a href="#" class="nav-link active" id="homeNavLink" onclick="showSection('carsSection')">Home</a>
        <a href="#" class="nav-link" id="servicesNavLink" onclick="showSection('servicesSection')">Services</a>
        <a href="#" class="nav-link" id="bookingsNavLink" onclick="showSection('bookingsSection')">My Bookings</a>
        <a href="#" class="nav-link" id="historyNavLink" onclick="showSection('historySection')">Service History</a>
        <a href="#" class="nav-link" id="feedbackNavLink" onclick="showSection('feedbackSection')">Feedback</a>

        <div class="user-menu">
            <div class="user-avatar" onclick="toggleMenu()">
                <%= user.getFullName().substring(0, 1).toUpperCase() %>
            </div>
            <div class="dropdown-menu" id="dropdownMenu">
                <div class="dropdown-header">
                    <div class="profile-name"><%= user.getFullName() %></div>
                    <div class="profile-email"><%= user.getEmail() %></div>
                </div>
                <a href="<%= request.getContextPath() %>/pages/edit-profile.jsp" class="dropdown-item">
                    <i class="fas fa-user-edit"></i> Edit Profile
                </a>
                <a href="<%= request.getContextPath() %>/LogoutServlet" class="dropdown-item">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>
    </div>
</nav>

<div class="container">
    <!-- My Cars Section -->
    <div class="section" id="carsSection">
        <div class="section-title">
            <h2><i class="fas fa-car"></i> My Cars</h2>
            <a href="<%= request.getContextPath() %>/pages/add-car.jsp" class="btn btn-primary btn-sm">
                <i class="fas fa-plus"></i> Add New Car
            </a>
        </div>

        <% if (userCars.isEmpty()) { %>
        <div class="empty-state">
            <i class="fas fa-car"></i>
            <h3>You haven't added any cars yet</h3>
            <p>Add your car to book services and manage maintenance</p>
            <a href="<%= request.getContextPath() %>/pages/add-car.jsp" class="btn btn-primary">
                Add Your First Car
            </a>
        </div>
        <% } else { %>
        <div class="car-grid">
            <% for (String[] car : userCars) { %>
            <div class="car-card">
                <div class="car-header">
                    <%= car[1] %>
                </div>
                <div class="car-body">
                    <div class="car-info">
                        <div class="car-info-item">
                            <span class="car-info-label">Year</span>
                            <span class="car-info-value"><%= car[2] %></span>
                        </div>
                        <div class="car-info-item">
                            <span class="car-info-label">License Plate</span>
                            <span class="car-info-value"><%= car[3] %></span>
                        </div>
                    </div>
                    <div class="car-actions">
                        <a href="<%= request.getContextPath() %>/pages/book-service.jsp?car=<%= car[1] %>&year=<%= car[2] %>&plate=<%= car[3] %>" class="btn btn-primary btn-sm">
                            <i class="fas fa-tools"></i> Book Service
                        </a>
                        <a href="<%= request.getContextPath() %>/pages/edit-car.jsp?carModel=<%= car[1] %>&year=<%= car[2] %>&licensePlate=<%= car[3] %>" class="btn btn-sm" style="background-color: #6c757d;">
                            <i class="fas fa-edit"></i> Edit
                        </a>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <div style="text-align: center; margin-top: 20px;">
            <a href="<%= request.getContextPath() %>/pages/my-cars.jsp" class="btn btn-sm" style="background-color: #6c757d;">
                <i class="fas fa-list"></i> Manage All Cars
            </a>
        </div>
        <% } %>
    </div>

    <!-- Recent Bookings Section -->
    <div class="section" id="bookingsSection" style="display: none;">
        <div class="section-title">
            <h2><i class="fas fa-calendar-check"></i> Recent Service Bookings</h2>
            <% if (!userCars.isEmpty()) { %>
            <a href="<%= request.getContextPath() %>/pages/book-service.jsp" class="btn btn-primary btn-sm">
                <i class="fas fa-plus"></i> Book New Service
            </a>
            <% } %>
        </div>

        <% if (userCars.isEmpty()) { %>
        <div class="empty-state">
            <i class="fas fa-calendar-times"></i>
            <h3>You need to add a car first</h3>
            <p>Add your car details before booking services</p>
        </div>
        <% } else if (userBookings.isEmpty()) { %>
        <div class="empty-state">
            <i class="fas fa-calendar-times"></i>
            <h3>No service bookings found</h3>
            <p>Book a service for your car to see it here</p>
            <a href="<%= request.getContextPath() %>/pages/book-service.jsp" class="btn btn-primary">
                Book Your First Service
            </a>
        </div>
        <% } else { %>
        <table class="bookings-table">
            <thead>
            <tr>
                <th>Car</th>
                <th>Service Name</th>
                <th>Price</th>
                <th>Date & Time</th>
                <th>Status</th>
            </tr>
            </thead>
            <tbody>
            <%
                int count = 0;
                for (String[] booking : userBookings) {
                    if (count >= 5) break;
                    count++;

                    String carDetails = booking[2];  // Car model
                    String serviceName = booking[6];  // Service name (was booking[7])
                    String price = booking[7];        // Service price (was booking[6])
                    String dateTime = booking[9] + " " + booking[8];  // Date and time
                    String status = booking[10];      // Status
            %>
            <tr>
                <td><%= carDetails %></td>
                <td><%= serviceName %></td>
                <td><%
                    try {
                        double p = Double.parseDouble(price);
                        out.print(String.format("%.2f$", p));
                    } catch (Exception e) {
                        out.print(price + "$" );
                    }
                %></td>
                <td><%= dateTime %></td>
                <td>
                    <span class="status-badge status-<%= status.toLowerCase() %>">
                        <%= status %>
                    </span>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <div style="text-align: center; margin-top: 20px;">
            <a href="<%= request.getContextPath() %>/pages/my-bookings.jsp" class="btn btn-sm" style="background-color: #6c757d;">
                <i class="fas fa-list"></i> View All Bookings
            </a>
        </div>
        <% } %>
    </div>

    <!-- Available Services Section -->
    <div class="section" id="servicesSection" style="display: none;">
        <div class="section-title">
            <h2><i class="fas fa-cogs"></i> Available Services</h2>
        </div>
        <% if (availableServices.isEmpty()) { %>
        <div class="empty-state">
            <i class="fas fa-tools"></i>
            <h3>No services available at the moment.</h3>
        </div>
        <% } else { %>
        <div class="car-grid">
            <% for (String[] service : availableServices) { %>
            <div class="car-card">
                <div class="car-header" style="background: var(--primary);">
                    <%= service[1] %>
                </div>
                <div class="car-body">
                    <div class="car-info">
                        <div class="service-description" style="background: #f8f9fa; border-left: 4px solid var(--primary); padding: 12px 16px; border-radius: 6px; margin-bottom: 12px; color: #333; font-size: 15px;">
                            <i class="fas fa-info-circle" style="color: var(--primary); margin-right: 6px;"></i>
                            <%= service[2] %>
                        </div>
                        <div class="car-info-item">
                            <span class="car-info-label">Price</span>
                            <span class="car-info-value" style="color:#27ae60; font-weight:bold;">
                                <%= String.format("%.2f$", Double.parseDouble(service[3])) %>
                            </span>
                        </div>
                        <div class="car-info-item">
                            <span class="car-info-label">Duration</span>
                            <span class="car-info-value"><%= service[4] %> min</span>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <% } %>
    </div>

    <!-- Service History Section -->
    <div class="section" id="historySection" style="display: none;">
        <div class="section-title">
            <h2><i class="fas fa-history"></i> Service History</h2>
            <div class="sort-controls">
                <label for="sortOrder">Sort by:</label>
                <select id="sortOrder" onchange="sortServiceHistory()" class="form-control">
                    <option value="desc">Newest First</option>
                    <option value="asc">Oldest First</option>
                </select>
            </div>
        </div>
        <table class="service-history-table">
            <thead>
                <tr>
                    <th>Date</th>
                    <th>Service</th>
                    <th>Car</th>
                    <th>License Plate</th>
                    <th>Price</th>
                    <th>Duration</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody id="serviceHistoryBody">
                <%
                    ServiceHistoryManager historyManager = new ServiceHistoryManager();
                    String username = user.getUsername();
                    LinkedList<ServiceHistory> userHistory = historyManager.getServiceHistoryByUsername(username);
                    // Sort by date (newest first by default)
                    historyManager.sortByDate(userHistory, false);
                    
                    if (userHistory.isEmpty()) {
                %>
                    <tr>
                        <td colspan="7" style="text-align: center; padding: 20px;">
                            <div class="empty-state">
                                <i class="fas fa-history"></i>
                                <h3>No service history found</h3>
                                <p>Your service history will appear here once you book services</p>
                            </div>
                        </td>
                    </tr>
                <% } else {
                    for (ServiceHistory record : userHistory) {
                %>
                <tr>
                    <td><%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(record.getServiceDate()) %></td>
                    <td><%= record.getServiceName() %></td>
                    <td><%= record.getCarModel() %></td>
                    <td><%= record.getLicensePlate() %></td>
                    <td>$<%= String.format("%.2f", record.getPrice()) %></td>
                    <td><%= record.getDuration() %> mins</td>
                    <td>
                        <span class="status-badge status-<%= record.getStatus().toLowerCase() %>">
                            <%= record.getStatus() %>
                        </span>
                    </td>
                </tr>
                <% }} %>
            </tbody>
        </table>
    </div>

    <!-- Feedback Section -->
    <div class="section" id="feedbackSection" style="display: none;">
        <div class="section-title">
            <h2><i class="fas fa-comment-alt"></i> Feedback</h2>
        </div>
        
        <div class="feedback-form">
            <form action="<%= request.getContextPath() %>/FeedbackServlet" method="POST">
                <div class="star-rating">
                    <input type="radio" id="star5" name="rating" value="5" required>
                    <label for="star5"><i class="fas fa-star"></i></label>
                    <input type="radio" id="star4" name="rating" value="4">
                    <label for="star4"><i class="fas fa-star"></i></label>
                    <input type="radio" id="star3" name="rating" value="3">
                    <label for="star3"><i class="fas fa-star"></i></label>
                    <input type="radio" id="star2" name="rating" value="2">
                    <label for="star2"><i class="fas fa-star"></i></label>
                    <input type="radio" id="star1" name="rating" value="1">
                    <label for="star1"><i class="fas fa-star"></i></label>
                </div>
                
                <textarea name="feedback" class="feedback-textarea" placeholder="Share your experience with us..." required></textarea>
                
                <button type="submit" class="feedback-submit">
                    <i class="fas fa-paper-plane"></i> Submit Feedback
                </button>
            </form>
        </div>

        <div class="feedback-list">
            <h3>Your Previous Feedback</h3>
            <%
                // Read feedback from file
                String feedbackFilePath = "C:\\Users\\Dell\\Desktop\\tuneshift\\data\\feedback.txt";
                File feedbackFile = new File(feedbackFilePath);
                List<String[]> userFeedback = new ArrayList<>();

                if (feedbackFile.exists()) {
                    try (BufferedReader br = new BufferedReader(new FileReader(feedbackFile))) {
                        String line;
                        while ((line = br.readLine()) != null) {
                            String[] feedbackData = line.split("\\|");
                            if (feedbackData.length >= 4 && feedbackData[0].equals(user.getUsername())) {
                                userFeedback.add(feedbackData);
                            }
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            %>

            <% if (userFeedback.isEmpty()) { %>
                <div class="empty-state">
                    <i class="fas fa-comment-slash"></i>
                    <h3>No feedback submitted yet</h3>
                    <p>Share your experience with us!</p>
                </div>
            <% } else { %>
                <% for (String[] feedback : userFeedback) { %>
                    <div class="feedback-item">
                        <div class="feedback-header">
                            <div class="feedback-stars">
                                <% for (int i = 0; i < Integer.parseInt(feedback[1]); i++) { %>
                                    <i class="fas fa-star"></i>
                                <% } %>
                            </div>
                            <div class="feedback-date">
                                <%= feedback[3] %>
                            </div>
                        </div>
                        <div class="feedback-content">
                            <%= feedback[2] %>
                        </div>
                    </div>
                <% } %>
            <% } %>
        </div>
    </div>
</div>

<!-- Notification Button -->
<div class="notification-btn" onclick="toggleNotifications()">
    <i class="fas fa-bell"></i>
    <% if (!notifications.isEmpty()) { %>
    <span class="notification-badge"><%= notifications.size() %></span>
    <% } %>
</div>

<!-- Notification Panel -->
<div class="notification-panel" id="notificationPanel">
    <div class="notification-header">
        <div class="notification-title">Notifications</div>
        <div class="notification-clear" onclick="clearNotifications()">Clear All</div>
    </div>
    <% if (notifications.isEmpty()) { %>
    <div class="notification-empty">
        <i class="fas fa-bell-slash"></i>
        <p>No new notifications</p>
    </div>
    <% } else { %>
        <% for (String notification : notifications) { %>
        <div class="notification-item">
            <div class="notification-message"><%= notification %></div>
            <div class="notification-time">Just now</div>
        </div>
        <% } %>
    <% } %>
</div>

<script>
    // Dropdown functionality
    function toggleMenu() {
        const menu = document.getElementById('dropdownMenu');
        menu.classList.toggle('show');
    }

    document.addEventListener('click', function(event) {
        const menu = document.getElementById('dropdownMenu');
        const avatar = document.querySelector('.user-avatar');
        if (!avatar.contains(event.target)) {
            menu.classList.remove('show');
        }
    });

    // Smooth scroll for navigation links
    document.querySelectorAll('.nav-link[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Notification functionality
    function toggleNotifications() {
        const panel = document.getElementById('notificationPanel');
        panel.classList.toggle('show');
    }

    function clearNotifications() {
        // Clear the notification panel
        const panel = document.getElementById('notificationPanel');
        panel.innerHTML = `
            <div class="notification-header">
                <div class="notification-title">Notifications</div>
                <div class="notification-clear" onclick="clearNotifications()">Clear All</div>
            </div>
            <div class="notification-empty">
                <i class="fas fa-bell-slash"></i>
                <p>No new notifications</p>
            </div>
        `;

        // Remove the notification badge
        const badge = document.querySelector('.notification-badge');
        if (badge) {
            badge.remove();
        }
    }

    // Close notification panel when clicking outside
    document.addEventListener('click', function(event) {
        const panel = document.getElementById('notificationPanel');
        const btn = document.querySelector('.notification-btn');
        if (!panel.contains(event.target) && !btn.contains(event.target)) {
            panel.classList.remove('show');
        }
    });

    // Function to show selected section and hide others
    function showSection(sectionId) {
        // Hide all sections
        document.getElementById('carsSection').style.display = 'none';
        document.getElementById('bookingsSection').style.display = 'none';
        document.getElementById('servicesSection').style.display = 'none';
        document.getElementById('historySection').style.display = 'none';
        document.getElementById('feedbackSection').style.display = 'none';
        
        // Show selected section
        document.getElementById(sectionId).style.display = 'block';
        
        // Update active state of nav links
        document.getElementById('homeNavLink').classList.remove('active');
        document.getElementById('servicesNavLink').classList.remove('active');
        document.getElementById('bookingsNavLink').classList.remove('active');
        document.getElementById('historyNavLink').classList.remove('active');
        document.getElementById('feedbackNavLink').classList.remove('active');
        
        // Add active class to clicked link
        if (sectionId === 'carsSection') {
            document.getElementById('homeNavLink').classList.add('active');
        } else if (sectionId === 'servicesSection') {
            document.getElementById('servicesNavLink').classList.add('active');
        } else if (sectionId === 'bookingsSection') {
            document.getElementById('bookingsNavLink').classList.add('active');
        } else if (sectionId === 'historySection') {
            document.getElementById('historyNavLink').classList.add('active');
        } else if (sectionId === 'feedbackSection') {
            document.getElementById('feedbackNavLink').classList.add('active');
        }
        
        // Scroll to top of the section
        document.getElementById(sectionId).scrollIntoView({ behavior: 'smooth', block: 'start' });
    }

    // Call showSection on page load based on initialSectionId
    document.addEventListener('DOMContentLoaded', function() {
        const initialSection = '<%= initialSectionId %>';
        showSection(initialSection);

        // Optional: Read messages from URL parameters and display them
        const urlParams = new URLSearchParams(window.location.search);
        const successMsg = urlParams.get('success');
        const errorMsg = urlParams.get('error');

        const containerDiv = document.querySelector('.container'); // Assuming messages should be in a container

        if (successMsg) {
            // Create and display success message div (similar to your existing logic)
            const successDiv = document.createElement('div');
            successDiv.classList.add('success-message');
            successDiv.innerHTML = successMsg; // Be cautious with user-provided content if not escaping
            if (containerDiv) { // Append to container if it exists
                 containerDiv.insertBefore(successDiv, containerDiv.firstChild); // Insert at the beginning
            } else { // Fallback if container is not found
                 document.body.insertBefore(successDiv, document.body.firstChild);
            }
             // Clean up URL to remove message parameter after displaying
             history.replaceState({}, document.title, window.location.pathname + window.location.search.replace(/([?&])success=[^&]*(&|$)/, '$1').replace(/[?&]$/, ''));
        }

        if (errorMsg) {
            // Create and display error message div
            const errorDiv = document.createElement('div');
            errorDiv.classList.add('error-message');
            errorDiv.innerHTML = errorMsg; // Be cautious with user-provided content if not escaping
             if (containerDiv) { // Append to container if it exists
                 containerDiv.insertBefore(errorDiv, containerDiv.firstChild); // Insert at the beginning
            } else { // Fallback if container is not found
                 document.body.insertBefore(errorDiv, document.body.firstChild);
            }
             // Clean up URL to remove message parameter after displaying
             history.replaceState({}, document.title, window.location.pathname + window.location.search.replace(/([?&])error=[^&]*(&|$)/, '$1').replace(/[?&]$/, ''));
        }
    });

    function sortServiceHistory() {
        const sortOrder = document.getElementById('sortOrder').value;
        const ascending = sortOrder === 'asc';
        
        // Get the table body
        const tbody = document.getElementById('serviceHistoryBody');
        const rows = Array.from(tbody.getElementsByTagName('tr'));
        
        // Skip the empty state row if it exists
        if (rows.length === 1 && rows[0].querySelector('.empty-state')) {
            return;
        }
        
        // Sort the rows
        rows.sort((a, b) => {
            const dateA = new Date(a.cells[0].textContent);
            const dateB = new Date(b.cells[0].textContent);
            return ascending ? dateA - dateB : dateB - dateA;
        });
        
        // Reorder the rows in the table
        rows.forEach(row => tbody.appendChild(row));
    }
</script>
</body>
</html>