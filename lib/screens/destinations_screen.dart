import 'package:dio/dio.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db_helper.dart';
import '../destination.dart';
import '../flag_image.dart';
import 'destination_web_screen.dart';
import 'bucket_list_screen.dart';

class DestinationsScreen extends StatefulWidget {
  const DestinationsScreen({super.key});

  @override
  State<DestinationsScreen> createState() => _DestinationsScreenState();
}

class _DestinationsScreenState extends State<DestinationsScreen> {
  List<Destination> destinations = [];
  Set<String> favoriteNames = {};
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();
  static const _favKey = 'favorite_destinations';
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _loadCachedDestinations();
    fetchDestinations();
  }

  Future<void> _loadFavorites() async {
    final saved = await _prefs.getStringList(_favKey) ?? [];
    setState(() {
      favoriteNames = saved.toSet();
    });
  }

  void _toggleFavorite(String name) {
    setState(() {
      if (favoriteNames.contains(name)) {
        favoriteNames.remove(name);
      } else {
        favoriteNames.add(name);
      }
    });
    _prefs.setStringList(_favKey, favoriteNames.toList());
  }

  Future<void> _loadCachedDestinations() async {
    final cached = await DBHelper.getCachedDestinations();
    if (destinations.isEmpty && cached.isNotEmpty) {
      setState(() {
        destinations = cached;
      });
    }
  }

  Future<void> fetchDestinations() async {
    try {
      final response = await Dio().get(
        'https://countries.dev/countries'
        '?fields=name,capital,region,population,alpha2Code',
      );
      final List data = response.data as List;
      final fresh = data
          .map((e) => Destination.fromJson(e as Map<String, dynamic>))
          .toList();
      setState(() {
        destinations = fresh;
        isLoading = false;
        error = null;
      });
      await DBHelper.cacheDestinations(fresh);
    } catch (e) {
      setState(() {
        isLoading = false;
        error = 'Could not load. Check your connection.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (destinations.isNotEmpty) {
      body = ListView.builder(
        itemCount: destinations.length,
        itemBuilder: (context, index) {
          final d = destinations[index];
          final isFav = favoriteNames.contains(d.name);
          return Card(
            child: ListTile(
              leading: FlagImage(url: d.flagUrl),
              title: Text(d.name),
              subtitle: Text('${d.capital} · ${d.region} · ${d.population}'),
              trailing: IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.deepOrange : Colors.grey,
                ),
                onPressed: () => _toggleFavorite(d.name),
              ),
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
    } else if (isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = Center(child: Text(error ?? 'No destinations'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Destinations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BucketListScreen(
                    savedDestinations: destinations
                        .where((d) => favoriteNames.contains(d.name))
                        .toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(child: body),
    );
  }
}
