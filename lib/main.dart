import 'package:culinary_hunt/pages/home_page.dart';
import 'package:culinary_hunt/pages/settings_page.dart';
import 'package:culinary_hunt/pages/splashscreen_page.dart';
import 'package:culinary_hunt/provider/detail_restaurant_provider.dart';
import 'package:culinary_hunt/provider/restaurant_provider.dart';
import 'package:culinary_hunt/provider/theme_provider.dart';
import 'package:culinary_hunt/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/api/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RestaurantProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(
          create: (_) => DetailRestaurantProvider(ApiService()),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      // child: MaterialApp(
      //   debugShowCheckedModeBanner: false,
      //   title: 'Culiner Hunt',
      //   // theme: ThemeData(
      //   //   useMaterial3: true,
      //   //   colorSchemeSeed: Colors.indigo,
      //   //   appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      //   //   cardTheme: CardThemeData(
      //   //     elevation: 3,
      //   //     shape: RoundedRectangleBorder(
      //   //       borderRadius: BorderRadius.circular(12),
      //   //     ),
      //   //   ),
      //   // ),
      //   themeMode: ThemeProvider().isDarkMode ? ThemeMode.dark : ThemeMode.light,

      //   theme: AppTheme.lightTheme,

      //   darkTheme: AppTheme.darkTheme,
      //   // 🔥 Awal tetap Splash
      //   home: const SplashScreenPage(),
      // ),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Culinary Hunt',

            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,

            theme: AppTheme.lightTheme,

            darkTheme: AppTheme.darkTheme,

            home: const SplashScreenPage(),
          );
        },
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [HomePage(), SettingsPage()];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
