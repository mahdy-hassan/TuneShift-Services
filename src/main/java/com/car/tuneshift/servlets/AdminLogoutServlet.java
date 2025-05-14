package com.car.tuneshift.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/AdminLogoutServlet")
public class AdminLogoutServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get the current session
        HttpSession session = request.getSession(false);
        
        // If session exists, invalidate it
        if (session != null) {
            // Remove any admin-specific attributes
            session.removeAttribute("admin");
            session.removeAttribute("adminUsername");
            // Invalidate the session
            session.invalidate();
        }
        
        // Redirect to admin login page with absolute path
        response.sendRedirect(request.getContextPath() + "/pages/admin-login.jsp");
    }
}