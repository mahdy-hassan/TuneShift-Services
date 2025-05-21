package com.car.tuneshift.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.car.tuneshift.models.User;
import com.car.tuneshift.models.Feedback;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/FeedbackServlet")
public class FeedbackServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        String feedbackMessage = request.getParameter("feedback");
        String ratingString = request.getParameter("rating");

        if (feedbackMessage == null || feedbackMessage.trim().isEmpty() || ratingString == null || ratingString.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/pages/profile.jsp?section=feedback&error=Feedback cannot be empty");
            return;
        }

        int rating = 0;
        try {
            rating = Integer.parseInt(ratingString);
            if (rating < 1 || rating > 5) {
                response.sendRedirect(request.getContextPath() + "/pages/profile.jsp?section=feedback&error=Invalid rating value");
                return;
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/pages/profile.jsp?section=feedback&error=Invalid rating format");
            return;
        }

        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date now = new Date();
        String dateString = formatter.format(now);

        Feedback feedback = new Feedback(user.getUsername(), feedbackMessage, dateString, rating);

        // Using an absolute path to ensure writing to the correct data folder
        String dataDir = "C:\\Users\\Dell\\Desktop\\tuneshift\\data"; // Absolute path to data directory
        File dataDirFile = new File(dataDir);
        if (!dataDirFile.exists()) {
            dataDirFile.mkdirs();
        }
        String feedbackFilePath = dataDir + File.separator + "feedback.txt";

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(feedbackFilePath, true))) {
            writer.write(feedback.toFileString());
            writer.newLine();
            System.out.println("Feedback saved: " + feedback.toFileString());
        } catch (IOException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/pages/profile.jsp?section=feedback&error=Failed to save feedback");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/pages/profile.jsp?section=feedback&success=Feedback submitted successfully");
    }
} 