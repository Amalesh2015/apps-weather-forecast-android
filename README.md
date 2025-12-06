# Weather Forecast App

A simple and beautiful weather forecast mobile application built with Flutter for Android (easily scalable to iOS).

## 📱 Features

- **City Search**: Enter any city name to get current weather
- **Real-time Weather Data**: Fetches data from OpenWeatherMap API
- **Beautiful UI**: 
  - Soft pastel gradient background
  - Rounded corners and elevation
  - Smooth fade-in animations
  - Modern mobile design
- **Weather Information Display**:
  - Temperature (°C)
  - Humidity percentage
  - Weather condition description
  - Weather icon
- **Error Handling**: User-friendly error messages for invalid cities or network issues

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Android Studio / VS Code
- OpenWeatherMap API Key (free)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd apps-weather-forecast-android
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Get your API Key**
   - Visit [OpenWeatherMap](https://openweathermap.org/api)
   - Sign up for a free account
   - Generate an API key

4. **Add your API Key**
   - Open `lib/main.dart`
   - Find line: `static const String _apiKey = 'YOUR_API_KEY';`
   - Replace `YOUR_API_KEY` with your actual API key

5. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

- `flutter`: SDK for building the app
- `http: ^1.1.0`: For making API calls to OpenWeatherMap

## 🏗️ Project Structure

```
lib/
└── main.dart          # Main application file containing:
    ├── WeatherApp     # MaterialApp setup
    ├── WeatherModel   # Data model for parsing API response
    └── HomeScreen     # Main screen with input and weather display
```

## 🌐 API Usage

This app uses the OpenWeatherMap Current Weather Data API:

```
https://api.openweathermap.org/data/2.5/weather?q={city}&appid={API_KEY}&units=metric
```

## 📱 Platform Compatibility

- ✅ **Android**: Fully supported
- ✅ **iOS**: Code is platform-agnostic and ready for iOS deployment
- The app uses Flutter's Material Design widgets which work seamlessly on both platforms

## 🎨 UI Design

- **Gradient Background**: Light blue to pink pastel gradient
- **Card Design**: Elevated cards with rounded corners
- **Typography**: Clean and modern fonts
- **Animations**: Smooth fade-in for weather results and error messages
- **Responsive**: Adapts to different screen sizes

## 🔧 Code Features

- **Simple Architecture**: Single-file app for easy understanding
- **State Management**: Uses `setState` (no complex state management)
- **Beginner-Friendly**: Extensively commented code
- **Error Handling**: Comprehensive error handling for network and API issues
- **Input Validation**: Validates user input before API calls

## 📝 License

This project is open source and available for educational purposes.

## 👨‍💻 Developer Notes

- The app is designed to be simple and beginner-friendly
- All code is contained in a single file (`main.dart`)
- Easy to extend with additional features (e.g., 5-day forecast, favorites, geolocation)
- Platform-agnostic code ensures iOS compatibility without modifications

## 🛠️ Future Enhancements

- Add 5-day weather forecast
- Implement geolocation for current location weather
- Add favorite cities list
- Dark mode support
- Weather alerts and notifications
