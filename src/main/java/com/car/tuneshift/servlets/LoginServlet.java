package com.car.tuneshift.servlets;

import com.car.tuneshift.models.User; // Note: "models" package (with 's')
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        boolean isValid = false;
        User validatedUser = null;

        // Get the workspace root directory
        String workspaceRoot = System.getProperty("user.home") + "/Desktop/tuneshift";
        String dataDir = workspaceRoot + "/data";
        
        // Create data directory if it doesn't exist
        File dataDirFile = new File(dataDir);
        if (!dataDirFile.exists()) {
            dataDirFile.mkdirs();
        }

        String filePath = dataDir + File.separator + "users.txt";
        File usersFile = new File(filePath);

        // Check if file exists
        if (usersFile.exists()) {
            try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
                String line;
                while ((line = br.readLine()) != null) {
                    User user = User.fromFileString(line);
                    if (user != null && user.getUsername().equals(username) && user.getPassword().equals(password)) {
                        isValid = true;
                        validatedUser = user;
                        break;
                    }
                }
            }
        }

        // Handle login result
        if (isValid && validatedUser != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", validatedUser);
            response.sendRedirect(request.getContextPath() + "/pages/profile.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp?error=Invalid credentials");
        }
    }
}
