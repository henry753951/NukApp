// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:unicons/unicons.dart';
import 'theme.dart';
import 'user.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class NewWindow extends StatefulWidget {
  String url = "";
  String title = "";
  NewWindow({Key? key, required this.url, required this.title})
      : super(key: key);

  @override
  State<NewWindow> createState() => _NewWindowState();
}

class _NewWindowState extends State<NewWindow> {
  late InAppWebViewController _webViewController;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              child: InAppWebView(
                initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                      javaScriptCanOpenWindowsAutomatically: true,
                      useShouldOverrideUrlLoading: true,
                      javaScriptEnabled: true),
                ),
                onWebViewCreated: (InAppWebViewController controller) {
                  _webViewController = controller;
                },
                onLoadStop: (controller, url) async {
                  await controller.evaluateJavascript(source: """
var divs = document.getElementsByClassName("M23");
[].forEach.call(divs, function (div) {
    div.style.position = "static";
    div.style.zIndex = "999";
    div.style.padding = "1rem";
    div.style.backgroundColor = "white";
    div.style.minHeight = "100vh";
});

var div = document.getElementById("Dyn_head");
div.style.display = "none";
var div = document.getElementById("Dyn_footer");
div.style.display = "none";
var divs = document.getElementsByClassName("M3");
[].forEach.call(divs, function (div) {
    div.style.display = "none";
});

var divs = document.getElementsByClassName("M42");
[].forEach.call(divs, function (div) {
    div.style.display = "none";
});

undefined
var divs = document.getElementsByClassName("M23");
[].forEach.call(divs, function (div) {
    div.style.position = "static";
    div.style.zIndex = "999";
    div.style.padding = "1rem";
    div.style.backgroundColor = "white";
});

var div = document.getElementById("Dyn_head");
div.style.display = "none";
var div = document.getElementById("Dyn_footer");
div.style.display = "none";
var divs = document.getElementsByClassName("M3");
[].forEach.call(divs, function (div) {
    div.style.display = "none";
});

var divs = document.getElementsByClassName("M42");
[].forEach.call(divs, function (div) {
    div.style.display = "none";
});

var divs = document.getElementsByClassName("mrow container");
[].forEach.call(divs, function (div) {
    div.style.marginTop = "0";
    div.style.paddingLeft = "0";
    div.style.paddingRight = "0";
});

              """);
                  await Future.delayed(Duration(milliseconds: 80));
                  setState(() {
                    loading = false;
                  });
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url!;
                  print(uri.toString());
                  await launchUrl(uri,
                      mode: LaunchMode.externalNonBrowserApplication);
                  // and cancel the request
                  return NavigationActionPolicy.CANCEL;
                },
              ),
            ),
            Positioned(
              child: AnimatedOpacity(
                opacity: loading ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
                child: IgnorePointer(
                  child: Container(
                    height: double.infinity,
                    width: double.maxFinite,
                    color: Theme.of(context).backgroundColor,
                    child: LoadingAnimationWidget.inkDrop(
                      color: Theme.of(context).primaryColor,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

            // var div = document.getElementById("Dyn_2_3");
            // div.style.position = "static";
            // div.style.zIndex = "999";
            // div.style.backgroundColor = "white";
            // var div = document.getElementById("Dyn_head");
            // div.style.display = "none";
            // var div = document.getElementById("Dyn_footer");
            // div.style.display = "none";
            // var div = document.getElementById("Dyn_2_1");
            // div.style.display = "none";
            // var div = document.getElementById("Dyn_2_2");
            // div.style.display = "none";