package com.car.tuneshift.servlets;

import com.car.tuneshift.models.User;
import com.car.tuneshift.models.Car;

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

@WebServlet("/UpdateCarServlet")
public class UpdateCarServlet extends HttpServlet {

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
        String oldCarModel = request.getParameter("oldCarModel");
        String oldYear = request.getParameter("oldYear");
        String oldLicensePlate = request.getParameter("oldLicensePlate");

        String newCarModel = request.getParameter("carModel");
        String newYear = request.getParameter("year");
        String newLicensePlate = request.getParameter("licensePlate");

        // Validate input
        if (oldCarModel == null || oldYear == null || oldLicensePlate == null ||
                newCarModel == null || newYear == null || newLicensePlate == null ||
                newCarModel.trim().isEmpty() || newYear.trim().isEmpty() || newLicensePlate.trim().isEmpty()) {

            response.sendRedirect(request.getContextPath() + "/pages/edit-car.jsp?error=Invalid input");
            return;
        }

        // File path
        String carsFilePath = "C:\\Users\\Dell\\Desktop\\tuneshift\\data\\cars.txt";
        File carsFile = new File(carsFilePath);

        if (!carsFile.exists()) {
            response.sendRedirect(request.getContextPath() + "/pages/my-cars.jsp?error=Cars database not found");
            return;
        }

        // Read all cars into memory
        List<String> allCars = new ArrayList<>();
        boolean updated = false;

        try (BufferedReader reader = new BufferedReader(new FileReader(carsFile))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split("\\|");

                // Check if this is the car to update
                if (parts.length == 4 &&
                        parts[0].equals(user.getUsername()) &&
                        parts[1].equals(oldCarModel) &&
                        parts[2].equals(oldYear) &&
                        parts[3].equals(oldLicensePlate)) {

                    // Replace with updated car info
                    allCars.add(user.getUsername() + "|" + newCarModel + "|" + newYear + "|" + newLicensePlate);
                    updated = true;
                } else {
                    // Keep other cars as they are
                    allCars.add(line);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/pages/my-cars.jsp?error=Error reading car data");
            return;
        }

        // If car wasn't found
        if (!updated) {
            response.sendRedirect(request.getContextPath() + "/pages/my-cars.jsp?error=Car not found");
            return;
        }

        // Write all cars back to the file
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(carsFile))) {
            for (String car : allCars) {
                writer.write(car);
                writer.newLine();
            }
        } catch (IOException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/pages/my-cars.jsp?error=Error updating car data");
            return;
        }

        // Redirect back to my-cars page
        response.sendRedirect(request.getContextPath() + "/pages/my-cars.jsp?success=Car updated successfully");
    }
}