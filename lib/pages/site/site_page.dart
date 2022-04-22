import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SitePage extends StatefulWidget {
  @override
  State<SitePage> createState() => _SitePageState();
}

class _SitePageState extends State<SitePage> {
  bool _showProgress = true;
  /// https://github.com/flutter/flutter/wiki/Hybrid-Composition
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nosso site"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: bodyWebView(),
    );
  }

  bodyWebView() {
    return Stack(
      children: [
        Column(
          children: <Widget>[
            Expanded(
                child: WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: "https://flutter.dev",
              onPageFinished: _onPageFinished,
            ))
          ],
        ),
        Opacity(
          opacity: _showProgress ? 1 : 0,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
      ],
    );
  }

  // void _onClickRefresh() {
  //   this.controller.reload();
  // }

  void _onPageFinished(String value) {
    print("onPageFinished");
    setState(() {
      _showProgress = false;
    });
  }

//another way to show CircularProgressIndicator before page loads
// IndexedStack(
// index: _stackIndex,
// children: [
// Column(
// children: <Widget>[
// Expanded(child: WebView(
// javascriptMode: JavascriptMode.unrestricted,
// initialUrl: "https://www.flutter.dev",
// onPageFinished: _onPageFinished,
// ))
// ],
// ),
// Container(
// color: Colors.white,
// child: Center(
// child: CircularProgressIndicator(),
// ),
// )
// ],
//
//
// );
}
