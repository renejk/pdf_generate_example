import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:share_extend/share_extend.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

generatePdf() async {
  final pdf = pw.Document();

  pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Center(
          child: pw.ListView(
              children:
                  [1, 2, 3, 4, 5].map((e) => pw.Text("Hello World")).toList()),
        ); // Center
      })); // Page

  Directory tempDir = await getApplicationDocumentsDirectory();
  String tempPath = '${tempDir.path}/example.pdf';
  final file = File(tempPath);
  var path = await file.writeAsBytes(await pdf.save());

  return path.path;
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var path = await generatePdf();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfViewer(
                path: path,
              ),
            ),
          );
        },
        tooltip: 'Generate',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PdfViewer extends StatelessWidget {
  const PdfViewer({Key? key, this.path}) : super(key: key);
  final path;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        actions: [
          IconButton(
              onPressed: () {
                // ShareExtend.share(path, 'file');
                Share.shareFiles([path]);
              },
              icon: Icon(Icons.share))
        ],
      ),
      body: Container(
        child: PdfView(path: path),
      ),
    );
  }
}
