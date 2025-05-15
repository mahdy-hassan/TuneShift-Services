package com.car.tuneshift.servlets;

import com.car.tuneshift.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/DeleteAccountServlet")
public class DeleteAccountServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        // Get form data
        String confirmPassword = request.getParameter("confirmPassword");
        String confirmation = request.getParameter("confirmation");

        // Validate inputs
        if (!currentUser.getPassword().equals(confirmPassword)) {
            session.setAttribute("errorMessage", "Incorrect password. Please try again.");
            response.sendRedirect(request.getContextPath() + "/pages/delete-account.jsp");
            return;
        }

        if (!"DELETE".equals(confirmation)) {
            session.setAttribute("errorMessage", "Please type DELETE to confirm account deletion.");
            response.sendRedirect(request.getContextPath() + "/pages/delete-account.jsp");
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

        // Delete user from users.txt
        boolean userDeleted = deleteUserFromFile(currentUser.getUsername(), dataDir + File.separator + "users.txt");

        if (!userDeleted) {
            session.setAttribute("errorMessage", "Failed to delete user account. Please try again.");
            response.sendRedirect(request.getContextPath() + "/pages/delete-account.jsp");
            return;
        }

        // Delete user's cars from cars.txt
        deleteUserDataFromFile(currentUser.getUsername(), dataDir + File.separator + "cars.txt", 0);

        // Delete user's bookings from bookings.txt
        deleteUserDataFromFile(currentUser.getUsername(), dataDir + File.separator + "bookings.txt", 0);

        // Invalidate session
        session.invalidate();

        // Redirect to login page with success message
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp?success=Account deleted successfully");
    }

    private boolean deleteUserFromFile(String username, String filePath) {
        List<String> remainingUsers = new ArrayList<>();
        boolean userFound = false;

        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 5 && parts[3].equals(username)) {
                    userFound = true;
                } else {
                    remainingUsers.add(line);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }

        if (!userFound) {
            return false;
        }

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            for (String user : remainingUsers) {
                writer.write(user);
                writer.newLine();
            }
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }

        return true;
    }

    private void deleteUserDataFromFile(String username, String filePath, int usernameIndex) {
        List<String> remainingData = new ArrayList<>();

        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split("\\|");
                if (parts.length > usernameIndex && !parts[usernameIndex].equals(username)) {
                    remainingData.add(line);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
            return;
        }

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            for (String data : remainingData) {
                writer.write(data);
                writer.newLine();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}