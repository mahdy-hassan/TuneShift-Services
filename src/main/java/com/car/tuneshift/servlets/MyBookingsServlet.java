package com.car.tuneshift.servlets;

import com.car.tuneshift.models.Booking;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;

import java.io.*;
import java.util.*;

@WebServlet("/MyBookingsServlet")
public class MyBookingsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get the session object
        HttpSession session = request.getSession(false);

        // Get the username from session
        String username = (session != null) ? (String) session.getAttribute("username") : null;

        // If the user is not logged in, redirect to login page
        if (username == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        // Get the path to the bookings.txt file
        String dataDir = getServletContext().getRealPath("/data");
        File bookingsFile = new File(dataDir, "bookings.txt");

        List<Booking> userBookings = new ArrayList<>();

        // Read and filter bookings by username
        if (bookingsFile.exists()) {
            try (BufferedReader reader = new BufferedReader(new FileReader(bookingsFile))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    Booking booking = Booking.fromFileString(line);
                    if (booking != null && booking.getUsername().equals(username)) {
                        userBookings.add(booking);  // Only add the bookings of the logged-in user
                    }
                }
            } catch (IOException e) {
                // Handle error reading the file (optional logging here)
                e.printStackTrace();
            }
        }

        // Add the list of bookings to the request attribute
        request.setAttribute("bookings", userBookings);

        // Forward the request to the JSP to render the bookings
        request.getRequestDispatcher("/pages/my-bookings.jsp").forward(request, response);
    }
}
