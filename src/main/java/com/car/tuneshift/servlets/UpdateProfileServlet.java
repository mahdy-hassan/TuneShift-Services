package com.car.tuneshift.servlets;

import com.car.tuneshift.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "UpdateProfileServlet", value = "/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        // Get form data
        String username = request.getParameter("username");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate inputs
        if (fullName == null || fullName.trim().isEmpty() ||
                email == null || email.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Full name and email are required.");
            response.sendRedirect(request.getContextPath() + "/pages/edit-profile.jsp");
            return;
        }

        // Check if passwords match if password field is not empty
        if (password != null && !password.isEmpty()) {
            if (!password.equals(confirmPassword)) {
                session.setAttribute("errorMessage", "Passwords do not match.");
                response.sendRedirect(request.getContextPath() + "/pages/edit-profile.jsp");
                return;
            }
        }

        // Update user object
        currentUser.setFullName(fullName);
        currentUser.setEmail(email);

        // Update password if provided
        if (password != null && !password.isEmpty()) {
            currentUser.setPassword(password);
        }

        // Get the workspace root directory
        String workspaceRoot = System.getProperty("user.home") + "/Desktop/tuneshift";
        String dataDir = workspaceRoot + "/data";
        
        // Create data directory if it doesn't exist
        File dataDirFile = new File(dataDir);
        if (!dataDirFile.exists()) {
            dataDirFile.mkdirs();
        }

        String filePath = dataDir + File.separator + "users.txt";
        List<String> updatedLines = new ArrayList<>();
        boolean userFound = false;

        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] userData = line.split(",");
                if (userData.length >= 5 && userData[3].equals(username)) {
                    // Replace with updated user data
                    updatedLines.add(currentUser.toFileString());
                    userFound = true;
                } else {
                    updatedLines.add(line);
                }
            }
        } catch (IOException e) {
            session.setAttribute("errorMessage", "Error reading user data: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/edit-profile.jsp");
            return;
        }

        if (!userFound) {
            session.setAttribute("errorMessage", "User not found in database.");
            response.sendRedirect(request.getContextPath() + "/pages/edit-profile.jsp");
            return;
        }

        // Write updated content back to file
        Path path = Paths.get(filePath);
        Path tempPath = Paths.get(filePath + ".tmp");

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(tempPath.toFile()))) {
            for (String line : updatedLines) {
                writer.write(line);
                writer.newLine();
            }
        } catch (IOException e) {
            session.setAttribute("errorMessage", "Error updating user data: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/edit-profile.jsp");
            return;
        }

        try {
            // Replace original file with updated file
            Files.move(tempPath, path, StandardCopyOption.REPLACE_EXISTING);

            // Update session with new user object
            session.setAttribute("user", currentUser);
            session.setAttribute("successMessage", "Profile updated successfully!");
            response.sendRedirect(request.getContextPath() + "/pages/profile.jsp");
        } catch (IOException e) {
            session.setAttribute("errorMessage", "Error saving user data: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/edit-profile.jsp");
        }
    }
}