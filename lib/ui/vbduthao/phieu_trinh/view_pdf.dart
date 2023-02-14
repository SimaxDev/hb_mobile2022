import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hb_mobile2021/core/services/VbdenService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewPDFPT extends StatefulWidget {
  final int idDuThao;
  final String nam;
  final String viewPDF;


  ViewPDFPT(
      {required this.idDuThao,
        required this.nam,


        required this.viewPDF,

     });

  @override
  _ViewPDF createState() => _ViewPDF();
}

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBound {
    final renderObject = currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      return renderObject!.paintBounds
          .shift(Offset(translation.x, translation.y));
    } else {
      return null;
    }
  }
}

class _ViewPDF extends State<ViewPDFPT> {
  GlobalKey _key = GlobalKey();
  var _x = 0.0;
  var _y = 0.0;
  final GlobalKey stackKey = GlobalKey();

  double pdfWidth = 612.0;
  double pdfHeight = 792.0;
  Completer<PDFViewController> pdfController = Completer<PDFViewController>();
  bool pdfReload = false;

  double width =75.0, height =65.0;
  bool isLoading = false;
  bool chekKy = false;
   String? localPath;
  String namefile = namepdf;
  String namefilePDF = "";
  late SharedPreferences sharedStorage;
  double widthCK = 110, heightCK = 60;
  GlobalKey stickyKeyPositioned = GlobalKey();
   double? top, left;
   double? relX, relY;
   double? xOff, yOff;
  bool _visibleSign = false;
  int _currentPage = 1;
  late String encodedImage;
  GlobalKey stickyKey = GlobalKey();
  GlobalKey stickyKeyPdf = GlobalKey();
  String pdfGui = "";
  String pdfCu = "";
  String NameMoi = "";
  String UrlMoi = "";
  bool _enableSwipe = true;
   double? xz, yz;
  final keyText = GlobalKey();
   Size? size;
   Offset? position;
  bool pdfReady = false;

  Offset offset = Offset.zero;
  String PDF_URL ="";
  String tenPDFTruyen ="";
  late File file;
  var url;
  List<ListDataPPT>  ListDataPDF = [];

  String downloadMessage = "Initalizing...";
  bool _isDownloading = false;
  bool percentageBool = false;
  String pathPDF = "";
  bool checkKySo = false;
  double percentage = 0;
  String tenPDF = "";
  String urlPDF = "";

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
  GetPDF(String PDFD) async {

    loadPDF(PDFD).then((value) {
      if (mounted) {    setState(()
      {

        localPath =  value ;


      });}
    });



  }
  Future<String> loadPDF( String urlPDF) async {
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
    file = File("${dir.path}/$filename");
    // setState(() {
    //   isLoading = true;
    //   file =  new File(dir.path+"/vanbanmoi.pdf");// tao 1 tep moi
    // });
    await file.writeAsBytes(response.bodyBytes,flush: true);
    return file.path;




  }
  //
  // void _getRenderOffsets() {
  //   final RenderObject? renderBoxWidget =
  //   stickyKeyPositioned.currentContext?.findRenderObject();
  //   final offset = renderBoxWidget?.localToGlobal(Offset.zero);
  //
  //   yOff = offset.dy - this.top;
  //   xOff = offset.dx - this.left;
  // }

  // void _getOffset(GlobalKey key) {
  //   RenderBox box = key.currentContext.findRenderObject();
  //   Offset position = box.localToGlobal(Offset.zero);
  //   setState(() {
  //     _x = position.dx;
  //     _y = position.dy;
  //   });
  // }

  // void _afterLayout(_) {
  //   _getRenderOffsets();
  // }

  @override
  void initState() {
    super.initState();
    PDF_URL=  pdfPT;
    if(widget.viewPDF != null &&widget.viewPDF != ""){
      PDF_URL = widget.viewPDF;
    }
    GetPDF(PDF_URL);


    position = Offset(0, 0);

    if(mounted){ setState(() {
      var vanban = ListpdfPT;
      var lstData = (vanban as List).map((e) => ListDataPPT.fromJson(e)).toList();
      lstData.forEach((element) {
        ListDataPDF.add(element);
      });
    });}
  }

  @override
  void didChangeMetrics() {
    if (Platform.isAndroid) {
      // for rotations on Android
      pdfController = Completer<PDFViewController>();
      //pdfReload = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size siz = MediaQuery.of(context).size;
    return Scaffold(
        body:Stack(
          // key: stackKey, // 3.
          //fit: StackFit.expand,
          children: [
            // !pdfReady
            //     ? Center(
            //   child: CircularProgressIndicator(),
            // )
            //     : Offstage(),
            localPath != null
                ? Container(
              key: stickyKeyPdf,
              margin: EdgeInsets.only(left: 0, right: 0, top: 30),
              child: PDFView(
                enableSwipe: true,
                autoSpacing: false,
                pageFling: true,
                pageSnap: true,
                fitPolicy: FitPolicy.BOTH,
                preventLinkNavigation: false,
                key: ValueKey(localPath),
                filePath: localPath,
                swipeHorizontal: false,
                nightMode: false,
                onError: (e) {},
                // onViewCreated:
                //     (PDFViewController pdfViewController) {
                //   pdfController.complete(pdfViewController);
                // },
                onRender: (_pages) {
                  setState(() {
                    pdfReady = true;
                  });
                },
                onPageChanged: ( page,  total) {
                  setState(() {
                    _currentPage = page!;
                  });
                },
              ),
            )
                : Container(),

            PDF_URL == null
                ? Center(
              child: CircularProgressIndicator(),
            )
                : Offstage(),
            Positioned(
              key: stickyKeyPositioned,
              left: left,
              top: top,
              child: Visibility(
                visible: _visibleSign,
                child: Draggable(
                  child: Opacity(
                    child: Container(
                      margin: EdgeInsets.only(top: 40),
                      width: widthKy,
                      height: heightKy,
                      color: Colors.transparent,
                      child: Center(
                        child: Image.network(
                          imageCK,
                          width: widthKy,
                          height: heightKy,
                          errorBuilder: (context, error, stackTrace) {
                            return Image(
                              image: AssetImage('assets/signature.png'),
                              width: widthKy,
                              height: heightKy,
                            );
                          },
                        ),

                      ),
                    ),
                    opacity: 0.6,
                  ),
                  feedback: Opacity(
                    child: Container(
                      margin: EdgeInsets.only(top: 40),
                      width: widthKy,
                      height: heightKy,
                      color: Colors.transparent,
                      child: Center(
                        child: Image.network(
                          imageCK,
                          width: widthKy,
                          height: heightKy,
                          errorBuilder: (context, error, stackTrace) {
                            return Image(
                              image: AssetImage('assets/signature.png'),
                              width: widthKy,
                              height: heightKy,
                            );
                          },
                        ),

                        // child: (encodedImage != null && encodedImage != "")
                        //     ? Image.memory(base64.decode(encodedImage), width: widthKy, height: heightKy, )
                        //     : Image(
                        //   image: AssetImage('assets/signature.png'),
                        //   width: widthKy,
                        //   height: heightKy,
                        // )
                      ),
                    ),
                    opacity: 0.6,
                  ),  // 8.
                  childWhenDragging: Container(), // 9.
                  onDragEnd: (drag) async {
                    final parentPos = stickyKeyPdf.globalPaintBound;
                    setState(() {
                      if (parentPos == null) return;
                      left = drag.offset.dx - parentPos.left; // 11.
                      top = (drag.offset.dy - parentPos.top) ;
                    });
                    final keyContext = stickyKeyPdf.currentContext;
                    final box = keyContext!.findRenderObject() as RenderBox;
                    final pos = box.localToGlobal(Offset.zero);
                    double ratioW = pdfWidth/(box.size.width);
                    double ratio = (box.size.width)/pdfWidth;
                    final boxWidth = box.size.width;

                    final boxHeight = pdfHeight * ratio;

                    // setState(() {
                    // top = drag.offset.dy - (box.size.height * 0.2);
                    //   left = drag.offset.dx;
                    // });

                    double dy = (box.size.height - top! - heightKy - ((box.size
                        .height - boxHeight)/2));
                    double ratioH = pdfHeight/(boxHeight);

                    // double dx = (left * ratioW);
                    double dy1 = (dy * ratioH);

                    // print("chièu dài PhepTinh: " +
                    //     (siz.height - dragDetails.offset.dy).toString());

                    // print('_currentPage: ====$_currentPage');
                    // print('dx: ====$dx');
                    // print('dy: ====$dy');
                    // print('width: ====${(width * ratioW).toInt()}');
                    // print('height: ====${(height * ratioW).toInt()}');
                    //
                    // PDF_URL.substring(0, 38);
                    // // pdfCu = PDF_URL.substring(36, PDF_URL.length);
                    // if(PDF_URL!.contains("https://apimobile.hoabinh.gov"
                    //     ".vn/")){
                    //   pdfCu = PDF_URL!.replaceAll(
                    //       "https://apimobile.hoabinh.gov"
                    //           ".vn/",
                    //       "");
                    // }
                    // else
                    // {
                    //   pdfCu = PDF_URL!.replaceAll(
                    //       "http://apimobile.hoabinh.gov"
                    //           ".vn/",
                    //       "");
                    // }
                    EasyLoading.show();
                    /// String vbtimkiem ;
                    String vbtimkiem = await postKySim(
                        widget.idDuThao,
                        "KySim",
                        widget.nam,
                        ((left! * ratioW)+(widthKy*1/2)).toString(),
                        ((dy1 + heightKy)-40 ).toString(),
                        (widthKy * ratioW).toString(),
                        (heightKy * ratioW).toString(),
                        PDF_URL,
                        _currentPage,
                        namefile);

                    if(json.decode(vbtimkiem)['Erros'] == true){

                      EasyLoading.dismiss();

                      await showAlertDialog(
                          context,json.decode(vbtimkiem)['Message']);
                    }else{
                      if (mounted) {
                        setState(() {
                          var duthaoList = json.decode(vbtimkiem)['OData'];
                          if(duthaoList != null){
                            NameMoi = duthaoList['Name'];
                            UrlMoi = duthaoList['Url'];
                            EasyLoading.dismiss();
                            chekKy = true;
                          }
                          else{
                            Get.defaultDialog(

                                title:"Thông báo",
                                middleText:"Ký số không thành công!"
                            );
                            EasyLoading.dismiss();
                            chekKy = false;
                          }

                        });
                      }
                    }

                  },
                ),
              ),
            ),


            //     ? PDFView(
            //   enableSwipe: true,
            //   autoSpacing: false,
            //   pageFling: true,
            //   pageSnap: true,
            //   fitPolicy: FitPolicy.BOTH,
            //   preventLinkNavigation: false,
            //   key: stickyKeyPdf,
            //   filePath: localPath,
            //   swipeHorizontal: false,
            //   nightMode: false,
            //   onError: (e) {
            //
            //   },
            //   onViewCreated: (PDFViewController pdfViewController) {
            //     pdfController.complete(pdfViewController);
            //   },
            //   onRender: (_pages) {
            //     setState(() {
            //       pdfReady = true;
            //     });
            //   },
            //   onPageChanged: (int page, int total) {
            //     setState(() {
            //       _currentPage = page;
            //
            //     });
            //   },
            // )

            //            Positioned(
            //              key: stickyKeyPositioned,
            //              left: left,
            //              top: top,
            //              child: Visibility(
            //                visible: _visibleSign,
            //                child: Draggable(
            //                  child: Container(
            //                    width: width,
            //                    height: height,
            //                    color: Colors.transparent,
            //                    child: Center(
            //                        child: Container(
            //                          color: Colors.white.withOpacity(0.0),
            //                          child:(encodedImage != null && encodedImage != "")
            //                              ? Image.memory(base64.decode(encodedImage), width: width, height: height, )
            //                              : Image(
            //                            image: AssetImage('assets/signature.png'),
            //                            width: width,
            //                            height: height,
            //                          ) ,
            //                        )
            //
            //
            //                    ),
            //                  ),
            //                  feedback: Center(
            //                    child:Container(
            //                      color: Colors.white.withOpacity(0.0),
            //                      child:(encodedImage != null && encodedImage != "")
            //                          ? Image.memory(base64.decode(encodedImage), width: width, height: height, )
            //                          : Image(
            //                        image: AssetImage('assets/signature.png'),
            //                        width: width,
            //                        height: height,
            //                      ) ,
            //                    )
            //                      // child: ColorFiltered(
            //                      //     colorFilter: ColorFilter.mode(Colors.white.withOpacity
            //                      //       (0.2), BlendMode.dstATop),
            //                      //     child: (encodedImage != null && encodedImage != "")
            //                      //         ? Image.memory(base64.decode(encodedImage), width: width, height: height, )
            //                      //         : Image(
            //                      //       image: AssetImage('assets/signature.png'),
            //                      //       width: width,
            //                      //       height: height,
            //                      //     )
            //                      // )
            //                  ), // 8.
            //                  childWhenDragging: Container(), // 9.
            //                  onDragEnd: (drag) async {
            //                    final parentPos = stickyKeyPdf.globalPaintBound;
            //                    setState(() {
            //                      if (parentPos == null) return;
            //                      left = drag.offset.dx - parentPos.left; // 11.
            //                      top = drag.offset.dy - parentPos.top;
            //                    });
            //                    // final keyContext = stickyKeyPdf.currentContext;
            //                    // final box = keyContext.findRenderObject() as RenderBox;
            //                    // final pos = box.localToGlobal(Offset.zero);
            //                    // double ratioW = pdfWidth/(box.size.width);
            //                    // double ratio = (box.size.width)/pdfWidth;
            //                    // final boxWidth = box.size.width;
            //                    //
            //                    // final boxHeight = pdfHeight * ratio;
            //                    //
            //                    // double dy = (box.size.height - top - height - ((box.size
            //                    //     .height - boxHeight)/2));
            //                    // double ratioH = pdfHeight/(boxHeight);
            //                    //
            //                    // double dx = (left * ratioW);
            //                    // double dy1 = (dy * ratioH);
            //                    //
            //                    //
            //                    // PDF_URL.substring(0, 38);
            //                    // pdfCu = PDF_URL.substring(36, PDF_URL.length);
            //
            //                    // String vbtimkiem = await postKySim(
            //                    //     widget.idDuThao,
            //                    //     "KySim",
            //                    //     widget.nam,
            //                    //     ((left * ratioW)+(width*1/2)).toString(),
            //                    //     (dy1+ height )
            //                    //         .toString(),
            //                    //     (width * ratioW).toString(),
            //                    //     (height * ratioW).toString(),
            //                    //     pdfCu,
            //                    //     _currentPage,
            //                    //     namefile);
            //                    EasyLoading.show();
            //                    String vbtimkiem = await postKySimkky(
            //                        widget.idDuThao,
            //                        "GetFileKyAPI",
            //                        widget.nam,tenPDFTruyen
            //                        );
            //
            //
            //  // if (mounted) {
            //  //   setState(() {
            //      // var duthaoList = json.decode(vbtimkiem)['OData'];
            //      // NameMoi = duthaoList['Name'];
            //      // UrlMoi = duthaoList['Url'];
            //
            //      checkKySo = json.decode(vbtimkiem)['Erros']!= null ? json
            //          .decode(vbtimkiem)['Erros']:false;
            //      namefilePDF =json.decode(vbtimkiem)['OData']!= null && json.decode
            //        (vbtimkiem)['OData'][0]['url']!= null? json
            //          .decode(vbtimkiem)['OData'][0]['url']:"";
            //      if(checkKySo == false){
            //        setState(() {
            //          chekKy = true;
            //        });
            //
            //    }
            //
            //    // });
            // // }
            //                    EasyLoading.dismiss();
            //
            //                  },
            //                ),
            //              ),
            //            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(flex:9,
                  child: Container(
                    // width: MediaQuery.of(context).size.width *0.85,
                    height: MediaQuery.of(context).size.height /15,
                    padding: EdgeInsets.only(left: 10),
                    // decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.all(Radius
                    //         .circular(8))
                    // ),

                    child:FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: Text("Chọn bản ghi khác"),
                            style: TextStyle(fontSize: 14,color: Colors.black),
                            value: PDF_URL!.isNotEmpty ? PDF_URL : null,
                            isDense: false,
                            isExpanded: true,
                            onChanged: (newValue) async {
                              //  OpenFile.open(files.path);
                              if(mounted){
                                setState(() {

                                  PDF_URL=newValue!;

                                });
                              }
                            },
                            items:
                            ListDataPDF.map((value) {
                              String a = value.Url;

                              return DropdownMenuItem<String>(
                                  value: value.Url,
                                  child:RichText(
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
                                        TextSpan(text:value.Name, style: TextStyle(
                                            color: Colors.black.withOpacity(0.75),
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13),

                                        ),
                                      ],
                                    ),
                                  )

                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),),
                Flexible(
                    flex: 1,
                    child:  Container(
                      height: MediaQuery.of(context).size.height /15,
                      alignment: Alignment.centerRight,
                      child: IconButton(iconSize: 17,
                        icon:Icon(Icons.download_sharp) ,
                        onPressed: () async {
                          final status = await Permission.storage.request();

                          if (status.isGranted) {
                            setState(() {
                              _isDownloading = !_isDownloading;
                            });
                            final dir = Platform.isAndroid
                                ? await getExternalStorageDirectory()
                                : await getApplicationSupportDirectory();
                            Dio dio = Dio();

                            for (var item in ListDataPDF) {
                              if (item.Url == PDF_URL) {
                                urlPDF = item.UrlDoc;
                                tenPDF = item.Name;
                                print(urlPDF);
                              }
                            }
                            if (PDF_URL!.contains("doc")) {
                              url = urlPDF;
                              await FlutterDownloader.enqueue(
                                url: url,
                                savedDir: '/storage/emulated/0/Download',
                                fileName: tenPDF,
                                showNotification: true,
                                openFileFromNotification: true,
                              );
                              // createFileOfPdfUrl(url,tenPDF);
                            } else if (PDF_URL!.contains("xlsx")) {
                              String ten = PDF_URL!.split('/').last;
                              url = PDF_URL;

                              url = PDF_URL;
                              await FlutterDownloader.enqueue(
                                url: url,
                                savedDir: '/storage/emulated/0/Download',
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
                                savedDir: '/storage/emulated/0/Download',
                                showNotification: true,
                                openFileFromNotification: true,
                              );
                            }
                          } else {}
                        },




                        // onPressed: () async {
                        //
                        //   setState(() {
                        //     _isDownloading = !_isDownloading;
                        //
                        //   });
                        //   var dir = await getExternalStorageDirectory();
                        //
                        //   Dio dio = Dio();
                        //
                        //   for( var item in ListDataPDF){
                        //     if( item.Url == PDF_URL)
                        //     {
                        //       urlPDF = item.UrlDoc;
                        //       tenPDF = item.Name;
                        //       print(urlPDF);
                        //     }
                        //   }
                        //   if (PDF_URL.contains("doc")) {
                        //     url = urlPDF;
                        //     createFileOfPdfUrl(url,tenPDF);
                        //   }
                        //   else
                        //   if(PDF_URL.contains("xlsx"))
                        //   {
                        //     String ten =  PDF_URL.split('/').last;
                        //     url = PDF_URL;
                        //
                        //
                        //     dio.download(url, '${dir!.path}/$ten',
                        //         onReceiveProgress: (actualbytes, totalbytes) {
                        //           percentage = actualbytes / totalbytes * 100;
                        //
                        //           setState(() {
                        //             percentageBool = true;
                        //             downloadMessage =
                        //             'Downloading... ${percentage.floor()}'
                        //                 ' %';
                        //             if (percentage < 100) {
                        //             } else {
                        //               setState(() {
                        //                 percentageBool = false;
                        //               });
                        //             }
                        //           });
                        //         });
                        //     print(dir.path ?? '');
                        //     print('dio  ' + dio.toString());
                        //   }
                        //   else
                        //   {
                        //     url = PDF_URL;
                        //
                        //     String ten =  PDF_URL.split('/').last;
                        //     dio.download(url, '${dir!.path}/$ten',
                        //         onReceiveProgress: (actualbytes, totalbytes) {
                        //           percentage = actualbytes / totalbytes * 100;
                        //
                        //           setState(() {
                        //             percentageBool = true;
                        //             downloadMessage =
                        //             'Downloading... ${percentage.floor()}'
                        //                 ' %';
                        //             if (percentage < 100) {
                        //             } else {
                        //               setState(() {
                        //                 percentageBool = false;
                        //               });
                        //             }
                        //           });
                        //         });
                        //     print(dir.path ?? '');
                        //     print('dio  ' + dio.toString());
                        //   }
                        //
                        // },
                      ),
                    ))



              ],),
            // Row(children: [
            //   Container(alignment: Alignment.topRight,
            //     width: MediaQuery.of(context).size.width *0.85,
            //     height: MediaQuery.of(context).size.height /15,
            //     // padding: EdgeInsets.all(10),
            //     margin:  EdgeInsets.only(left: 10,right: 0,top:0),
            //     // decoration: BoxDecoration(
            //     //     color: Colors.white,
            //     //     borderRadius: BorderRadius.all(Radius
            //     //         .circular(8))
            //     // ),
            //
            //     child:FormField<String>(
            //       builder: (FormFieldState<String> state) {
            //         return DropdownButtonHideUnderline(
            //           child: DropdownButton<String>(
            //             hint: Text("Chọn bản ghi khác"),
            //             style: TextStyle(fontSize: 14,color: Colors.black),
            //             value: PDF_URL,
            //             isDense: false,
            //             isExpanded: true,
            //             onChanged: (newValue) {
            //               if(mounted){
            //                 setState(() {
            //                   PDF_URL=newValue;
            //
            //                   // Navigator.of(context).pushAndRemoveUntil(
            //                   //     MaterialPageRoute(
            //                   //         builder: (BuildContext context) => ViewPDF_con(viewPDF:newValue)),
            //                   //         (Route<dynamic> route) => true);
            //
            //
            //                   // Navigator.push(
            //                   //         context,
            //                   //         MaterialPageRoute(
            //                   //             builder: (context) => ViewPDFVB(viewPDF:newValue)
            //                   //         ),
            //                   //       );
            //
            //                   // GetDataKeyWord("","","",IDCoQuan);
            //                 });
            //               }
            //             },
            //             items: ListDataPDF.map((value) {
            //               tenPDFTruyen =  value.Name;
            //               return DropdownMenuItem<String>(
            //                   value: value.Url,
            //                   child:RichText(
            //                     text: TextSpan(
            //                       children: [
            //
            //                         WidgetSpan(
            //                           child: Image(
            //                             height: 30,
            //                             width:20,
            //                             image: value.Name != null ?value.Name.contains("pdf")
            //                                 ?AssetImage('assets/pdf.png'):(value.Name
            //                                 .contains("doc")?AssetImage('assets/doc'
            //                                 '.png'):(value.Name
            //                                 .contains("docx")?AssetImage('assets/docx'
            //                                 '.png'): AssetImage('assets/logo_vb.png'))): AssetImage('assets/logo_vb.png'),
            //
            //                           ),
            //                         ),
            //                         TextSpan(text:value.Name, style: TextStyle(
            //                             color: Colors.black.withOpacity(0.75),
            //                             fontStyle: FontStyle.normal,
            //                             fontWeight: FontWeight.w400,
            //                             fontSize: 13),
            //
            //                         ),
            //                       ],
            //                     ),
            //                   )
            //               );
            //             }).toList(),
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            //   Container(
            //     width: MediaQuery.of(context).size.width *0.05,
            //     height: MediaQuery.of(context).size.height /15,
            //     margin: EdgeInsets.only(left: 20),
            //     child: IconButton(
            //       icon:Icon(Icons.download_sharp) ,
            //       onPressed: () async {
            //
            //
            //         setState(() {
            //           _isDownloading = !_isDownloading;
            //
            //         });
            //         var dir = await getExternalStorageDirectory();
            //
            //         Dio dio = Dio();
            //         dio.download(PDF_URL,
            //             '${dir.path}/$namepdf',onReceiveProgress: (actualbytes,
            //                 totalbytes){
            //               percentage =  actualbytes/totalbytes*100;
            //
            //               setState(() {
            //                 percentageBool = true;
            //                 downloadMessage =  'Downloading... ${percentage.floor()}'
            //                     ' %';
            //                 if(percentage <100){
            //
            //                 }
            //                 else{
            //                   setState(() {
            //                     percentageBool = false;
            //                   });
            //                 }
            //               });
            //             });
            //         print(downloadMessage??'');
            //       },
            //     ),
            //
            //   )
            // ],),
            percentageBool == true ?  Center(
                child: CircularPercentIndicator(
                    radius: 60.0,
                    lineWidth: 5.0,
                    percent: 0.75,
                    center: new Text(downloadMessage, style: TextStyle(color: Color(0xFF535355))),
                    linearGradient: LinearGradient(begin: Alignment.topRight,end:Alignment.bottomLeft, colors: <Color>    [Color(0xFF1AB600),Color(0xFF6DD400)]),rotateLinearGradient: true,
                    circularStrokeCap: CircularStrokeCap.round)):SizedBox(),
          ],
        ),
        floatingActionButton: _visibleSign
            ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "btnCancel",
              child: const Icon(Icons.cancel),
              backgroundColor: Colors.blue.shade800,
              onPressed: () {
                setState(() {
                  _visibleSign = !_visibleSign;
                  EasyLoading.dismiss();
                });
              },
            ),
            FloatingActionButton(
              heroTag: "btnSign",
              child: const Icon(Icons.done),
              backgroundColor: chekKy == true
                  ? Colors.blue.shade800
                  : Colors.black38,
              onPressed: chekKy == true
                  ? () async {
                if (_visibleSign) {
                  EasyLoading.show();
                  // String pdf = "";
                  // PDF_URL.substring(0, 38);
                  // pdf = PDF_URL.substring(36, PDF_URL.length);
                  var thanhcong = await postKySimOK(
                      widget.idDuThao,
                      "UpdateFileS"
                          "ignal",
                      widget.nam,
                      namefile,
                      NameMoi,
                      UrlMoi);
                  Navigator.of(context).pop();
                  EasyLoading.dismiss();
                  await showAlertDialog(
                      context, json.decode(thanhcong)['Message']);
                  //_getSignMessage(context);
                  _visibleSign = !_visibleSign;
                }
              }
                  : null,
            ),
          ],
        )
            : (((vbdiTrangThaiVB == 7 || vbdiTrangThaiVB == 6
            || vbdiTrangThaiVB == 2) && (vbdiNguoiSoanID == currentUserID
            || vbdiDSNguoiTrinhTiepKy == true))
            || (vbdiNguoiKyID== currentUserID &&
                vbdiTrangThaiVB == 4)
                && chukyso ==1   )?
        FloatingActionButton.extended(
          icon: const Icon(Icons.edit),
          label: Text("Ký"),
          backgroundColor: Colors.blue.shade800,
          onPressed: () async {

            EasyLoading.show();
            String vbtimkiem = await postKySimkky(
                widget.idDuThao,
                "GetFileKyAPI",
                widget.nam,tenPDFTruyen
            );


            // if (mounted) {
            //   setState(() {
            // var duthaoList = json.decode(vbtimkiem)['OData'];
            // NameMoi = duthaoList['Name'];
            // UrlMoi = duthaoList['Url'];

            checkKySo = json.decode(vbtimkiem)['Erros']!= null ? json
                .decode(vbtimkiem)['Erros']:false;
            namefilePDF =json.decode(vbtimkiem)['OData']!= null && json.decode
              (vbtimkiem)['OData'][0]['url']!= null? json
                .decode(vbtimkiem)['OData'][0]['url']:"";
            if(checkKySo == false){
              setState(() {
                chekKy = true;
              });

            }

            // });
            // }
            EasyLoading.dismiss();
            setState(() {

              _visibleSign = !_visibleSign;
              //_enableSwipe = !_enableSwipe;
            });
          },
        ):SizedBox()) ;


  }
}
class ListDataPPT {
  String Name;
  String Url;
  String UrlDoc;

  ListDataPPT({ required this.Name,required this.Url,required this.UrlDoc});

  factory ListDataPPT.fromJson(Map<String, dynamic> json) {
    return ListDataPPT(
        Name: json['Name'] != null ? json['Name'] : "",
        Url: json['Url'] != null ? json['Url'] : "",
        UrlDoc: json['Url1'] != null ? json['Url1'] : "");
  }
}