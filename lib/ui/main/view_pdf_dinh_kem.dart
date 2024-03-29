import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:path_provider/path_provider.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class ViewPDFDK extends StatefulWidget {
  @override
  _ViewPDF createState() => _ViewPDF();
}

class _ViewPDF extends State<ViewPDFDK> {
  bool isLoading = false;
  String localPath = "";
  int i = 0;
  String PDF_URL = "adf";
  late File files;
  double percentage = 0;
  var url;
  List<ListDataDK> ListDataPDF = [];
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
    PDF_URL = pdfDK;

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
        var vanban = ListpdfDK;
        var lstData =
            (vanban as List).map((e) => ListDataDK.fromJson(e)).toList();
        lstData.forEach((element) {
          ListDataPDF.add(element);
          // print("sdf" +ListDataPDF.toString());
        });
      });
    }
    FlutterDownloader.registerCallback(downloadingCallback);
  }

  Future<File> createFileOfPdfUrl( String url,filename) async {
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
  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///ssending the data
    sendPort?.send([id, status, progress]);
  }

  @override
  void dispose() {
    // TODO: implement initState
    super.dispose();

    // pdfDK = "";
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
    return Stack(
      children: [
        PDF_URL != null
            ? Container(
                margin: EdgeInsets.only(
                  top: 10,
                ),
                child: PDF().fromUrl(
                  PDF_URL, //duration of cache
                  placeholder: (progress) => Center(child: Text('$progress %')),
                  errorWidget: (error) => Center(child: Text("")),
                ))
            : Center(child: CircularProgressIndicator()),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 9,
              child: Container(
                // width: MediaQuery.of(context).size.width *0.85,
                height: MediaQuery.of(context).size.height / 15,
                padding: EdgeInsets.only(left: 10),
                // decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.all(Radius
                //         .circular(8))
                // ),

                child: FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Text("Chọn bản ghi khác"),
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        value: PDF_URL!.isNotEmpty ? PDF_URL : null,
                        isDense: false,
                        isExpanded: true,
                        onChanged: (newValue) async {
                          //  OpenFile.open(files.path);
                          if (mounted) {
                            setState(() {
                              PDF_URL = newValue!;
                            });
                          }
                        },
                        items: ListDataPDF.map((value) {
                          return DropdownMenuItem<String>(
                              value: value.Url,
                              child: RichText(
                                text: TextSpan(
                                  children: [

                                    TextSpan(
                                      text: value.Name,
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.75),
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                              ));
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ),
            Flexible(
                flex: 1,
                child: Container(
                  height: MediaQuery.of(context).size.height / 15,
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    iconSize: 17,
                    icon: Icon(Icons.download_sharp),
                    onPressed: () async {
                      final status = await Permission.storage.request();

                      if (status.isGranted) {
                        setState(() {
                          _isDownloading = !_isDownloading;
                        });
                        final dir = Platform.isAndroid
                            ? await getExternalStorageDirectory() //FOR ANDROID
                            :  await getApplicationSupportDirectory();
                        Dio dio = Dio();
                        String url = "";
                        print(ListDataPDF);

                        for (var item in ListDataPDF) {
                          if (item.Url == PDF_URL) {
                            urlPDF = item.UrlDoc;
                            tenPDF = item.Name;
                            print(urlPDF);
                          }
                        }
                        if (PDF_URL.contains("doc")) {
                          url = urlPDF;
                          await FlutterDownloader.enqueue(
                            url: url,
                             savedDir: '/storage/emulated/0/Download',
                            fileName: tenPDF,
                            showNotification: true,
                            openFileFromNotification: true,
                          );
                          // createFileOfPdfUrl(url,tenPDF);
                        }
                        else if (PDF_URL.contains("xlsx")) {
                          String ten = PDF_URL
                              .split('/')
                              .last;
                          url = PDF_URL;

                          url = PDF_URL;
                          await FlutterDownloader.enqueue(
                            url: url,
                             savedDir: '/storage/emulated/0/Download',
                            fileName: tenPDF,
                            showNotification: true,
                            openFileFromNotification: true,
                          );

                        }
                        else {
                          url = PDF_URL;
                          final id =   await FlutterDownloader.enqueue(
                            url: url,
                            fileName: tenPDF,
                             savedDir: '/storage/emulated/0/Download',
                            showNotification: true,
                            openFileFromNotification: true,

                          );

                        }
                      }
                      else {
                        print("Permission deined");
                      }
                    },

                  ),
                ))
          ],
        ),
        percentageBool == true
            ? Center(
                child: CircularPercentIndicator(
                    radius: 60.0,
                    lineWidth: 5.0,
                    percent: 0.75,
                    center: new Text(downloadMessage,
                        style: TextStyle(color: Color(0xFF535355))),
                    linearGradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: <Color>[Color(0xFF1AB600), Color(0xFF6DD400)]),
                    rotateLinearGradient: true,
                    circularStrokeCap: CircularStrokeCap.round))
            : SizedBox(),
      ],
    );


  }
}

class ListDataDK {
  String Name;
  String Url;
  String UrlDoc;

  ListDataDK({required this.Name, required this.Url, required this.UrlDoc});

  factory ListDataDK.fromJson(Map<String, dynamic> json) {
    return ListDataDK(
        Name: json['Name'] != null ? json['Name'] : "",
        Url: json['Url'] != null ? json['Url'] : "",
        UrlDoc: json['Url1'] != null ? json['Url1'] : "");
  }
}
