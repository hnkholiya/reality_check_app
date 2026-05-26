import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash_screen.dart';

// ─────────────────────────────────────────────
// ThemeController — InheritedWidget
// ─────────────────────────────────────────────

class ThemeController extends InheritedWidget {
  final VoidCallback toggleTheme;
  final bool isDark;

  const ThemeController({
    super.key,
    required this.toggleTheme,
    required this.isDark,
    required super.child,
  });

  static ThemeController of(BuildContext context) {
    final result =
    context.dependOnInheritedWidgetOfExactType<ThemeController>();

    assert(result != null, 'No ThemeController found in context');

    return result!;
  }

  @override
  bool updateShouldNotify(ThemeController oldWidget) =>
      oldWidget.isDark != isDark;
}

// ─────────────────────────────────────────────
// Main App
// ─────────────────────────────────────────────

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Firebase Initialize
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const RealityCheckApp());
}

class RealityCheckApp extends StatefulWidget {
  const RealityCheckApp({super.key});

  @override
  State<RealityCheckApp> createState() => _RealityCheckAppState();
}

class _RealityCheckAppState extends State<RealityCheckApp>
    with SingleTickerProviderStateMixin {

  ThemeMode _themeMode = ThemeMode.dark;

  late AnimationController _themeAnimController;

  @override
  void initState() {
    super.initState();

    _themeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _themeAnimController.dispose();
    super.dispose();
  }

  void toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.dark) {
        _themeMode = ThemeMode.light;
        _themeAnimController.forward();
      } else {
        _themeMode = ThemeMode.dark;
        _themeAnimController.reverse();
      }
    });
  }

  bool get isDark => _themeMode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return ThemeController(
      toggleTheme: toggleTheme,
      isDark: isDark,
      child: MaterialApp(
        title: 'Reality Check Purchase',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _themeMode,
        home: const SplashScreen(),
      ),
    );
  }
}