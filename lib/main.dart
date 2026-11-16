import 'package:material_ui/material_ui.dart';
import 'screens/start_screen.dart';

void main() {
  runApp(const WanderlyApp());
}

class WanderlyApp extends StatefulWidget {
  const WanderlyApp({super.key});

  @override
  State<WanderlyApp> createState() => _WanderlyAppState();
}

class _WanderlyAppState extends State<WanderlyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF0F5A50),
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: const Color(0xFF0F5A50),
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      home: StartScreen(onToggleTheme: _toggleTheme),
    );
  }
}
