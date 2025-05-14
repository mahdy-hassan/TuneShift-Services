package com.car.tuneshift.servlets;

import com.car.tuneshift.models.Service;
import com.car.tuneshift.utils.ServiceUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.UUID;

@WebServlet("/AdminServiceServlet")
public class AdminServiceServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        String redirectUrl = request.getContextPath() + "/pages/admin-services.jsp";

        // Check if user is admin
        if (!isAdmin(session)) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        try {
            switch (action) {
                case "add":
                    handleAddService(request);
                    break;
                case "update":
                    handleUpdateService(request);
                    break;
                case "delete":
                    handleDeleteService(request);
                    break;
                default:
                    throw new IllegalArgumentException("Invalid action: " + action);
            }
            response.sendRedirect(redirectUrl + "?success=true");
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/pages/admin-services.jsp").forward(request, response);
        }
    }

    private boolean isAdmin(HttpSession session) {
        // Check if user is logged in and is admin
        return session.getAttribute("user") != null && 
               "admin".equals(session.getAttribute("userRole"));
    }

    private void handleAddService(HttpServletRequest request) {
        String serviceName = request.getParameter("serviceName");
        String description = request.getParameter("description");
        double price = Double.parseDouble(request.getParameter("price"));
        int duration = Integer.parseInt(request.getParameter("duration"));
        
        // Generate a unique service ID
        String serviceId = "SVC" + UUID.randomUUID().toString().substring(0, 8);
        
        Service newService = new Service(serviceId, serviceName, description, price, duration);
        ServiceUtil.saveService(newService);
    }

    private void handleUpdateService(HttpServletRequest request) {
        String serviceId = request.getParameter("serviceId");
        String serviceName = request.getParameter("serviceName");
        String description = request.getParameter("description");
        double price = Double.parseDouble(request.getParameter("price"));
        int duration = Integer.parseInt(request.getParameter("duration"));

        // Validate input
        if (serviceId == null || serviceId.trim().isEmpty()) {
            throw new IllegalArgumentException("Service ID is required");
        }
        if (serviceName == null || serviceName.trim().isEmpty()) {
            throw new IllegalArgumentException("Service name is required");
        }
        if (description == null || description.trim().isEmpty()) {
            throw new IllegalArgumentException("Description is required");
        }
        if (price <= 0) {
            throw new IllegalArgumentException("Price must be greater than 0");
        }
        if (duration <= 0) {
            throw new IllegalArgumentException("Duration must be greater than 0");
        }

        // Get existing service to ensure it exists
        Service existingService = ServiceUtil.getServiceById(serviceId);
        if (existingService == null) {
            throw new IllegalArgumentException("Service not found with ID: " + serviceId);
        }

        // Create updated service with the same ID
        Service updatedService = new Service(serviceId, serviceName, description, price, duration);
        
        // Update the service
        ServiceUtil.updateService(updatedService);
    }

    private void handleDeleteService(HttpServletRequest request) {
        String serviceId = request.getParameter("serviceId");
        ServiceUtil.deleteService(serviceId);
    }
} 