<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Weather App</title>
    <style>
        body {
            font-family: 'Helvetica Neue', Arial, sans-serif;
            background-color: #f0f4f8;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            height: 100vh;
            color: #333;
        }
        .container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
            padding: 30px;
            width: 350px;
            text-align: center;
            transition: transform 0.2s;
        }
        .container:hover {
            transform: translateY(-5px);
        }
        h1 {
            font-size: 26px;
            margin-bottom: 20px;
            color: #007BFF;
        }
        input[type="text"] {
            width: 100%;
            padding: 10px;
            border: 2px solid #007BFF;
            border-radius: 5px;
            font-size: 16px;
            margin-bottom: 10px;
            transition: border-color 0.3s;
        }
        input[type="text"]:focus {
            border-color: #0056b3;
            outline: none;
        }
        input[type="submit"] {
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 10px 15px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
        .weather-info {
            margin-top: 20px;
            font-size: 18px;
            color: #333;
            text-align: left;
            line-height: 1.6;
        }
        .footer {
            margin-top: 20px;
            font-size: 12px;
            color: #777;
        }
        .icon {
            width: 50px;
            height: 50px;
            margin-top: 10px;
        }
        @media (max-width: 400px) {
            .container {
                width: 90%;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Weather App</h1>
        <form action="MyServlet" method="post">
            <input type="text" placeholder="Enter city name" name="city" required>
            <input type="submit" value="Get Weather">
        </form>
        
        <div class="weather-info">
            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
                    out.println("<p style='color:red;'>" + error + "</p>");
                } else {
                    String weatherData = (String) request.getAttribute("weatherData");
                    if (weatherData != null) {
                        try {
                            JSONObject json = new JSONObject(weatherData);
                            String cityName = json.getString("name");
                            JSONObject main = json.getJSONObject("main");
                            double temperature = main.getDouble("temp");
                            double feelsLike = main.getDouble("feels_like");
                            int humidity = main.getInt("humidity");
                            JSONArray weatherArray = json.getJSONArray("weather");
                            JSONObject weather = weatherArray.getJSONObject(0);
                            String description = weather.getString("description");
                            String icon = weather.getString("icon");
                            
                            out.println("<h2>Weather in " + cityName + "</h2>");
                            out.println("<p>Temperature: " + temperature + "°C</p>");
                            out.println("<p>Feels Like: " + feelsLike + "°C</p>");
                            out.println("<p>Humidity: " + humidity + "%</p>");
                            out.println("<p>Description: " + description + "</p>");
                            out.println("<img class='icon' src='http://openweathermap.org/img/wn/" + icon + "@2x.png' alt='" + description + "' />");
                        } catch (Exception e) {
                            out.println("<p>Error parsing weather data.</p>");
                        }
                    }
                }
            %>
        </div>
        
        <div class="footer">
            &copy; 2024 Weather App
        </div>
    </div>
</body>
</html>
