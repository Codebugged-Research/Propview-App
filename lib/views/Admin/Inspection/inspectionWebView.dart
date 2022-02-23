import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class InspectionWebView extends StatefulWidget {
  final String url;
  const InspectionWebView({this.url});

  @override
  _InspectionWebViewState createState() => _InspectionWebViewState();
}

class _InspectionWebViewState extends State<InspectionWebView> {
  String url = "";
  @override
  void initState() {
    super.initState();
    url = widget.url;
    WebView.platform = AndroidWebView();
  }

  WebViewController controller;
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  int progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var response = await http.get(Uri.parse(url));
          if (response.statusCode == 200) {
            String htmlToParse = response.body;
            final path = await _localPath;
            final filename =
                "propdial_inspection_report_${url.split("/").last}";
            File generatedPdfFile =
                await FlutterHtmlToPdf.convertFromHtmlContent(
                    htmlToParse, path, filename);
            Share.shareFiles(['${generatedPdfFile.path}'],
                text: 'Inspection Report');
          }
        },
        child: Icon(Icons.share),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            controller = webViewController;
          },
        ),
      ),
    );
  }
}
