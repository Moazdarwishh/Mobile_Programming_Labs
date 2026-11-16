import 'package:dio/dio.dart';
import 'package:material_ui/material_ui.dart';
import '../destination.dart';
import '../flag_image.dart';
import 'destination_web_screen.dart';

class DestinationsScreen extends StatefulWidget {
  const DestinationsScreen({super.key});

  @override
  State<DestinationsScreen> createState() => _DestinationsScreenState();
}

class _DestinationsScreenState extends State<DestinationsScreen> {
  List<Destination> destinations = [];

  @override
  void initState() {
    super.initState();
    fetchDestinations();
  }

  Future<void> fetchDestinations() async {
    try {
      final response = await Dio().get(
        'https://countries.dev/countries'
        '?fields=name,capital,region,population,alpha2Code',
      );
      final List data = response.data as List;
      setState(() {
        destinations = data
            .map((e) => Destination.fromJson(e as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (destinations.isEmpty) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = ListView.builder(
        itemCount: destinations.length,
        itemBuilder: (context, index) {
          final d = destinations[index];
          return Card(
            child: ListTile(
              leading: FlagImage(url: d.flagUrl),
              title: Text(d.name),
              subtitle: Text('${d.capital} · ${d.region} · ${d.population}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DestinationWebScreen(name: d.name),
                  ),
                );
              },
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Explore Destinations')),
      body: SafeArea(child: body),
    );
  }
}
