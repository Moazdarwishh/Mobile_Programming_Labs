import 'package:material_ui/material_ui.dart';
import '../destination.dart';
import '../flag_image.dart';

class BucketListScreen extends StatelessWidget {
  const BucketListScreen({
    super.key,
    required this.savedDestinations,
  });

  final List<Destination> savedDestinations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Bucket List')),
      body: SafeArea(
        child: ListView.builder(
          itemCount: savedDestinations.length,
          itemBuilder: (context, index) {
            final d = savedDestinations[index];
            return Card(
              child: ListTile(
                leading: FlagImage(url: d.flagUrl),
                title: Text(d.name),
                subtitle: Text('${d.capital} · ${d.region} · ${d.population}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
