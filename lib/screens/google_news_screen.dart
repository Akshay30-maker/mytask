
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import '../constatnts/color_constants.dart';
import 'helper/theme_provider.dart';

class GoogleNewsScreen extends StatefulWidget {
  final String url;
  final String title;
  final String name;

  GoogleNewsScreen({Key? key, required this.url,required this.title, required this.name}) : super(key: key);

  @override
  State<GoogleNewsScreen> createState() => _GoogleNewsScreenState();
}

class _GoogleNewsScreenState extends State<GoogleNewsScreen> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: themeProvider.isDarkMode ? DarkPrimaryColor : LightPrimaryColor,
        iconTheme: IconThemeData(
        ),
        title: Text(
          widget.name,
          style: TextStyle( fontFamily: 'Nunito-ExtraBold',fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onPageFinished: (String url) {
              setState(() {
                _isLoading = false;
              });
            },
            onWebResourceError: (WebResourceError error) {
              // Handle web resource errors here
              print("WebResourceError: $error");
            },
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(color: Color(0xffef5252),),
            ),
        ],
      ),
    );
  }
}
