package com.car.tuneshift.models;

public class User {
    private String fullName;
    private String email;
    private String phone;
    private String username;
    private String password;

    // Constructor
    public User(String fullName, String email, String phone, String username, String password) {
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.username = username;
        this.password = password;
    }

    // Default constructor
    public User() {
    }

    // Getters and Setters
    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    // Convert User to file format (fullName,email,phone,username,password)
    public String toFileString() {
        return fullName + "," + email + "," + phone + "," + username + "," + password;
    }

    // Create User from file line
    public static User fromFileString(String fileLine) {
        // Split the file line by commas
        String[] parts = fileLine.split(",");

        // Check if the line has exactly 5 parts (i.e., fullName, email, phone, username, password)
        if (parts.length == 5) {
            // Trim whitespace and ensure no fields are empty
            String fullName = parts[0].trim();
            String email = parts[1].trim();
            String phone = parts[2].trim();
            String username = parts[3].trim();
            String password = parts[4].trim();

            // Optionally, validate if the data is not empty (this depends on your requirements)
            if (!fullName.isEmpty() && !email.isEmpty() && !phone.isEmpty() && !username.isEmpty() && !password.isEmpty()) {
                return new User(fullName, email, phone, username, password);
            }
        }

        // Return null if the data is invalid or doesn't match expected format
        System.out.println("Invalid user data in file: " + fileLine);
        return null;
    }
}