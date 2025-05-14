package com.car.tuneshift.models;

import java.util.Date;

public class ServiceHistory {
    private String serviceId;
    private String serviceName;
    private String carModel;
    private String licensePlate;
    private Date serviceDate;
    private double price;
    private int duration;
    private String status;

    public ServiceHistory(String serviceId, String serviceName, String carModel, String licensePlate, 
                         Date serviceDate, double price, int duration, String status) {
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.carModel = carModel;
        this.licensePlate = licensePlate;
        this.serviceDate = serviceDate;
        this.price = price;
        this.duration = duration;
        this.status = status;
    }

    // Getters
    public String getServiceId() { return serviceId; }
    public String getServiceName() { return serviceName; }
    public String getCarModel() { return carModel; }
    public String getLicensePlate() { return licensePlate; }
    public Date getServiceDate() { return serviceDate; }
    public double getPrice() { return price; }
    public int getDuration() { return duration; }
    public String getStatus() { return status; }

    // Setters
    public void setServiceId(String serviceId) { this.serviceId = serviceId; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }
    public void setCarModel(String carModel) { this.carModel = carModel; }
    public void setLicensePlate(String licensePlate) { this.licensePlate = licensePlate; }
    public void setServiceDate(Date serviceDate) { this.serviceDate = serviceDate; }
    public void setPrice(double price) { this.price = price; }
    public void setDuration(int duration) { this.duration = duration; }
    public void setStatus(String status) { this.status = status; }
} 