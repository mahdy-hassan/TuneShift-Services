package com.car.tuneshift.models;

public class Booking {
    private String username;
    private String serviceType;
    private String carModel;
    private String vehicleYear;
    private String licensePlate;
    private String date;
    private String time;
    private String status;


    public Booking() {
        this.status = "Pending"; // Default status
    }

    public Booking(String username, String serviceType, String carModel, String vehicleYear,
                   String licensePlate, String date, String time) {
        this.username = username;
        this.serviceType = serviceType;
        this.carModel = carModel;
        this.vehicleYear = vehicleYear;
        this.licensePlate = licensePlate;
        this.date = date;
        this.time = time;
        this.status = "Pending"; // Default status
    }

    // Convert from file string format (pipe-separated)
    public static Booking fromFileString(String fileString) {
        String[] parts = fileString.split("\\|");
        if (parts.length < 6) {
            return null;
        }

        Booking booking = new Booking();
        booking.setUsername(parts[0]);
        booking.setServiceType(parts[1]);
        booking.setCarModel(parts[2]);
        booking.setVehicleYear(parts[3]);
        booking.setLicensePlate(parts[4]);
        booking.setDate(parts[5]);
        booking.setTime(parts.length > 6 ? parts[6] : "");
        booking.setStatus(parts.length > 7 ? parts[7] : "Pending");

        return booking;
    }

    // Convert to file string format (pipe-separated)
    public String toFileString() {
        return username + "|" + serviceType + "|" + carModel + "|" +
                vehicleYear + "|" + licensePlate + "|" + date + "|" + time + "|" + status;
    }

    // Getters and setters
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getServiceType() {
        return serviceType;
    }

    public void setServiceType(String serviceType) {
        this.serviceType = serviceType;
    }

    public String getCarModel() {
        return carModel;
    }

    public void setCarModel(String carModel) {
        this.carModel = carModel;
    }

    public String getVehicleYear() {
        return vehicleYear;
    }

    public void setVehicleYear(String vehicleYear) {
        this.vehicleYear = vehicleYear;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}