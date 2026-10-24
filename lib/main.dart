import 'package:film_app/features/reminder/film_reminder.dart';
import 'package:film_app/features/reminder/service/notification_service.dart';
import 'package:film_app/features/reminder/service/reminder_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:film_app/core/constants/app_theme.dart';
import 'package:film_app/features/home/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(FilmReminderAdapter());
  await Hive.openBox<FilmReminder>('filmRemindersBox');

  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.requestPermissions();
  await FilmReminderService().deleteExpiredReminders();
  await setup();
  runApp(ProviderScope(child: MyApp()));
}

Future<void> setup() async {
  await dotenv.load(fileName: '.env');

  final token = dotenv.env['MAPBOX_ACCESS_TOKEN'];

  if (token == null || token.isEmpty || !token.startsWith('pk.')) {
    throw Exception(
      'Invalid Mapbox token. Check your .env file.\n'
      'Token must start with "pk." and have no quotes or space.\n'
      'Got: $token',
    );
  }
  MapboxOptions.setAccessToken(token);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      // theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.dark,

      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: child!,
        );
      },

      home: HomeScreen(),
    );
  }
}
