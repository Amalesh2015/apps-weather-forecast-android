import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const WeatherApp());
}

// Main App Widget
class WeatherApp extends StatelessWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Forecast',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// Weather Model Class - Parses JSON data from OpenWeatherMap API
class WeatherModel {
  final String cityName;
  final double temperature;
  final int humidity;
  final String description;
  final String icon;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.humidity,
    required this.description,
    required this.icon,
  });

  // Factory constructor to create WeatherModel from JSON response
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      humidity: json['main']['humidity'],
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }
}

// Home Screen Widget - Main screen with input and weather display
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Text controller for city input field
  final TextEditingController _cityController = TextEditingController();
  
  // State variables
  WeatherModel? _weather; // Holds weather data after successful API call
  bool _isLoading = false; // Tracks loading state during API call
  String? _errorMessage; // Holds error message if API call fails

  // Replace with your actual OpenWeatherMap API key
  // Get your free API key at: https://openweathermap.org/api
  static const String _apiKey = 'YOUR_API_KEY';

  // Fetch weather data from OpenWeatherMap API
  Future<void> _fetchWeather(String city) async {
    // Validate input
    if (city.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a city name';
      });
      return;
    }

    // Reset state and show loading indicator
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _weather = null;
    });

    try {
      // Construct API URL with city name, API key, and metric units
      final url =
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric';
      
      // Make HTTP GET request
      final response = await http.get(Uri.parse(url));

      // Handle response based on status code
      if (response.statusCode == 200) {
        // Success - Parse JSON and update weather data
        final data = json.decode(response.body);
        setState(() {
          _weather = WeatherModel.fromJson(data);
          _isLoading = false;
        });
      } else if (response.statusCode == 404) {
        // City not found
        setState(() {
          _errorMessage = 'City not found. Please try again.';
          _isLoading = false;
        });
      } else {
        // Other errors
        setState(() {
          _errorMessage = 'Failed to load weather data.';
          _isLoading = false;
        });
      }
    } catch (e) {
      // Network or parsing error
      setState(() {
        _errorMessage = 'An error occurred. Check your connection.';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // Clean up controller when widget is disposed
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Soft pastel gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE3F2FD), // Light blue
              Color(0xFFBBDEFB), // Sky blue
              Color(0xFFFCE4EC), // Light pink
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                
                // App Title
                const Text(
                  '🌤️ Weather Forecast',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1565C0),
                  ),
                ),
                const SizedBox(height: 40),
                
                // Input Card - Contains TextField and Button
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // City Input TextField
                        TextField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            labelText: 'Enter City Name',
                            hintText: 'e.g., London, New York, Tokyo',
                            prefixIcon: const Icon(Icons.location_city),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          textCapitalization: TextCapitalization.words,
                          // Allow submitting by pressing enter/return key
                          onSubmitted: (value) => _fetchWeather(value),
                        ),
                        const SizedBox(height: 16),
                        
                        // Get Weather Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null // Disable button while loading
                                : () => _fetchWeather(_cityController.text),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1976D2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Get Weather',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Error Message Card
                if (_errorMessage != null)
                  AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 500),
                    child: Card(
                      color: Colors.red[50],
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                
                // Weather Card - Displays weather information with fade-in animation
                if (_weather != null)
                  AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 800),
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF64B5F6), // Light blue
                              Color(0xFF42A5F5), // Bright blue
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            // City Name
                            Text(
                              _weather!.cityName,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Weather Icon from OpenWeatherMap
                            Image.network(
                              'https://openweathermap.org/img/wn/${_weather!.icon}@4x.png',
                              height: 120,
                              width: 120,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback if image fails to load
                                return const Icon(
                                  Icons.cloud,
                                  size: 120,
                                  color: Colors.white,
                                );
                              },
                            ),
                            
                            // Temperature Display
                            Text(
                              '${_weather!.temperature.toStringAsFixed(1)}°C',
                              style: const TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            
                            // Weather Condition Description
                            Text(
                              _weather!.description.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 18,
                                letterSpacing: 1.2,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Humidity Information
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.water_drop,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Humidity: ${_weather!.humidity}%',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
