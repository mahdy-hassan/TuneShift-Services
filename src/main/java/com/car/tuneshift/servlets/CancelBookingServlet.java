package com.car.tuneshift.servlets;

import com.car.tuneshift.models.User;
import java.io.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/CancelBookingServlet")
public class CancelBookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        // Get booking ID from request parameter
        String bookingId = request.getParameter("id");
        if (bookingId == null || bookingId.isEmpty()) {
            session.setAttribute("errorMessage", "Invalid booking ID");
            response.sendRedirect(request.getContextPath() + "/pages/my-bookings.jsp");
            return;
        }

        // Read all bookings from file
        String filePath = "C:\\Users\\Dell\\Desktop\\tuneshift\\data\\bookings.txt";
        File bookingsFile = new File(filePath);

        if (!bookingsFile.exists()) {
            session.setAttribute("errorMessage", "Booking records not found");
            response.sendRedirect(request.getContextPath() + "/pages/my-bookings.jsp");
            return;
        }

        List<String> allBookings = new ArrayList<>();
        boolean bookingFound = false;

        try (BufferedReader reader = new BufferedReader(new FileReader(bookingsFile))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split("\\|");

                // Check if this is the booking we want to cancel
                if (parts.length >= 11 && parts[0].equals(user.getUsername()) && parts[1].equals(bookingId)) {
                    // Ensure the booking belongs to the logged-in user and is still pending
                    if (!parts[10].equals("Pending")) {
                        session.setAttribute("errorMessage", "Only pending bookings can be cancelled");
                        response.sendRedirect(request.getContextPath() + "/pages/my-bookings.jsp");
                        return;
                    }

                    // Change status to cancelled
                    parts[10] = "Cancelled";
                    line = String.join("|", parts);
                    bookingFound = true;
                }

                allBookings.add(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Failed to process your request");
            response.sendRedirect(request.getContextPath() + "/pages/my-bookings.jsp");
            return;
        }

        if (!bookingFound) {
            session.setAttribute("errorMessage", "Booking not found or already cancelled");
            response.sendRedirect(request.getContextPath() + "/pages/my-bookings.jsp");
            return;
        }

        // Write updated bookings back to file
        try (PrintWriter writer = new PrintWriter(new FileWriter(bookingsFile))) {
            for (String booking : allBookings) {
                writer.println(booking);
            }
        } catch (IOException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Failed to cancel booking");
            response.sendRedirect(request.getContextPath() + "/pages/my-bookings.jsp");
            return;
        }

        // Redirect with success message
        session.setAttribute("successMessage", "Booking cancelled successfully");
        response.sendRedirect(request.getContextPath() + "/pages/my-bookings.jsp");
    }
}