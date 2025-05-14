package com.car.tuneshift.servlets;

import com.car.tuneshift.models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/DeleteCarServlet")
public class DeleteCarServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Redirect to login if not logged in
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        // Get parameters from the request
        String model = request.getParameter("model");
        String year = request.getParameter("year");
        String plate = request.getParameter("plate");

        // Validate input
        if (model == null || year == null || plate == null ||
                model.trim().isEmpty() || year.trim().isEmpty() || plate.trim().isEmpty()) {

            response.sendRedirect(request.getContextPath() + "/pages/my-cars.jsp?error=Invalid input");
            return;
        }

        // File path
        String carsFilePath = "C:\\Users\\Dell\\Desktop\\tuneshift\\data\\cars.txt";
        File carsFile = new File(carsFilePath);

        if (!carsFile.exists()) {
            response.sendRedirect(request.getContextPath() + "/pages/my-cars.jsp?error=Cars database not found");
            return;
        }

        // Read all cars into memory, excluding the one to be deleted
        List<String> remainingCars = new ArrayList<>();
        boolean carFound = false;

        try (BufferedReader reader = new BufferedReader(new FileReader(carsFile))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split("\\|");

                // Check if this is the car to delete
                if (parts.length == 4 &&
                        parts[0].equals(user.getUsername()) &&
                        parts[1].equals(model) &&
                        parts[2].equals(year) &&
                        parts[3].equals(plate)) {

                    carFound = true;
                    // Skip this car (don't add to remainingCars)
                } else {
                    // Keep other cars
                    remainingCars.add(line);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/pages/my-cars.jsp?error=Error reading car data");
            return;
        }

        // If car wasn't found
        if (!carFound) {
            response.sendRedirect(request.getContextPath() + "/pages/my-cars.jsp?error=Car not found");
            return;
        }

        // Write remaining cars back to the file
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(carsFile))) {
            for (String car : remainingCars) {
                writer.write(car);
                writer.newLine();
            }
        } catch (IOException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/pages/my-cars.jsp?error=Error updating car data");
            return;
        }

        // Redirect back to my-cars page
        response.sendRedirect(request.getContextPath() + "/pages/my-cars.jsp?success=Car deleted successfully");
    }
}