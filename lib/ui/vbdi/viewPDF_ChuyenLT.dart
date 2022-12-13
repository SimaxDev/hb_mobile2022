import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
// import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';


class ViewPDFLT extends StatefulWidget {
  @override
  _ViewPDF createState() => _ViewPDF();
}

class _ViewPDF extends State<ViewPDFLT> {
  bool isLoading = false;
  String localPath = "";
  int i = 0;
  String PDF_URL = "adf";
  late File files;
  double percentage = 0;
  var url;
  List<ListDataP> ListDataPDF = [];
  late SharedPreferences sharedStorage;
  String remotePDFpath = "";
  int pages = 0;
  int currentPage = 0;
  final Completer<PDFViewController> _controller =
  Completer<PDFViewController>();
  String downloadMessage = "Initalizing...";
  bool _isDownloading = false;
  bool percentageBool = false;
  String pathPDF = "";
  String tenPDF = "";
  String urlPDF = "";
  int progress = 0;

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///ssending the data
    sendPort!.send([id, status, progress]);
  }



  Future<String> loadPDF(String urlPDF) async {
    url = Uri.parse(urlPDF);
    print(url);
    var response = await http.get(url);
    //var dir = await getApplicationSupportDirectory();//truy cap vao muc
    // chinh
    //File file =  new File(dir.path+"/vanbanmoi.pdf");// tao 1 tep moi
    final filename = urlPDF.substring(urlPDF.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(urlPDF));
    var dir = await getApplicationSupportDirectory();
    print("Download files");
    print("${dir.path}/$filename");
    files = File("${dir.path}/$filename");
    // setState(() {
    //   isLoading = true;
    //   file =  new File(dir.path+"/vanbanmoi.pdf");// tao 1 tep moi
    // });
    await files.writeAsBytes(response.bodyBytes, flush: true);
    return files.path;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //_initializeTimer();
    PDF_URL = pdf;

    // createFileOfPdfUrl().then((f) {
    //   setState(() {
    //     pathPDF = f.path;
    //     print(pathPDF);
    //   });
    // });
    //
    // GetPDF(PDF_URL);
    //this.fetchData();
    if (mounted) {
      setState(() {
        var vanban = Listpdf;
        var lstData =
        (vanban as List).map((e) => ListDataP.fromJson(e)).toList();
        lstData.forEach((element) {
          ListDataPDF.add(element);
          // print("sdf" +ListDataPDF.toString());
        });
      });
    }
    FlutterDownloader.registerCallback(downloadingCallback);
  }

  Future<File> createFileOfPdfUrl(String url, filename) async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
      // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
      // final url = "https://pdfkit.org/docs/guide.pdf";
      // final url = PDF_URL;
      // final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getExternalStorageDirectory();
      print("Download files");
      print("${dir!.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  // Future openFile({required String url, required String fileName}) async {
  //   final file = await downloadFile(url, fileName);
  //   if (file == null) return;
  //   print('Path: ${file.path}');
  //   await OpenFile.open(file.path);
  // }

  Future<File?> downloadFile(String url, String name) async {
    try {
      final appStorage = await getApplicationDocumentsDirectory();
      final file = File('${appStorage.path}/$name');
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ),
      );
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    // TODO: implement initState
    super.dispose();

    // pdf = "";
  }

  GetPDF(String PDFD) async {
    loadPDF(PDFD).then((value) {
      if (mounted) {
        setState(() {
          localPath = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(

        child:PDF_URL != null
            ?PDF().fromUrl(
          PDF_URL, //duration of cache
          placeholder: (progress) => Center(child: Text('$progress %')),
          errorWidget: (error) => Center(child: Text("")),
        )
            : Center(child: CircularProgressIndicator()),)
          
      );


  }
}

class ListDataP {
  String Name;
  String Url;
  String UrlDoc;

  ListDataP({required this.Name, required this.Url, required this.UrlDoc});

  factory ListDataP.fromJson(Map<String, dynamic> json) {
    return ListDataP(
        Name: json['Name'] != null ? json['Name'] : "",
        Url: json['Url'] != null ? json['Url'] : "",
        UrlDoc: json['Url1'] != null ? json['Url1'] : "");
  }
}
