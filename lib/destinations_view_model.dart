import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'db_helper.dart';
import 'destination.dart';

class DestinationsViewModel extends ChangeNotifier {
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();
  static const _favKey = 'favorite_destinations';

  List<Destination> destinations = [];
  Set<String> favoriteNames = {};
  bool isLoading = true;
  String? error;

  Future<void> load() async {
    await loadFavorites();
    await loadCachedDestinations();
    await fetchDestinations();
  }

  Future<void> loadFavorites() async {
    final saved = await _prefs.getStringList(_favKey) ?? [];
    favoriteNames = saved.toSet();
    notifyListeners();
  }

  void toggleFavorite(String name) {
    if (favoriteNames.contains(name)) {
      favoriteNames.remove(name);
    } else {
      favoriteNames.add(name);
    }
    notifyListeners();
    _prefs.setStringList(_favKey, favoriteNames.toList());
  }

  Future<void> loadCachedDestinations() async {
    final cached = await DBHelper.getCachedDestinations();
    if (destinations.isEmpty && cached.isNotEmpty) {
      destinations = cached;
      notifyListeners();
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
      destinations = fresh;
      isLoading = false;
      error = null;
      notifyListeners();
      await DBHelper.cacheDestinations(fresh);
    } catch (e) {
      isLoading = false;
      error = 'Could not load. Check your connection.';
      notifyListeners();
    }
  }
}
