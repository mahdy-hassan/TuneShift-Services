package com.car.tuneshift.servlets;

import com.car.tuneshift.models.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.regex.Pattern;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 1. Get form data
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // 2. Validate required fields
        if (fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            
            response.sendRedirect(request.getContextPath() + "/pages/register.jsp?error=emptyFields");
            return;
        }

        // 3. Validate email format
        Pattern emailPattern = Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");
        var emailMatcher = emailPattern.matcher(email);

        if (!emailMatcher.matches()) {
            response.sendRedirect(request.getContextPath() + "/pages/register.jsp?error=invalidEmail");
            return;
        }

        // 4. Create User object with all the details
        User newUser = new User(fullName, email, phone, username, password);

        // 5. Get the workspace root directory
        String workspaceRoot = System.getProperty("user.home") + "/Desktop/tuneshift";
        String dataDir = workspaceRoot + "/data";
        
        // Create data directory if it doesn't exist
        File dataDirFile = new File(dataDir);
        if (!dataDirFile.exists()) {
            dataDirFile.mkdirs();
        }

        // 6. Write user data to file
        String filePath = dataDir + File.separator + "users.txt";
        try (FileWriter fw = new FileWriter(filePath, true)) {
            fw.write(newUser.toFileString() + "\n");
        } catch (IOException e) {
            response.sendRedirect(request.getContextPath() + "/pages/register.jsp?error=io");
            return;
        }

        // 7. Redirect to login page after successful registration
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp?success=Registration successful, please log in.");
    }
}
