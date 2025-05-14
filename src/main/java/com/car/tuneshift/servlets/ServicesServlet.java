package com.car.tuneshift.servlets;

import com.car.tuneshift.models.Service;
import com.car.tuneshift.utils.ServiceUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "servicesServlet", value = "/services")
public class ServicesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get all services
        List<Service> services = ServiceUtil.getAllServices();

        // Add services to request attribute
        request.setAttribute("services", services);

        // Forward to services page
        request.getRequestDispatcher("/pages/services.jsp").forward(request, response);
    }
}