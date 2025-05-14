package com.car.tuneshift.managers;

import com.car.tuneshift.models.ServiceHistory;
import java.util.LinkedList;
import java.util.Date;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

public class ServiceHistoryManager {
    private LinkedList<ServiceHistory> serviceHistory;
    private static final String BOOKINGS_FILE_PATH = "C:\\Users\\Dell\\Desktop\\tuneshift\\data\\bookings.txt";
    private static final String SERVICES_FILE_PATH = "C:\\Users\\Dell\\Desktop\\tuneshift\\data\\services.txt";
    private Map<String, Integer> serviceDurations;

    public ServiceHistoryManager() {
        this.serviceHistory = new LinkedList<>();
        this.serviceDurations = new HashMap<>();
        loadServiceDurations();
        loadServiceHistory();
    }

    private void loadServiceDurations() {
        File servicesFile = new File(SERVICES_FILE_PATH);
        System.out.println("Loading service durations from: " + SERVICES_FILE_PATH);
        if (servicesFile.exists()) {
            try (BufferedReader br = new BufferedReader(new FileReader(servicesFile))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] parts = line.split("\\|");
                    if (parts.length >= 5) {
                        String serviceId = parts[0];
                        int duration = Integer.parseInt(parts[4]);
                        serviceDurations.put(serviceId, duration);
                        System.out.println("Loaded duration for service " + serviceId + ": " + duration + " minutes");
                    }
                }
            } catch (Exception e) {
                System.out.println("Error reading services file");
                e.printStackTrace();
            }
        } else {
            System.out.println("Services file not found at: " + SERVICES_FILE_PATH);
        }
    }

    private void loadServiceHistory() {
        File bookingsFile = new File(BOOKINGS_FILE_PATH);
        System.out.println("Loading service history from: " + BOOKINGS_FILE_PATH);
        System.out.println("File exists: " + bookingsFile.exists());
        
        if (bookingsFile.exists()) {
            try (BufferedReader br = new BufferedReader(new FileReader(bookingsFile))) {
                String line;
                int count = 0;
                while ((line = br.readLine()) != null) {
                    String[] parts = line.split("\\|");
                    if (parts.length >= 11) {
                        try {
                            String username = parts[0];
                            String serviceId = parts[5]; // Service ID is at index 5
                            String carModel = parts[2];
                            String licensePlate = parts[4];
                            String serviceName = parts[6];
                            double price = Double.parseDouble(parts[7]);
                            String dateStr = parts[8];
                            String timeStr = parts[9];
                            String status = parts[10]; // Get status from bookings
                            
                            // Get duration from services map
                            int duration = serviceDurations.getOrDefault(serviceId, 60);
                            System.out.println("Service ID: " + serviceId + ", Duration: " + duration);
                            
                            // Parse date and time
                            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                            Date serviceDate = dateFormat.parse(dateStr + " " + timeStr);
                            
                            ServiceHistory record = new ServiceHistory(
                                serviceId,
                                serviceName,
                                carModel,
                                licensePlate,
                                serviceDate,
                                price,
                                duration,
                                status
                            );
                            serviceHistory.add(record);
                            count++;
                        } catch (Exception e) {
                            System.out.println("Error processing line: " + line);
                            e.printStackTrace();
                        }
                    }
                }
                System.out.println("Total records loaded: " + count);
            } catch (Exception e) {
                System.out.println("Error reading bookings file");
                e.printStackTrace();
            }
        } else {
            System.out.println("Bookings file not found at: " + BOOKINGS_FILE_PATH);
        }
    }

    public void addServiceRecord(ServiceHistory record) {
        serviceHistory.add(record);
    }

    public LinkedList<ServiceHistory> getServiceHistory() {
        return serviceHistory;
    }

    public void sortByDate(boolean ascending) {
        // Selection Sort implementation
        int n = serviceHistory.size();
        for (int i = 0; i < n - 1; i++) {
            int minIdx = i;
            for (int j = i + 1; j < n; j++) {
                Date date1 = serviceHistory.get(j).getServiceDate();
                Date date2 = serviceHistory.get(minIdx).getServiceDate();
                if (ascending ? date1.before(date2) : date1.after(date2)) {
                    minIdx = j;
                }
            }
            // Swap
            ServiceHistory temp = serviceHistory.get(i);
            serviceHistory.set(i, serviceHistory.get(minIdx));
            serviceHistory.set(minIdx, temp);
        }
    }

    public LinkedList<ServiceHistory> getServiceHistoryByUsername(String username) {
        System.out.println("Getting service history for username: " + username);
        LinkedList<ServiceHistory> userHistory = new LinkedList<>();
        
        // Read the bookings file directly for this user
        File bookingsFile = new File(BOOKINGS_FILE_PATH);
        if (bookingsFile.exists()) {
            try (BufferedReader br = new BufferedReader(new FileReader(bookingsFile))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] parts = line.split("\\|");
                    if (parts.length >= 11 && parts[0].equals(username)) {
                        try {
                            String serviceId = parts[5]; // Service ID is at index 5
                            String carModel = parts[2];
                            String licensePlate = parts[4];
                            String serviceName = parts[6];
                            double price = Double.parseDouble(parts[7]);
                            String dateStr = parts[8];
                            String timeStr = parts[9];
                            String status = parts[10]; // Get status from bookings
                            
                            // Get duration from services map
                            int duration = serviceDurations.getOrDefault(serviceId, 60);
                            System.out.println("Service ID: " + serviceId + ", Duration: " + duration);
                            
                            // Parse date and time
                            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                            Date serviceDate = dateFormat.parse(dateStr + " " + timeStr);
                            
                            ServiceHistory record = new ServiceHistory(
                                serviceId,
                                serviceName,
                                carModel,
                                licensePlate,
                                serviceDate,
                                price,
                                duration,
                                status
                            );
                            userHistory.add(record);
                            System.out.println("Added record for user: " + username + ", Service: " + serviceName);
                        } catch (Exception e) {
                            System.out.println("Error processing line: " + line);
                            e.printStackTrace();
                        }
                    }
                }
            } catch (Exception e) {
                System.out.println("Error reading bookings file");
                e.printStackTrace();
            }
        }
        
        System.out.println("Found " + userHistory.size() + " records for user: " + username);
        return userHistory;
    }

    public void sortByDate(LinkedList<ServiceHistory> list, boolean ascending) {
        // Selection Sort implementation
        int n = list.size();
        for (int i = 0; i < n - 1; i++) {
            int minIdx = i;
            for (int j = i + 1; j < n; j++) {
                Date date1 = list.get(j).getServiceDate();
                Date date2 = list.get(minIdx).getServiceDate();
                if (ascending ? date1.before(date2) : date1.after(date2)) {
                    minIdx = j;
                }
            }
            // Swap
            ServiceHistory temp = list.get(i);
            list.set(i, list.get(minIdx));
            list.set(minIdx, temp);
        }
    }
} 