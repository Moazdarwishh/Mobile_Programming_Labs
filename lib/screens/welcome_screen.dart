import 'package:material_ui/material_ui.dart';
import 'destinations_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.travel_explore, size: 80),
              const SizedBox(height: 16),
              Text(
                'Welcome, $name!',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('Your next trip starts here'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DestinationsScreen(),
                    ),
                  );
                },
                child: const Text('Browse Destinations'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
