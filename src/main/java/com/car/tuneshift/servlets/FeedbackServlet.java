package com.car.tuneshift.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.car.tuneshift.models.User;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/FeedbackServlet")
public class FeedbackServlet extends HttpServlet {
    private static final String FEEDBACK_FILE = "C:\\Users\\Dell\\Desktop\\tuneshift\\data\\feedback.txt";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        String rating = request.getParameter("rating");
        String feedback = request.getParameter("feedback");
        
        if (rating == null || feedback == null || feedback.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Please provide both rating and feedback.");
            response.sendRedirect(request.getContextPath() + "/pages/profile.jsp");
            return;
        }

        // Create feedback directory if it doesn't exist
        File feedbackDir = new File("C:\\Users\\Dell\\Desktop\\tuneshift\\data");
        if (!feedbackDir.exists()) {
            feedbackDir.mkdirs();
        }

        // Format the current date
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy HH:mm");
        String currentDate = dateFormat.format(new Date());

        // Prepare feedback data
        String feedbackData = String.format("%s|%s|%s|%s%n", 
            user.getUsername(), 
            rating, 
            feedback.replace("|", " "), // Replace pipe character to avoid conflicts
            currentDate
        );

        // Append feedback to file
        try (FileWriter fw = new FileWriter(FEEDBACK_FILE, true);
             BufferedWriter bw = new BufferedWriter(fw);
             PrintWriter out = new PrintWriter(bw)) {
            out.print(feedbackData);
        } catch (IOException e) {
            session.setAttribute("errorMessage", "Failed to save feedback. Please try again.");
            response.sendRedirect(request.getContextPath() + "/pages/profile.jsp");
            return;
        }

        session.setAttribute("successMessage", "Thank you for your feedback!");
        response.sendRedirect(request.getContextPath() + "/pages/profile.jsp");
    }
} 