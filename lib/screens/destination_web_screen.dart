import 'package:material_ui/material_ui.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DestinationWebScreen extends StatefulWidget {
  const DestinationWebScreen({super.key, required this.name});

  final String name;

  @override
  State<DestinationWebScreen> createState() => _DestinationWebScreenState();
}

class _DestinationWebScreenState extends State<DestinationWebScreen> {
  late final WebViewController _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse(
        'https://en.wikipedia.org/wiki/${Uri.encodeComponent(widget.name)}'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
