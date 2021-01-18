import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleView extends StatefulWidget {
  final String imageUrl;
  ArticleView({this.imageUrl});
  @override
  _ArticleViewState createState() => _ArticleViewState();
}
class _ArticleViewState extends State<ArticleView> {
  final Completer<WebViewController> _completer = Completer<WebViewController>();

  Widget build(BuildContext context) {
    return Container(
      child: WebView(
        initialUrl: widget.imageUrl,
        onWebViewCreated: ((WebViewController webViewController){
          _completer.complete(webViewController);
        }),
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );

  }
}

