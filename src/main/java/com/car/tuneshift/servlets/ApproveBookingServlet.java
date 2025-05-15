package com.car.tuneshift.servlets;

import com.car.tuneshift.models.Booking;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.ServletException;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/ApproveBookingServlet")
public class ApproveBookingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        int index = Integer.parseInt(request.getParameter("index"));
        String bookingsFilePath = "C:/Users/Dell/Desktop/tuneshift/data/bookings.txt";
        File bookingsFile = new File(bookingsFilePath);
        List<String> bookings = new ArrayList<>();

        // Read all bookings from the file
        try (BufferedReader br = new BufferedReader(new FileReader(bookingsFile))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    bookings.add(line);
                }
            }
        }

        // Check if the index is valid
        if (index < 0 || index >= bookings.size()) {
            request.setAttribute("errorMessage", "Booking not found or invalid index!");
            request.getRequestDispatcher("/pages/admin-dashboard.jsp").forward(request, response);
            return;
        }

        // Update the booking status to Completed
        String[] parts = bookings.get(index).split("\\|");
        if (parts.length >= 11) {
            parts[10] = "Completed";
            bookings.set(index, String.join("|", parts));
        }

        // Save the updated bookings list back to the file
        try (FileWriter fw = new FileWriter(bookingsFile)) {
            for (String booking : bookings) {
                fw.write(booking + "\n");
            }
        }

        // Redirect back to admin dashboard
        response.sendRedirect("pages/admin-dashboard.jsp");
    }
} 