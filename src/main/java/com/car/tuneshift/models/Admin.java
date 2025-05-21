package com.car.tuneshift.models;

// The Admin class inherits from the User class
public class Admin extends User {



    // Constructor that calls the constructor of the parent class (User)
    public Admin(String fullName, String email, String phone, String username, String password) {
        // Call the User class constructor using 'super'
        super(fullName, email, phone, username, password);

    }

   
}