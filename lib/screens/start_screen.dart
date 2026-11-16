import 'package:material_ui/material_ui.dart';
import 'sign_up_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key, required this.onToggleTheme});

  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 42,
                backgroundColor: colors.onPrimary,
                child: Icon(Icons.landscape, size: 44, color: colors.primary),
              ),
              const SizedBox(height: 16),
              Text(
                'Wanderly',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: colors.onPrimary,
                ),
              ),
              Text(
                'Explore the world, one city at a time',
                style: TextStyle(color: colors.onPrimary),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
                child: const Text('Start Exploring'),
              ),
              TextButton(
                onPressed: onToggleTheme,
                child: Text(
                  'Toggle theme',
                  style: TextStyle(color: colors.onPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
