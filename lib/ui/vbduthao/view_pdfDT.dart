// import 'dart:async';
// import 'dart:convert';
// import 'dart:isolate';
// import 'dart:ui';
// import 'package:dio/dio.dart';
// import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:hb_mobile2021/core/services/VbdenService.dart';
// import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ViewPDFDT extends StatefulWidget {
//   final int idDuThao;
//   final String nam;
//   final double pdfWidth;
//   final double pdfHeight;
//   final double top;
//   final String ViewPDF;
//   final double left;
//
//   ViewPDFDT(
//       {required this.idDuThao,
//       required this.nam,
//       required this.pdfHeight,
//       required this.left,
//       required this.ViewPDF,
//       required this.top,
//       required this.pdfWidth});
//
//   @override
//   _ViewPDF createState() => _ViewPDF();
// }
//
// extension GlobalKeyExtension on GlobalKey {
//   Rect? get globalPaintBound {
//     final renderObject = currentContext?.findRenderObject();
//     var translation = renderObject?.getTransformTo(null).getTranslation();
//     if (translation != null && renderObject?.paintBounds != null) {
//       return renderObject!.paintBounds
//           .shift(Offset(translation.x, translation.y));
//     } else {
//       return null;
//     }
//   }
// }
//
// class _ViewPDF extends State<ViewPDFDT> {
//   GlobalKey _key = GlobalKey();
//   var _x = 0.0;
//   var _y = 0.0;
//   final GlobalKey stackKey = GlobalKey();
//
//   late PDFViewController _pdfViewController;
//   double pdfWidth = 612.0;
//   double pdfHeight = 792.0;
//   Completer<PDFViewController> pdfController = Completer<PDFViewController>();
//   bool pdfReload = false;
//
//   double width = 75.0, height = 65.0;
//   bool isLoading = false;
//   bool chekKy = false;
//   late String localPath;
//   String namefile = namepdf;
//   String namefilePDF = "";
//   SharedPreferences sharedStorage;
//   double widthCK = 110, heightCK = 60;
//   GlobalKey stickyKeyPositioned = GlobalKey();
//   double top, left;
//   double relX, relY;
//   double xOff, yOff;
//   bool _visibleSign = false;
//   int _currentPage = 1;
//   String encodedImage;
//   GlobalKey stickyKey = GlobalKey();
//   GlobalKey stickyKeyPdf = GlobalKey();
//   String pdfGui = "";
//   String pdfCu = "";
//   String NameMoi = "";
//   String UrlMoi = "";
//   bool _enableSwipe = true;
//   double xz, yz;
//   final keyText = GlobalKey();
//   Size size;
//   Offset position;
//   bool pdfReady = false;
//
//   Offset offset = Offset.zero;
//   String PDF_URL = "";
//
//   File file;
//   var url;
//   List<ListDataP> ListDataPDF = [];
//
//   String downloadMessage = "Initalizing...";
//   bool _isDownloading = false;
//   bool percentageBool = false;
//   String pathPDF = "";
//   bool checkKySo = false;
//   bool load = false;
//   double percentage = 0;
//   String tenPDF = "";
//   String urlPDF = "";
//
//   GetPDF(String PDFD) async {
//     loadPDF(PDFD).then((value) {
//       if (mounted) {
//         setState(() {
//           localPath = value;
//         });
//       }
//     });
//   }
//
//   Future<String> loadPDF(String urlPDF) async {
//     url = Uri.parse(urlPDF);
//     print(url);
//     var response = await http.get(url);
//     //var dir = await getApplicationSupportDirectory();//truy cap vao muc
//     // chinh
//     //File file =  new File(dir.path+"/vanbanmoi.pdf");// tao 1 tep moi
//     final filename = urlPDF.substring(urlPDF.lastIndexOf("/") + 1);
//     var request = await HttpClient().getUrl(Uri.parse(urlPDF));
//     var dir = await getApplicationSupportDirectory();
//     print("Download files");
//     print("${dir.path}/$filename");
//     file = File("${dir.path}/$filename");
//     // setState(() {
//     //   isLoading = true;
//     //   file =  new File(dir.path+"/vanbanmoi.pdf");// tao 1 tep moi
//     // });
//     await file.writeAsBytes(response.bodyBytes, flush: true);
//     return file.path;
//   }
//
//   Future<File> createFileOfPdfUrl(String url, filename) async {
//     Completer<File> completer = Completer();
//     print("Start download file from internet!");
//     try {
//       // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
//       // final url = "https://pdfkit.org/docs/guide.pdf";
//       // final url = PDF_URL;
//       // final filename = url.substring(url.lastIndexOf("/") + 1);
//       var request = await HttpClient().getUrl(Uri.parse(url));
//       var response = await request.close();
//       var bytes = await consolidateHttpClientResponseBytes(response);
//       var dir = await getExternalStorageDirectory();
//       print("Download files");
//       print("${dir.path}/$filename");
//       File file = File("${dir.path}/$filename");
//
//       await file.writeAsBytes(bytes, flush: true);
//       completer.complete(file);
//     } catch (e) {
//       throw Exception('Error parsing asset file!');
//     }
//
//     return completer.future;
//   }
//
//   void _getRenderOffsets() {
//     final RenderBox renderBoxWidget =
//         stickyKeyPositioned.currentContext.findRenderObject();
//     final offset = renderBoxWidget.localToGlobal(Offset.zero);
//
//     yOff = offset.dy - this.top;
//     xOff = offset.dx - this.left;
//   }
//
//
//   void _afterLayout(_) {
//     _getRenderOffsets();
//   }
//
//   @override
//   Future<void> initState() {
//     // _initializeTimer();
//     // TODO: implement initState
//     super.initState();
//     PDF_URL = pdf;
//     if (widget.ViewPDF != null) {
//       PDF_URL = widget.ViewPDF;
//     }
//     GetPDF(PDF_URL);
//     pdfWidth = widget.pdfWidth;
//     pdfHeight = widget.pdfHeight;
//
//     position = Offset(0, 0);
//     top = widget.top;
//     left = widget.left;
//     WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
//     //this.fetchData();
//     if (mounted) {
//       setState(() {
//         var vanban = Listpdf;
//         var lstData =
//             (vanban as List).map((e) => ListDataP.fromJson(e)).toList();
//         lstData.forEach((element) {
//           ListDataPDF.add(element);
//         });
//       });
//     }
//     FlutterDownloader.registerCallback(downloadingCallback);
//   }
//
//   static downloadingCallback(id, status, progress) {
//     ///Looking up for a send port
//     SendPort sendPort = IsolateNameServer.lookupPortByName("downloading");
//
//     ///ssending the data
//     sendPort.send([id, status, progress]);
//   }
//
//   @override
//   void didChangeMetrics() {
//     if (Platform.isAndroid) {
//       // for rotations on Android
//       pdfController = Completer<PDFViewController>();
//       //pdfReload = true;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size siz = MediaQuery.of(context).size;
//
//     return Scaffold(
//         body: Stack(
//           key: stackKey, // 3.
//           //fit: StackFit.expand,
//           children: [
//             !pdfReady
//                 ? Center(
//               child: CircularProgressIndicator(),
//             )
//                 : Offstage(),
//             localPath != null
//                 ? Container(
//               key: stickyKeyPdf,
//               margin: EdgeInsets.only(left: 0, right: 0, top: 30),
//               child: PDFView(
//                 enableSwipe: true,
//                 autoSpacing: false,
//                 pageFling: true,
//                 pageSnap: true,
//                 fitPolicy: FitPolicy.BOTH,
//                 preventLinkNavigation: false,
//                 key: ValueKey(localPath),
//                 filePath: localPath,
//                 swipeHorizontal: false,
//                 nightMode: false,
//                 onError: (e) {},
//                 // onViewCreated:
//                 //     (PDFViewController pdfViewController) {
//                 //   pdfController.complete(pdfViewController);
//                 // },
//                 onRender: (_pages) {
//                   setState(() {
//                     pdfReady = true;
//                   });
//                 },
//                 onPageChanged: (int page, int total) {
//                   setState(() {
//                     _currentPage = page;
//                   });
//                 },
//               ),
//             )
//                 : Container(),
//             !pdfReady
//                 ? Center(
//               child: CircularProgressIndicator(),
//             )
//                 : Offstage(),
//             Positioned(
//               key: stickyKeyPositioned,
//               left: left,
//               top: top,
//               child: Visibility(
//                 visible: _visibleSign,
//                 child: Draggable(
//                   child: Container(
//                     margin: EdgeInsets.only(top: 40),
//                     width: width,
//                     height: height,
//                     color: Colors.transparent,
//                     child: Center(
//                         child: (encodedImage != null &&
//                             encodedImage != "")
//                             ? Image.memory(
//                           base64.decode(encodedImage),
//                           width: width,
//                           height: height,
//                         )
//                             : Image(
//                           image:
//                           AssetImage('assets/signature.png'),
//                           width: width,
//                           height: height,
//                         )),
//                   ),
//                   feedback: Center(
//                       child: (encodedImage != null &&
//                           encodedImage != "")
//                           ? Image.memory(
//                         base64.decode(encodedImage),
//                         width: width,
//                         height: height,
//                       )
//                           : Image(
//                         image: AssetImage('assets/signature.png'),
//                         width: width,
//                         height: height,
//                       )), // 8.
//                   childWhenDragging: Container(), // 9.
//                   onDragEnd: (drag) async {
//                     final parentPos = stickyKeyPdf.globalPaintBound;
//                     setState(() {
//                       if (parentPos == null) return;
//                       left = drag.offset.dx - parentPos.left; // 11.
//                       top = (drag.offset.dy - parentPos.top) -40;
//                     });
//                     final keyContext
//                     = stickyKeyPdf.currentContext;
//                     final box =
//                     keyContext.findRenderObject() as RenderBox;
//                     final pos = box.localToGlobal(Offset.zero);
//                     double ratioW = pdfWidth / (box.size.width);
//                     double ratio = (box.size.width) / pdfWidth;
//                     final boxWidth = box.size.width;
//
//                     final boxHeight = pdfHeight * ratio;
//
//                     // setState(() {
//                     //   top = drag.offset.dy - (box.size.height * 0.2);
//                     //   left = drag.offset.dx;
//                     // });
//
//                     double dy = (box.size.height -
//                         (top+25) -
//                         height -
//                         ((box.size.height - boxHeight) / 2));
//                     double ratioH = pdfHeight / (boxHeight);
//
//                     double dx = (left * ratioW);
//                     double dy1 = (dy * ratioH);
//
//                     // print("chièu dài PhepTinh: " +
//                     //     (siz.height - dragDetails.offset.dy).toString());
//
//                     // print('_currentPage: ====$_currentPage');
//                     // print('dx: ====$dx');
//                     // print('dy: ====$dy');
//                     // print('width: ====${(width * ratioW).toInt()}');
//                     // print('height: ====${(height * ratioW).toInt()}');
//                     //
//                     PDF_URL.substring(0, 38);
//                     pdfCu = PDF_URL.substring(36, PDF_URL.length);
//                     EasyLoading.show();
//
//                     /// String vbtimkiem ;
//                     String vbtimkiem = await postKySim(
//                         widget.idDuThao,
//                         "KySim",
//                         widget.nam,
//                         ((left * ratioW) + (width * 1 / 2)).toString(),
//                         (dy1 + height).toString(),
//                         (width * ratioW).toString(),
//                         (height * ratioW).toString(),
//                         pdfCu,
//                         _currentPage,
//                         namefile);
//
//                     if (mounted) {
//                       setState(() {
//                         var duthaoList =
//                         json.decode(vbtimkiem)['OData'];
//                         NameMoi = duthaoList['Name'];
//                         UrlMoi = duthaoList['Url'];
//                         chekKy = true;
//                         EasyLoading.dismiss();
//                       });
//                     }
//                   },
//                 ),
//               ),
//             ),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               // mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Flexible(
//                   flex: 9,
//                   child: Container(
//                     // width: MediaQuery.of(context).size.width *0.85,
//                     height: MediaQuery.of(context).size.height / 15,
//                     padding: EdgeInsets.only(left: 10),
//                     // decoration: BoxDecoration(
//                     //     color: Colors.white,
//                     //     borderRadius: BorderRadius.all(Radius
//                     //         .circular(8))
//                     // ),
//
//                     child: FormField<String>(
//                       builder: (FormFieldState<String> state) {
//                         return DropdownButtonHideUnderline(
//                           child: DropdownButton<String>(
//                             hint: Text("Chọn bản ghi khác"),
//                             style: TextStyle(fontSize: 14, color: Colors.black),
//                             value: PDF_URL,
//                             isDense: false,
//                             isExpanded: true,
//                             onChanged: (newValue) async {
//                               //  OpenFile.open(files.path);
//                               if (mounted) {
//                                 setState(() {
//                                   PDF_URL = newValue;
//                                   GetPDF(PDF_URL);
//                                   for (var i in chuaPDF) {
//                                     if (PDF_URL == i['Url']) {
//                                       setState(() {
//                                         tenPDFTruyen = i['Name'];
//                                       });
//                                     }
//                                   }
//                                 });
//                               }
//                             },
//                             items: ListDataPDF.map((value) {
//                               String a = value.Url;
//                               // tenPDFTruyen =  value.Name;
//                               return DropdownMenuItem<String>(
//                                   value: value.Url,
//                                   child: RichText(
//                                     text: TextSpan(
//                                       children: [
//                                         TextSpan(
//                                           text: value.Name,
//                                           style: TextStyle(
//                                               color: Colors.black
//                                                   .withOpacity(0.75),
//                                               fontStyle: FontStyle.normal,
//                                               fontWeight: FontWeight.w400,
//                                               fontSize: 13),
//                                         ),
//                                       ],
//                                     ),
//                                   ));
//                             }).toList(),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 Flexible(
//                     flex: 1,
//                     child: Container(
//                       height: MediaQuery.of(context).size.height / 15,
//                       alignment: Alignment.centerRight,
//                       child: IconButton(
//                         iconSize: 17,
//                         icon: Icon(Icons.download_sharp),
//                         onPressed: () async {
//                           final status = await Permission.storage.request();
//
//                           if (status.isGranted) {
//                             setState(() {
//                               _isDownloading = !_isDownloading;
//                             });
//                             final dir = Platform.isAndroid
//                                 ? await getExternalStorageDirectory() //FOR ANDROID
//                                 :  await getApplicationSupportDirectory();
//                             Dio dio = Dio();
//
//                             for (var item in ListDataPDF) {
//                               if (item.Url == PDF_URL) {
//                                 urlPDF = item.UrlDoc;
//                                 tenPDF = item.Name;
//                                 print(urlPDF);
//                               }
//                             }
//                             if (PDF_URL.contains("doc")) {
//                               url = urlPDF;
//                               await FlutterDownloader.enqueue(
//                                 url: url,
//                                 savedDir: dir.path,
//                                 fileName: tenPDF,
//                                 showNotification: true,
//                                 openFileFromNotification: true,
//                               );
//                               // createFileOfPdfUrl(url,tenPDF);
//                             } else if (PDF_URL.contains("xlsx")) {
//                               String ten = PDF_URL.split('/').last;
//                               url = PDF_URL;
//
//                               url = PDF_URL;
//                               await FlutterDownloader.enqueue(
//                                 url: url,
//                                 savedDir: dir.path,
//                                 fileName: tenPDF,
//                                 showNotification: true,
//                                 openFileFromNotification: true,
//                               );
//                               // dio.download(url, '${dir.path}/$ten',
//                               //     onReceiveProgress: (actualbytes, totalbytes) {
//                               //       percentage = actualbytes / totalbytes * 100;
//                               //
//                               //       setState(() {
//                               //         percentageBool = true;
//                               //         downloadMessage =
//                               //         'Downloading... ${percentage.floor()}'
//                               //             ' %';
//                               //         if (percentage < 100) {
//                               //         } else {
//                               //           setState(() {
//                               //             percentageBool = false;
//                               //           });
//                               //         }
//                               //       });
//                               //     });
//                               // print(dir.path ?? '');
//                               // print('dio  ' + dio.toString());
//                             } else {
//                               url = PDF_URL;
//                               final id = await FlutterDownloader.enqueue(
//                                 url: url,
//                                 fileName: tenPDF,
//                                 savedDir: dir.path,
//                                 showNotification: true,
//                                 openFileFromNotification: true,
//                               );
//
//                             }
//
//                           }
//                           else{
//
//                           }
//                         },
//                       ),
//                     ))
//               ],
//             ),
//           ],
//         ),
//         floatingActionButton: _visibleSign
//             ? Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           mainAxisSize: MainAxisSize.max,
//           children: <Widget>[
//             FloatingActionButton(
//               heroTag: "btnCancel",
//               child: const Icon(Icons.cancel),
//               backgroundColor: Colors.blue.shade800,
//               onPressed: () {
//                 setState(() {
//                   _visibleSign = !_visibleSign;
//                   EasyLoading.dismiss();
//                 });
//               },
//             ),
//             FloatingActionButton(
//               heroTag: "btnSign",
//               child: const Icon(Icons.done),
//               backgroundColor: chekKy == true
//                   ? Colors.blue.shade800
//                   : Colors.black38,
//               onPressed: chekKy == true
//                   ? () async {
//                 if (_visibleSign) {
//                   EasyLoading.show();
//                   String pdf = "";
//                   PDF_URL.substring(0, 38);
//                   pdf =
//                       PDF_URL.substring(36, PDF_URL.length);
//                   var thanhcong = await postKySimOK(
//                       widget.idDuThao,
//                       "UpdateFileS"
//                           "ignal",
//                       widget.nam,
//                       namefile,
//                       NameMoi,
//                       UrlMoi);
//                   Navigator.of(context).pop();
//                   EasyLoading.dismiss();
//                   await showAlertDialog(context,
//                       json.decode(thanhcong)['Message']);
//                   //_getSignMessage(context);
//                   _visibleSign = !_visibleSign;
//                 }
//               }
//                   : null,
//             ),
//           ],
//         )
//             : FloatingActionButton.extended(
//           icon: const Icon(Icons.edit),
//           label: Text("Ký"),
//           backgroundColor: Colors.blue.shade800,
//           onPressed: () {
//             setState(() {
//               _visibleSign = !_visibleSign;
//               //_enableSwipe = !_enableSwipe;
//             });
//           },
//         ));
//   }
// }
//
// class ListDataP {
//   String Name;
//   String Url;
//   String UrlDoc;
//
//   ListDataP({this.Name, this.Url, this.UrlDoc});
//
//   factory ListDataP.fromJson(Map<String, dynamic> json) {
//     return ListDataP(
//         Name: json['Name'] != null ? json['Name'] : "",
//         Url: json['Url'] != null ? json['Url'] : "",
//         UrlDoc: json['Url1'] != null ? json['Url1'] : "");
//   }
// }
