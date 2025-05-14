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

@WebServlet("/AddCarServlet")
public class AddCarServlet extends HttpServlet {

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
        String carModel = request.getParameter("carModel");
        String year = request.getParameter("year");
        String licensePlate = request.getParameter("licensePlate");

        // Validate input
        if (carModel == null || year == null || licensePlate == null ||
                carModel.trim().isEmpty() || year.trim().isEmpty() || licensePlate.trim().isEmpty()) {

            response.sendRedirect(request.getContextPath() + "/pages/add-car.jsp?error=All fields are required");
            return;
        }

        // Get the workspace root directory
        String workspaceRoot = System.getProperty("user.home") + "/Desktop/tuneshift";
        String dataDir = workspaceRoot + "/data";
        
        // Create data directory if it doesn't exist
        File dataDirFile = new File(dataDir);
        if (!dataDirFile.exists()) {
            dataDirFile.mkdirs();
        }

        // Check if car with same license plate already exists
        String carsFilePath = dataDir + File.separator + "cars.txt";
        File carsFile = new File(carsFilePath);

        // Create the file if it doesn't exist
        if (!carsFile.exists()) {
            carsFile.createNewFile();
        }

        boolean carExists = false;

        try (BufferedReader reader = new BufferedReader(new FileReader(carsFile))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split("\\|");
                if (parts.length == 4 && parts[3].equals(licensePlate)) {
                    carExists = true;
                    break;
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/pages/add-car.jsp?error=Error checking car data");
            return;
        }

        if (carExists) {
            response.sendRedirect(request.getContextPath() + "/pages/add-car.jsp?error=A car with this license plate already exists");
            return;
        }

        // Add the new car
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(carsFile, true))) {
            writer.write(user.getUsername() + "|" + carModel + "|" + year + "|" + licensePlate);
            writer.newLine();
        } catch (IOException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/pages/add-car.jsp?error=Error saving car data");
            return;
        }

        // Redirect back to my-cars page
        response.sendRedirect(request.getContextPath() + "/pages/my-cars.jsp");
    }
}