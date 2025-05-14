package com.car.tuneshift.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.*;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username").trim();
        String password = request.getParameter("password").trim();

        String dataDir = getServletContext().getRealPath("/data");
        File adminsFile = new File(dataDir, "admins.txt");

        try (BufferedReader br = new BufferedReader(new FileReader(adminsFile))) {
            String line;
            while ((line = br.readLine()) != null) {
                line = line.trim(); // Add line trimming
                if (line.isEmpty()) continue;

                String[] parts = line.split("\\|");
                if (parts.length == 2
                        && parts[0].trim().equals(username) // Add trim() here
                        && parts[1].trim().equals(password)) { // And here

                    HttpSession session = request.getSession();
                    session.setAttribute("user", username);
                    session.setAttribute("userRole", "admin");
                    response.sendRedirect(request.getContextPath() + "/pages/admin-dashboard.jsp");
                    return;
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/pages/admin-login.jsp?error=1");
    }
}