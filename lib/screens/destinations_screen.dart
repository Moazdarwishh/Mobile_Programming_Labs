import 'package:material_ui/material_ui.dart';
import '../destinations_view_model.dart';
import '../flag_image.dart';
import 'destination_web_screen.dart';
import 'bucket_list_screen.dart';

class DestinationsScreen extends StatefulWidget {
  const DestinationsScreen({super.key});

  @override
  State<DestinationsScreen> createState() => _DestinationsScreenState();
}

class _DestinationsScreenState extends State<DestinationsScreen> {
  final viewModel = DestinationsViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.load();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    savedDestinations: viewModel.destinations
                        .where((d) => viewModel.favoriteNames.contains(d.name))
                        .toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, child) {
            if (viewModel.destinations.isNotEmpty) {
              return ListView.builder(
                itemCount: viewModel.destinations.length,
                itemBuilder: (context, index) {
                  final d = viewModel.destinations[index];
                  final isFav = viewModel.favoriteNames.contains(d.name);
                  return Card(
                    child: ListTile(
                      leading: FlagImage(url: d.flagUrl),
                      title: Text(d.name),
                      subtitle:
                          Text('${d.capital} · ${d.region} · ${d.population}'),
                      trailing: IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.deepOrange : Colors.grey,
                        ),
                        onPressed: () => viewModel.toggleFavorite(d.name),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DestinationWebScreen(name: d.name),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Center(
                child: Text(viewModel.error ?? 'No destinations'),
              );
            }
          },
        ),
      ),
    );
  }
}
