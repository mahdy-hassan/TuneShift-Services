package com.car.tuneshift.models;

import java.util.Date; // Assuming you might use java.util.Date later if needed
import java.text.SimpleDateFormat; // Assuming SimpleDateFormat might be useful

public class Feedback {
    private String username;
    private String message;
    private String date;
    private int rating;

    // Constructor
    public Feedback(String username, String message, String date, int rating) {
        this.username = username;
        this.message = message;
        this.date = date;
        this.rating = rating;
    }

    // Getters (Setters might not be needed if Feedback is immutable after creation)
    public String getUsername() {
        return username;
    }

    public String getMessage() {
        return message;
    }

    public String getDate() {
        return date;
    }

    public int getRating() {
        return rating;
    }

    // Optional: Method to format for file storage
    public String toFileString() {
        // Simple escaping for pipe character in message to prevent file parsing issues
        String escapedMessage = this.message.replace("|", "[pipe]"); // Choose a suitable escape sequence
        return username + "|" + this.rating + "|" + escapedMessage + "|" + date;
    }

    // Optional: Method to create from file string
    public static Feedback fromFileString(String fileString) {
        String[] parts = fileString.split("\\|");
        if (parts.length == 4) {
            // Simple unescaping
            String unescapedMessage = parts[1].replace("[pipe]", "|");
            try {
                int rating = Integer.parseInt(parts[1]);
                return new Feedback(parts[0], parts[2], parts[3], rating);
            } catch (NumberFormatException e) {
                System.err.println("Error parsing rating for feedback line: " + fileString);
                return null; // Handle invalid rating
            }
        }
        return null; // Handle invalid lines
    }


} 