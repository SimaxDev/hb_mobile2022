import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:get/get.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';


class ViewPDFVB extends StatefulWidget {
  @override
  _ViewPDF createState() => _ViewPDF();
}

class _ViewPDF extends State<ViewPDFVB> {
  bool isLoading = false;
  String localPath = "";
  int i = 0;
  String PDF_URL = "adf";
  File files;
  double percentage = 0;
  var url;
  List<ListDataP> ListDataPDF = [];
  SharedPreferences sharedStorage;
  String remotePDFpath = "";
  int pages = 0;
  int currentPage = 0;
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  Timer _timer;
  String downloadMessage = "Initalizing...";
  bool _isDownloading = false;
  bool percentageBool = false;
  String pathPDF = "";
  String tenPDF = "";
  String urlPDF = "";
  int progress = 0;

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///ssending the data
    sendPort.send([id, status, progress]);
  }

  void _initializeTimer() {
    _timer = Timer.periodic(const Duration(minutes: 5), (_) {
      if (mounted) {
        logOut(context);
      }

      _timer.cancel();
    });
  }

  void _handleUserInteraction([_]) {
    if (!_timer.isActive) {
      // This means the user has been logged out
      return;
    }

    _timer.cancel();
    _initializeTimer();
  }

  Future<String> loadPDF(String urlPDF) async {
    url = Uri.parse(urlPDF);
    print(url);
    var response = await http.get(url);
    //var dir = await getApplicationDocumentsDirectory();//truy cap vao muc
    // chinh
    //File file =  new File(dir.path+"/vanbanmoi.pdf");// tao 1 tep moi
    final filename = urlPDF.substring(urlPDF.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(urlPDF));
    var dir = await getApplicationDocumentsDirectory();
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
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  Future openFile({String url, String fileName}) async {
    final file = await downloadFile(url, fileName);
    if (file == null) return;
    print('Path: ${file.path}');
    await OpenFile.open(file.path);
  }

  Future<File> downloadFile(String url, String name) async {
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

    pdf = "";
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
                  //errorWidget: (error) => Center(child: Text(error.toString())),
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
                        value: PDF_URL,
                        isDense: false,
                        isExpanded: true,
                        onChanged: (newValue) async {
                          //  OpenFile.open(files.path);
                          if (mounted) {
                            setState(() {
                              PDF_URL = newValue;
                            });
                          }
                        },
                        items: ListDataPDF.map((value) {
                          return DropdownMenuItem<String>(
                              value: value.Url,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    // WidgetSpan(
                                    //   child: Image(
                                    //     height: 30,
                                    //     width:20,
                                    //     image: value.Name != null &&value.Name != ""
                                    //         ?value.Name
                                    //         .contains("pdf")
                                    //         ?AssetImage('assets/pdf.png'):(value.Name
                                    //         .contains("doc")?AssetImage('assets/doc'
                                    //         '.png'):(value.Name
                                    //         .contains("docx")?AssetImage('assets/docx'
                                    //         '.png'): AssetImage('assets/logo_vb.png'))): AssetImage('assets/logo_vb.png'),
                                    //
                                    //   ),
                                    // ),
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
                        final dir = await getExternalStorageDirectory();
                        Dio dio = Dio();
                        String url = "";

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
                            savedDir: dir.path,
                            fileName: tenPDF,
                            showNotification: true,
                            openFileFromNotification: true,
                          );
                          // createFileOfPdfUrl(url,tenPDF);
                        } else if (PDF_URL.contains("xlsx")) {
                          String ten = PDF_URL.split('/').last;
                          url = PDF_URL;

                          url = PDF_URL;
                          await FlutterDownloader.enqueue(
                            url: url,
                            savedDir: dir.path,
                            fileName: tenPDF,
                            showNotification: true,
                            openFileFromNotification: true,
                          );
                          // dio.download(url, '${dir.path}/$ten',
                          //     onReceiveProgress: (actualbytes, totalbytes) {
                          //       percentage = actualbytes / totalbytes * 100;
                          //
                          //       setState(() {
                          //         percentageBool = true;
                          //         downloadMessage =
                          //         'Downloading... ${percentage.floor()}'
                          //             ' %';
                          //         if (percentage < 100) {
                          //         } else {
                          //           setState(() {
                          //             percentageBool = false;
                          //           });
                          //         }
                          //       });
                          //     });
                          // print(dir.path ?? '');
                          // print('dio  ' + dio.toString());
                        } else {
                          url = PDF_URL;
                          final id = await FlutterDownloader.enqueue(
                            url: url,
                            fileName: tenPDF,
                            savedDir: dir.path,
                            showNotification: true,
                            openFileFromNotification: true,
                          );

                          // String ten =  PDF_URL.split('/').last;
                          // dio.download(url, '${dir.path}/$ten',
                          //     onReceiveProgress: (actualbytes, totalbytes) {
                          //       percentage = actualbytes / totalbytes * 100;
                          //
                          //       setState(() {
                          //         percentageBool = true;
                          //         downloadMessage =
                          //         'Downloading... ${percentage.floor()}'
                          //             ' %';
                          //         if (percentage < 100) {
                          //         } else {
                          //           setState(() {
                          //             percentageBool = false;
                          //           });
                          //         }
                          //       });
                          //     });
                          // print(dir.path ?? '');
                          // print('dio  ' + dio.toString());
                      }
                      } else {
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

    // return GestureDetector(
    //     onTap: _handleUserInteraction,
    //     onPanDown: _handleUserInteraction,
    //     onScaleStart: _handleUserInteraction,
    //     child:Stack(children: [
    //   PDF_URL!= null?Container(
    //
    //       margin: EdgeInsets.only(top:MediaQuery.of(context).size.height /25,),
    //       child: PDF().fromUrl(
    //         PDF_URL, //duration of cache
    //         placeholder: (progress) => Center(child: Text('$progress %')),
    //         //errorWidget: (error) => Center(child: Text(error.toString())),
    //       )
    //   ):Center(child: CircularProgressIndicator()),
    //   Row(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     // mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Container(
    //         width: MediaQuery.of(context).size.width *0.85,
    //         height: MediaQuery.of(context).size.height /15,
    //         padding: EdgeInsets.only(left: 10),
    //         // decoration: BoxDecoration(
    //         //     color: Colors.white,
    //         //     borderRadius: BorderRadius.all(Radius
    //         //         .circular(8))
    //         // ),
    //
    //         child:FormField<String>(
    //           builder: (FormFieldState<String> state) {
    //             return DropdownButtonHideUnderline(
    //               child: DropdownButton<String>(
    //                 hint: Text("Chọn bản ghi khác"),
    //                 style: TextStyle(fontSize: 14,color: Colors.black),
    //                 value: PDF_URL  ,
    //                 isDense: false,
    //                 isExpanded: true,
    //                 onChanged: (newValue) async {
    //                   //  OpenFile.open(files.path);
    //                   if(mounted){
    //                     setState(() {
    //
    //                       PDF_URL=newValue;
    //                       // createFileOfPdfUrl();
    //                       // final filename = newValue.substring(newValue
    //                       //  .lastIndexOf("/") + 1);
    //
    //
    //
    //
    //                       // Navigator.of(context).pushAndRemoveUntil(
    //                       //     MaterialPageRoute(
    //                       //         builder: (BuildContext context) => ViewPDFVB_con(viewPDF:newValue)),
    //                       //         (Route<dynamic> route) => true);
    //
    //                       //
    //                       // Navigator.push(
    //                       //   context,
    //                       //   MaterialPageRoute(
    //                       //       builder: (context) => viewDoc(viewPDF:newValue)
    //                       //   ),
    //                       // );
    //
    //                       // GetDataKeyWord("","","",IDCoQuan);
    //                     });
    //                   }
    //                 },
    //                 items:
    //                 ListDataPDF.map((value) {
    //                   return DropdownMenuItem<String>(
    //                       value: value.Url,
    //                       child:RichText(
    //                         text: TextSpan(
    //                           children: [
    //
    //                             // WidgetSpan(
    //                             //   child: Image(
    //                             //     height: 30,
    //                             //     width:20,
    //                             //     image: value.Name != null &&value.Name != ""
    //                             //         ?value.Name
    //                             //         .contains("pdf")
    //                             //         ?AssetImage('assets/pdf.png'):(value.Name
    //                             //         .contains("doc")?AssetImage('assets/doc'
    //                             //         '.png'):(value.Name
    //                             //         .contains("docx")?AssetImage('assets/docx'
    //                             //         '.png'): AssetImage('assets/logo_vb.png'))): AssetImage('assets/logo_vb.png'),
    //                             //
    //                             //   ),
    //                             // ),
    //                             TextSpan(text:value.Name, style: TextStyle(
    //                                 color: Colors.black.withOpacity(0.75),
    //                                 fontStyle: FontStyle.normal,
    //                                 fontWeight: FontWeight.w400,
    //                                 fontSize: 13),
    //
    //                             ),
    //                           ],
    //                         ),
    //                       )
    //
    //                   );
    //                 }).toList(),
    //               ),
    //             );
    //           },
    //         ),
    //       ),
    //       Align(
    // alignment: Alignment.topRight,
    //         child: IconButton(iconSize: 17,
    //           icon:Icon(Icons.download_sharp) ,
    //           onPressed: () async {
    //
    //
    //             setState(() {
    //               _isDownloading = !_isDownloading;
    //
    //             });
    //             var dir = await getExternalStorageDirectory();
    //
    //             Dio dio = Dio();
    //             dio.download(PDF_URL,
    //                 '${dir.path}/$namepdf',onReceiveProgress: (actualbytes,
    //                     totalbytes){
    //                   percentage =  actualbytes/totalbytes*100;
    //
    //                   setState(() {
    //                     percentageBool = true;
    //                     downloadMessage =  'Downloading... ${percentage.floor()}'
    //                         ' %';
    //                     if(percentage <100){
    //
    //                     }
    //                     else{
    //                       setState(() {
    //                         percentageBool = false;
    //                       });
    //                     }
    //                   });
    //                 });
    //             print(downloadMessage??'');
    //             print('dio  '+ dio.toString());
    //           },
    //         ),
    //       )
    //
    //     ],),
    //   percentageBool == true ?  Center(
    //       child: CircularPercentIndicator(
    //           radius: 60.0,
    //           lineWidth: 5.0,
    //           percent: 0.75,
    //           center: new Text(downloadMessage, style: TextStyle(color: Color(0xFF535355))),
    //           linearGradient: LinearGradient(begin: Alignment.topRight,end:Alignment.bottomLeft, colors: <Color>    [Color(0xFF1AB600),Color(0xFF6DD400)]),rotateLinearGradient: true,
    //           circularStrokeCap: CircularStrokeCap.round)):SizedBox(),
    //
    //
    // ],));
  }
}

class ListDataP {
  String Name;
  String Url;
  String UrlDoc;

  ListDataP({this.Name, this.Url, this.UrlDoc});

  factory ListDataP.fromJson(Map<String, dynamic> json) {
    return ListDataP(
        Name: json['Name'] != null ? json['Name'] : "",
        Url: json['Url'] != null ? json['Url'] : "",
        UrlDoc: json['Url1'] != null ? json['Url1'] : "");
  }
}
