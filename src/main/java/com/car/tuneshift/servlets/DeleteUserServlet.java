package com.car.tuneshift.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        if (username == null || username.trim().isEmpty()) {
            response.sendRedirect("pages/admin-users.jsp?error=Invalid username");
            return;
        }

        // Delete user from users.txt
        String usersFilePath = "C:/Users/Dell/Desktop/tuneshift/data/users.txt";
        List<String> users = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(usersFilePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 4 && !parts[3].equals(username)) {
                    users.add(line);
                }
            }
        }

        try (PrintWriter pw = new PrintWriter(new FileWriter(usersFilePath))) {
            for (String user : users) {
                pw.println(user);
            }
        }

        // Delete user's cars from cars.txt
        String carsFilePath = "C:/Users/Dell/Desktop/tuneshift/data/cars.txt";
        List<String> cars = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(carsFilePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split("\\|");
                if (parts.length >= 4 && !parts[0].equals(username)) {
                    cars.add(line);
                }
            }
        }

        try (PrintWriter pw = new PrintWriter(new FileWriter(carsFilePath))) {
            for (String car : cars) {
                pw.println(car);
            }
        }

        // Delete user's bookings from bookings.txt
        String bookingsFilePath = "C:/Users/Dell/Desktop/tuneshift/data/bookings.txt";
        List<String> bookings = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(bookingsFilePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split("\\|");
                if (parts.length >= 11 && !parts[0].equals(username)) {
                    bookings.add(line);
                }
            }
        }

        try (PrintWriter pw = new PrintWriter(new FileWriter(bookingsFilePath))) {
            for (String booking : bookings) {
                pw.println(booking);
            }
        }

        response.sendRedirect("pages/admin-users.jsp?success=User deleted successfully");
    }
}