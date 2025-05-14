package com.car.tuneshift.models;

public class Service {
    private String serviceId;
    private String serviceName;
    private String description;
    private double price;
    private int duration; // in minutes

    // Constructor for new services
    public Service(String serviceName, String description, double price, int duration) {
        this.serviceName = serviceName;
        this.description = description;
        this.price = price;
        this.duration = duration;
    }

    // Constructor for existing services (updates)
    public Service(String serviceId, String serviceName, String description, double price, int duration) {
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.description = description;
        this.price = price;
        this.duration = duration;
    }

    // Constructor for file reading
    public Service(String serviceId, String serviceName, String description, String price, String duration) {
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.description = description;
        this.price = Double.parseDouble(price);
        this.duration = Integer.parseInt(duration);
    }

    // Empty constructor
    public Service() {}

    // Getters and Setters
    public String getServiceId() { return serviceId; }
    public void setServiceId(String serviceId) { this.serviceId = serviceId; }
    
    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    
    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }

    // Convert to string for file storage
    public String toFileString() {
        return serviceId + "|" + serviceName + "|" + description + "|" + price + "|" + duration;
    }

    // Create from string for file reading
    public static Service fromFileString(String line) {
        String[] parts = line.split("\\|");
        if (parts.length == 5) {
            return new Service(
                parts[0],  // serviceId
                parts[1],  // serviceName
                parts[2],  // description
                Double.parseDouble(parts[3]),  // price
                Integer.parseInt(parts[4])     // duration
            );
        }
        return null;
    }
}