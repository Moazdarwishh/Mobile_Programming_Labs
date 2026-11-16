import 'package:material_ui/material_ui.dart';

class FlagImage extends StatelessWidget {
  const FlagImage({super.key, required this.url, this.width = 40});

  final String url;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: width,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return SizedBox(
          width: width,
          height: width,
          child: const CircularProgressIndicator(strokeWidth: 2),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.flag_outlined);
      },
    );
  }
}
