package com.tuneshift.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/UpdateBookingServlet")
public class UpdateBookingServlet extends HttpServlet {
    private static final String BOOKINGS_FILE = "C:\\Users\\Dell\\Desktop\\tuneshift\\data\\bookings.txt";
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm");

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Get form data
        String bookingId = request.getParameter("bookingId");
        String serviceId = request.getParameter("serviceId");
        String date = request.getParameter("date");
        String time = request.getParameter("time");

        // Validate inputs
        if (bookingId == null || serviceId == null || date == null || time == null) {
            session.setAttribute("errorMessage", "Please fill in all required fields.");
            response.sendRedirect(request.getContextPath() + "/pages/edit-booking.jsp?id=" + bookingId);
            return;
        }

        // Validate and format date
        try {
            LocalDate.parse(date, DATE_FORMATTER);
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Invalid date format.");
            response.sendRedirect(request.getContextPath() + "/pages/edit-booking.jsp?id=" + bookingId);
            return;
        }

        // Validate and format time
        try {
            LocalTime.parse(time, TIME_FORMATTER);
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Invalid time format.");
            response.sendRedirect(request.getContextPath() + "/pages/edit-booking.jsp?id=" + bookingId);
            return;
        }

        // Read all bookings
        List<String> bookings = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(BOOKINGS_FILE))) {
            String line;
            while ((line = br.readLine()) != null) {
                bookings.add(line);
            }
        }

        // Find and update the booking
        boolean updated = false;
        for (int i = 0; i < bookings.size(); i++) {
            String[] parts = bookings.get(i).split("\\|");
            if (parts.length >= 11 && parts[1].equals(bookingId)) {
                // Get service details
                String serviceName = "";
                String servicePrice = "";
                try (BufferedReader br = new BufferedReader(new FileReader("C:\\Users\\Dell\\Desktop\\tuneshift\\data\\services.txt"))) {
                    String line;
                    while ((line = br.readLine()) != null) {
                        String[] serviceParts = line.split("\\|");
                        if (serviceParts[0].equals(serviceId)) {
                            serviceName = serviceParts[1];
                            // Format price to always have 2 decimal places
                            servicePrice = String.format("%.2f", Double.parseDouble(serviceParts[3]));
                            break;
                        }
                    }
                }

                // Update the booking
                parts[5] = serviceId;  // service ID
                parts[6] = serviceName;  // service name
                parts[7] = servicePrice;  // service price
                parts[8] = time;  // time
                parts[9] = date;  // date
                
                bookings.set(i, String.join("|", parts));
                updated = true;
                break;
            }
        }

        if (updated) {
            // Write updated bookings back to file
            try (BufferedWriter bw = new BufferedWriter(new FileWriter(BOOKINGS_FILE))) {
                for (String booking : bookings) {
                    bw.write(booking);
                    bw.newLine();
                }
            }

            session.setAttribute("successMessage", "Booking updated successfully!");
            response.sendRedirect(request.getContextPath() + "/pages/my-bookings.jsp");
        } else {
            session.setAttribute("errorMessage", "Failed to update booking. Please try again.");
            response.sendRedirect(request.getContextPath() + "/pages/edit-booking.jsp?id=" + bookingId);
        }
    }
} 