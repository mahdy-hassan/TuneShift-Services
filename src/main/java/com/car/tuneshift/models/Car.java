package com.car.tuneshift.models;

public class Car {
    private String username;
    private String model;
    private String year;
    private String plateNumber;

    public Car(String username, String model, String year, String plateNumber) {
        this.username = username;
        this.model = model;
        this.year = year;
        this.plateNumber = plateNumber;
    }

    // Getters and setters
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getYear() {
        return year;
    }

    public void setYear(String year) {
        this.year = year;
    }

    public String getPlateNumber() {
        return plateNumber;
    }

    public void setPlateNumber(String plateNumber) {
        this.plateNumber = plateNumber;
    }

    @Override
    public String toString() {
        return username + "|" + model + "|" + year + "|" + plateNumber;
    }
}