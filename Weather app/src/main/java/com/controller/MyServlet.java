package com.controller;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Scanner;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

@WebServlet("/MyServlet")
public class MyServlet extends HttpServlet {

    public MyServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String apikey = "dca63d849cce205ff865142056159170";
        String city = request.getParameter("city");

        if (city == null || city.trim().isEmpty()) {
            request.setAttribute("error", "City name cannot be empty.");
            request.getRequestDispatcher("weather.jsp").forward(request, response);
            return;
        }

        // Create the URL for the OpenWeatherMap API request
        String apiUrl = "https://api.openweathermap.org/data/2.5/weather?q=" + city + "&appid=" + apikey + "&units=metric";

        HttpURLConnection connection = null;
        StringBuilder responseContent = new StringBuilder();
        try {
            URL url = new URL(apiUrl);
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            int statusCode = connection.getResponseCode();

            if (statusCode == 200) {
                try (InputStream inputStream = connection.getInputStream();
                     InputStreamReader reader = new InputStreamReader(inputStream);
                     Scanner scanner = new Scanner(reader)) {

                    while (scanner.hasNext()) {
                        responseContent.append(scanner.nextLine());
                    }

                    try {
                        JSONObject jsonResponse = new JSONObject(responseContent.toString());
                        // Set attributes with JSON data
                        request.setAttribute("weatherData", jsonResponse.toString()); // Raw JSON
                        request.setAttribute("city", city);
                    } catch (Exception e) {
                        request.setAttribute("error", "Error parsing weather data.");
                        e.printStackTrace();
                    }
                }
            } else {
                // Handle different status codes and provide a meaningful error message
                request.setAttribute("error", "Error: Unable to fetch data from API. Status code: " + statusCode);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: Unable to connect to API. " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
        request.setAttribute("weatherData", responseContent.toString());
        request.setAttribute("city", city);

        request.getRequestDispatcher("weather.jsp").forward(request, response);
    }
}
