import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hb_mobile2021/core/services/VbdenService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewPDF_con extends StatefulWidget {
  final int idDuThao;
  final String nam;
  final double pdfWidth;
  final double pdfHeight;
  final double top;
  final String viewPDF;
  final double left;

  ViewPDF_con(
      {this.idDuThao,
      this.nam,
      this.pdfHeight,
      this.left,
      this.viewPDF,
      this.top,
      this.pdfWidth});

  @override
  _ViewPDF createState() => _ViewPDF();
}

extension GlobalKeyExtension on GlobalKey {
  Rect get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      return renderObject.paintBounds
          .shift(Offset(translation.x, translation.y));
    } else {
      return null;
    }
  }
}

class _ViewPDF extends State<ViewPDF_con> {
  GlobalKey _key = GlobalKey();
  var _x = 0.0;
  var _y = 0.0;
  final GlobalKey stackKey = GlobalKey();

  PDFViewController _pdfViewController;
  double pdfWidth = 612.0;
  double pdfHeight = 792.0;
  Completer<PDFViewController> pdfController = Completer<PDFViewController>();
  bool pdfReload = false;

  double width =75.0, height =65.0;
  bool isLoading = false;
  bool chekKy = false;
  String localPath;
  String namefile = namepdf;
  SharedPreferences sharedStorage;
  double widthCK = 110, heightCK = 60;
  GlobalKey stickyKeyPositioned = GlobalKey();
  double top, left;
  double relX, relY;
  double xOff, yOff;
  bool _visibleSign = false;
  int _currentPage = 1;
  String encodedImage;
  GlobalKey stickyKey = GlobalKey();
  GlobalKey stickyKeyPdf_con = GlobalKey();
  String pdfGui = "";
  String pdfCu = "";
  String NameMoi = "";
  String UrlMoi = "";
  bool _enableSwipe = true;
  double xz, yz;
  final keyText = GlobalKey();
  Size size;
  Offset position;
  bool pdfReady = false;

  Offset offset = Offset.zero;
  String PDF_URL ="";
  File file;
  var PDF;
  var url;
  List<ListDataP>  ListDataPDF = [];

  Timer _timer;


  void _initializeTimer() {
    _timer = Timer.periodic(const Duration(minutes:5), (_) {
      logOut(context);
      _timer.cancel();
    });

  }

  void _handleUserInteraction([_]) {
    // if (!_timer.isActive) {
    //   // This means the user has been logged out
    //   return;
    // }
    //
    // _timer.cancel();
    // _initializeTimer();
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

  void _getRenderOffsets() {
    final RenderBox renderBoxWidget =
        stickyKeyPositioned.currentContext.findRenderObject();
    final offset = renderBoxWidget.localToGlobal(Offset.zero);

    yOff = offset.dy - this.top;
    xOff = offset.dx - this.left;
  }

  void _getOffset(GlobalKey key) {
    RenderBox box = key.currentContext.findRenderObject();
    Offset position = box.localToGlobal(Offset.zero);
    setState(() {
      _x = position.dx;
      _y = position.dy;
    });
  }

  void _afterLayout(_) {
    _getRenderOffsets();
  }

  @override
  Future<void> initState() {
    // TODO: implement initState
    _initializeTimer();
    super.initState();
    PDF_URL=  pdf;
    if(widget.viewPDF != null ){
      PDF_URL = widget.viewPDF;
    }
    GetPDF(PDF_URL);
    pdfWidth = widget.pdfWidth;
    pdfHeight = widget.pdfHeight;

    position = Offset(0, 0);
    top = widget.top;
    left = widget.left;
     WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    //this.fetchData();
    if(mounted){ setState(() {
      var vanban = Listpdf;
      var lstData = (vanban as List).map((e) => ListDataP.fromJson(e)).toList();
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
    return GestureDetector(
      onTap: _handleUserInteraction,
      onPanDown: _handleUserInteraction,
      onScaleStart: _handleUserInteraction,
      child:Scaffold(
        body:Stack(
          key: stackKey, // 3.
          //fit: StackFit.expand,
          children: [
            !pdfReady
                ? Center(
              child: CircularProgressIndicator(),
            )
                : Offstage(),
            localPath != null
                ? PDFView(
              enableSwipe: true,
              autoSpacing: false,
              pageFling: true,
              pageSnap: true,
              fitPolicy: FitPolicy.BOTH,
              preventLinkNavigation: false,
              key: stickyKeyPdf_con,
              filePath: localPath,
              swipeHorizontal: false,
              nightMode: false,
              onError: (e) {

              },
              onViewCreated: (PDFViewController pdfViewController) {
                pdfController.complete(pdfViewController);
              },
              onRender: (_pages) {
                setState(() {
                  pdfReady = true;
                });
              },
              onPageChanged: (int page, int total) {
                setState(() {
                  _currentPage = page;

                });
              },
            )
                : Container(),
            !pdfReady
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
                  child: Container(
                    width: width,
                    height: height,
                    color: Colors.transparent,
                    child: Center(
                        child: (encodedImage != null && encodedImage != "")
                            ? Image.memory(base64.decode(encodedImage), width: width, height: height, )
                            : Image(
                          image: AssetImage('assets/signature.png'),
                          width: width,
                          height: height,
                        )
                    ),
                  ),
                  feedback: Center(
                      child: (encodedImage != null && encodedImage != "")
                          ? Image.memory(base64.decode(encodedImage), width: width, height: height,)
                          : Image(
                        image: AssetImage('assets/signature.png'),
                        width: width,
                        height: height,

                      )
                  ), // 8.
                  childWhenDragging: Container(), // 9.
                  onDragEnd: (drag) async {
                    final parentPos = stickyKeyPdf_con.globalPaintBounds;
                    setState(() {
                    if (parentPos == null) return;
                    left = drag.offset.dx - parentPos.left; // 11.
                    top = drag.offset.dy - parentPos.top;
                  });
                    final keyContext = stickyKeyPdf_con.currentContext;
                    final box = keyContext.findRenderObject() as RenderBox;
                    final pos = box.localToGlobal(Offset.zero);
                    double ratioW = pdfWidth/(box.size.width);
                    double ratio = (box.size.width)/pdfWidth;
                    final boxWidth = box.size.width;

                    final boxHeight = pdfHeight * ratio;

                    // setState(() {
                    //   top = drag.offset.dy - (box.size.height * 0.2);
                    //   left = drag.offset.dx;
                    // });

                    double dy = (box.size.height - top - height - ((box.size
                        .height - boxHeight)/2));
                    double ratioH = pdfHeight/(boxHeight);

                    double dx = (left * ratioW);
                    double dy1 = (dy * ratioH);

                    // print("chièu dài PhepTinh: " +
                    //     (siz.height - dragDetails.offset.dy).toString());

                    // print('_currentPage: ====$_currentPage');
                    // print('dx: ====$dx');
                    // print('dy: ====$dy');
                    // print('width: ====${(width * ratioW).toInt()}');
                    // print('height: ====${(height * ratioW).toInt()}');
                    //
                    PDF_URL.substring(0, 38);
                    pdfCu = PDF_URL.substring(36, PDF_URL.length);
                    EasyLoading.show();
                    String vbtimkiem = await postKySim(
                        widget.idDuThao,
                        "KySim",
                        widget.nam,
                        ((left * ratioW)+(width*1/2)).toString(),
                        (dy1+ height )
                            .toString(),
                        (width * ratioW).toString(),
                        (height * ratioW).toString(),
                        pdfCu,
                        _currentPage,
                        namefile);

                    if (mounted) {
                      setState(() {
                        var duthaoList = json.decode(vbtimkiem)['OData'];
                        NameMoi = duthaoList['Name'];
                        UrlMoi = duthaoList['Url'];
                        chekKy = true;
                        EasyLoading.dismiss();
                      });
                    }
                  },
                ),
              ),
            ),
            Container(alignment: Alignment.topRight,
              width: MediaQuery.of(context).size.width ,
              height: MediaQuery.of(context).size.height /15,
              // padding: EdgeInsets.all(10),
              margin:  EdgeInsets.only(left: 10,right: 0,top:0),
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
                      value: PDF,
                      isDense: false,
                      isExpanded: true,
                      onChanged: (newValue) {
                        if(mounted){
                          setState(() {
                            PDF=newValue;

                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (BuildContext context) => ViewPDF_con(viewPDF:newValue)),
                                    (Route<dynamic> route) => true);


                            // Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (context) => ViewPDFVB(viewPDF:newValue)
                            //         ),
                            //       );

                            // GetDataKeyWord("","","",IDCoQuan);
                          });
                        }
                      },
                      items: ListDataPDF.map((value) {
                        return DropdownMenuItem<String>(
                          value: value.Url,
                            child:RichText(
                              text: TextSpan(
                                children: [

                                  WidgetSpan(
                                    child: Image(
                                      height: 30,
                                      width:20,
                                      image: value.Name != null ?value.Name.contains("pdf")
                                          ?AssetImage('assets/pdf.png'):(value.Name
                                          .contains("doc")?AssetImage('assets/doc'
                                          '.png'):(value.Name
                                          .contains("docx")?AssetImage('assets/docx'
                                          '.png'): AssetImage('assets/logo_vb.png'))): AssetImage('assets/logo_vb.png'),

                                    ),
                                  ),
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
            ),
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
                    backgroundColor: Colors.blue.shade800,
                    onPressed: chekKy == true
                        ? () async {
                            if (_visibleSign) {
                              EasyLoading.show();
                              String pdf = "";
                              PDF_URL.substring(0, 38);
                              pdf = PDF_URL.substring(36, PDF_URL.length);
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
            : FloatingActionButton.extended(
                icon: const Icon(Icons.edit),
                label: Text("Ký"),
                backgroundColor: Colors.blue.shade800,
                onPressed: () {
                  setState(() {

                    _visibleSign = !_visibleSign;
                    //_enableSwipe = !_enableSwipe;
                  });
                },
              )),);
  }
}
class ListDataP {
  String Name;
  String Url;


  ListDataP({ this.Name,this.Url});

  factory ListDataP.fromJson(Map<String, dynamic> json) {
    return ListDataP( Name: json['Name'],Url: json['Url']);
  }
}