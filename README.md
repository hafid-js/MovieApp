🎬 Film App

A cross-platform movie application built with Flutter 3 for Android and iOS. The application uses the Star Wars API (SWAPI) to display movie information and provides cinema locations and movie reminder features.

Features
Movie List — Browse Star Wars movies using SWAPI.
Movie Details — View movie summaries, episode numbers, directors, producers, release dates, and character information.
Cinema Locations — Explore cinema locations using Google Maps or Mapbox, with mock latitude and longitude data for at least five cinema locations.
ETA & Navigation — View estimated travel times and navigate from the current location to a selected cinema.
Movie Reminders — Create, view, and delete movie reminders.
Local Storage — Store reminder data locally using Hive.
State Management — Manage application state using the BLoC pattern.
Event-Bus — Support event-based communication between application features.
Tech Stack
Flutter 3
Dart
SWAPI
flutter_bloc
Hive
Google Maps or Mapbox
Environment configuration using .env
Prerequisites
Flutter 3 and Dart SDK
Android Studio for Android development
macOS with Xcode for iOS development
An Android emulator or physical device
An iOS simulator or physical device for iOS testing
Map provider API credentials, if required
Installation
1. Clone the Repository
bash
git clone <repository-url>
cd film_app


Replace <repository-url> with your Git repository URL.

2. Install Dependencies
bash
flutter pub get

3. Configure Environment Variables

Create a .env file by copying .env.example.

On Windows, run:

cmd
copy .env.example .env


Open .env and configure the required environment variables using your own API keys.

Example .env.example:

dotenv
GOOGLE_MAPS_API_KEY=masukkan_token_mapbox_kamu_disini


Use the variable names required by your application. If you use Mapbox instead of Google Maps, configure the appropriate Mapbox token.

Important: Never commit your actual .env file or expose secret API credentials in a public repository. Commit .env.example with placeholder values only.

4. Run the Application

For Android, connect an Android device or start an emulator, then run:

bash
flutter run


For iOS, use macOS with Xcode and run the application on an iOS simulator or physical device.

API Reference

This application uses the Star Wars API (SWAPI) to retrieve movie information.

Website: https://swapi.dev/
Films endpoint: https://swapi.dev/api/films/

SWAPI provides public endpoints that do not require an API token.

Project Structure
text
film_app/
├── lib/
│   ├── core/
│   │   └── constants/
│   ├── features/
│   │   ├── movies/
│   │   ├── cinema/
│   │   └── reminder/
│   │       └── service/
│   └── main.dart
├── .env.example
├── .gitignore
├── pubspec.yaml
└── README.md


The project structure may vary depending on the implementation.

Supported Platforms
Android
iOS
Notes
Cinema locations can use mock coordinates for development and testing.
Map features may require API keys and location permissions.
ETA and route navigation require an appropriate maps or routing integration.
Scheduled reminders may require notification permissions and platform-specific configuration.
Ensure all required environment variables are configured before running the application.
License

This project is developed for educational purposes.