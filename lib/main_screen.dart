import 'package:film_app/features/reminder/screens/reminder_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:film_app/core/constants/app_colors.dart';
import 'package:film_app/features/mapbox/screens/map_screen.dart';
import 'package:film_app/features/home/presentation/screens/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List<Widget> _pages = [
    const MapScreen(),
    const ReminderScreen(),
    const HomeScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(children: [Expanded(child: _pages[_selectedIndex])]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedItemColor: isDark
            ? AppColors.textPrimaryDark
            : AppColors.primary,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        items: const [
          BottomNavigationBarItem(
            activeIcon: Icon(Iconsax.home_15, size: 30),
            icon: Icon(Iconsax.home, size: 23),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Iconsax.happyemoji5, size: 30),
            icon: Icon(Iconsax.happyemoji, size: 23),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.settings, size: 30),
            icon: Icon(Iconsax.setting_2, size: 23),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}
