package com.car.tuneshift.servlets;

import com.car.tuneshift.models.User;
import com.car.tuneshift.models.Service;
import java.io.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/BookServiceServlet")
public class BookServiceServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        // Get form data
        String carInfo = request.getParameter("carId");
        String serviceId = request.getParameter("serviceId");
        String date = request.getParameter("date");
        String time = request.getParameter("time");

        // Parse car info
        String[] carParts = carInfo.split("\\|");
        if (carParts.length != 3) {
            request.setAttribute("errorMessage", "Invalid car information");
            request.getRequestDispatcher("/pages/book-service.jsp").forward(request, response);
            return;
        }

        String carModel = carParts[0];
        String carYear = carParts[1];
        String carPlate = carParts[2];

        // Get service details
        Service selectedService = getServiceById(serviceId);
        if (selectedService == null) {
            request.setAttribute("errorMessage", "Invalid service selected");
            request.getRequestDispatcher("/pages/book-service.jsp").forward(request, response);
            return;
        }

        // Generate booking ID (timestamp-based)
        String bookingId = generateBookingId();

        // Create a record in bookings.txt
        String bookingData = String.join("|",
                user.getUsername(),
                bookingId,
                carModel,
                carYear,
                carPlate,
                serviceId,
                selectedService.getServiceName(),
                selectedService.getPrice() + "",
                date,
                time,
                "Pending"  // Initial status
        );

        // Get the workspace root directory
        String workspaceRoot = System.getProperty("user.home") + "/Desktop/tuneshift";
        String dataDir = workspaceRoot + "/data";
        
        // Create data directory if it doesn't exist
        File dataDirFile = new File(dataDir);
        if (!dataDirFile.exists()) {
            dataDirFile.mkdirs();
        }

        String filePath = dataDir + File.separator + "bookings.txt";
        File bookingsFile = new File(filePath);

        // Create parent directories if they don't exist
        bookingsFile.getParentFile().mkdirs();

        // Append booking data to file
        try (PrintWriter writer = new PrintWriter(new FileWriter(bookingsFile, true))) {
            writer.println(bookingData);
        } catch (IOException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Failed to save booking. Please try again.");
            request.getRequestDispatcher("/pages/book-service.jsp").forward(request, response);
            return;
        }

        // Redirect to my-bookings page with success message
        session.setAttribute("successMessage", "Service booked successfully!");
        response.sendRedirect(request.getContextPath() + "/pages/my-bookings.jsp");
    }

    private String generateBookingId() {
        // Generate a unique booking ID based on timestamp
        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
        return "BK" + now.format(formatter);
    }

    private Service getServiceById(String serviceId) throws IOException {
        String workspaceRoot = System.getProperty("user.home") + "/Desktop/tuneshift";
        String dataDir = workspaceRoot + "/data";
        String servicesFilePath = dataDir + File.separator + "services.txt";
        
        try (BufferedReader reader = new BufferedReader(new FileReader(servicesFilePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                Service service = Service.fromFileString(line);
                if (service != null && service.getServiceId().equals(serviceId)) {
                    return service;
                }
            }
        }
        return null;
    }
}