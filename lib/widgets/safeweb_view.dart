import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SafewebView extends StatelessWidget {
  String? url;

  SafewebView({this.url});

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: url,
    );
  }
}
