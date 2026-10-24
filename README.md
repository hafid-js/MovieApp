🎬 Film App

A cross-platform movie application built with Flutter 3 for Android and iOS. This application uses the Star Wars API (SWAPI) to display movie information and provides cinema locations, navigation, and movie reminder features.

- Features
- 
Movie List — Browse Star Wars movies using SWAPI.

Movie Details — View movie summaries, episode numbers, directors, producers, release dates, and character information.

Cinema Locations — Explore cinema locations using Mapbox, with mock coordinates for at least five cinema locations.

ETA & Navigation — View estimated travel times and navigate from current location to a selected cinema.

Movie Reminders — Create, view, and delete movie reminders.

Local Storage — Store reminder data locally using Hive.

State Management — Manage application state using the BLoC pattern.

Event Bus — Support event-based communication between application features.

Tech Stack :
Flutter 3
Dart
Star Wars API (SWAPI)
flutter_bloc
Hive
Mapbox
Environment configuration using .env


-  Installation
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

Windows (Command Prompt):

cmd
copy .env.example .env


macOS / Linux:

bash
cp .env.example .env


Open .env and configure the environment variables required by application.

Example .env.example:

dotenv
MAPBOX_ACCESS_TOKEN=masukkan_token_mapbox_anda_disini



4. Run the Application

Connect a device or start an emulator, then execute:

bash
flutter run


For iOS development, use macOS with Xcode and run the application on an iOS simulator or physical device.


This application uses the Star Wars API (SWAPI) to retrieve movie information.

Website: https://swapi.dev/
Films Endpoint: https://swapi.dev/api/

SWAPI provides public endpoints that do not require an API token.
