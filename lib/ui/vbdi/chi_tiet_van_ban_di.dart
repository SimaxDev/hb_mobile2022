import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:hb_mobile2021/core/models/VanBanDiJson.dart';
import 'package:hb_mobile2021/core/services/VBDiService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'package:hb_mobile2021/ui/main/viewPDF.dart';
import 'package:hb_mobile2021/ui/vbduthao/phieu_trinh/view_pdf.dart';
import 'ThongTinVBDi.dart';
import 'nhatky_vbdi.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'view_pdf.dart';
import 'package:hb_mobile2021/ui/vbdi/BottomNavigator.dart';

class ChiTietVanBanDi extends StatefulWidget {
  int id;
  final String username;
  final String MaDonVi;
  final String nam;
  ChiTietVanBanDi({this.id,this.username,this.nam,this.MaDonVi});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TabChiTietVBDi();
  }
}

class TabChiTietVBDi extends State<ChiTietVanBanDi> {
  bool isLoading = false;
  bool isLoadingPDF = true;
  var urlFile = null;
  var duthao = null;
  int year = 0;
  String ActionXL = "GetVBDiByID";
  ValueNotifier<String> assetPDFPath = ValueNotifier<String>('');
  ValueNotifier<String> remotePDFpath = ValueNotifier<String>('');


  Future<File> createFileOfPdfUrl(String filePath) async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
      // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
      // final url = "https://pdfkit.org/docs/guide.pdf";
      // final url = "http://www.pdf995.com/samples/pdf.pdf";
      final url = 'http://qlvbapi.moj.gov.vn/Uploads/cvlan42019.pdf';
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();

      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  Future<File> getFileFromAsset(String asset) async {
    try {
      var data = await rootBundle.load(asset); // can du lieu
      var bytes =
          data.buffer.asUint8List(); // chuyen doi  thanh dang vb theo kieu byte
      var dir =
          await getApplicationDocumentsDirectory(); //truy cap vao muc chinh
      File file = File("${dir.path}/VanBanGoc.pdf"); // tao 1 tep moi

      File assetFile = await file.writeAsBytes(bytes);
      return assetFile;
    } catch (e) {
      throw Exception("Error opening asset file");
    }
  }

  Future<File> getFileFromURL(String url) async {
    try {
      var urla = Uri.parse(url);
      var data = await http.get(urla);
      var bytes = data.bodyBytes;
      var dir =
          await getApplicationDocumentsDirectory(); //truy cap vao muc chinh
      File file = File("${dir.path}/VanBanGoc.pdf"); // tao 1 tep moi

      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url flie");
    }
  }



  // void _initializeTimer() {
  //   _timer = Timer.periodic(const Duration(minutes:5), (_) {
  //     logOut(context);
  //     _timer.cancel();
  //   });
  //
  // }
  //
  // void _handleUserInteraction([_]) {
  //   if (!_timer.isActive) {
  //     // This means the user has been logged out
  //     return;
  //   }
  //
  //   _timer.cancel();
  //   _initializeTimer();
  // }

  @override
  void initState() {
    // TODO: implement initState
    //_initializeTimer();
    super.initState();
    GetDataDetailVBDi(widget.id);
    if (widget.MaDonVi.startsWith("sites"))
    {

      String a = "2022";
      if(widget.nam != null){
      a =  widget.nam;}
      year = int.parse(a);
      // List<string> lstTT = MaDonVi.Split('/').ToList();
      // if (lstTT.Count > 0 && lstTT.Count == 3)
      //   SYear = lstTT[1].ToInt32();
    }
   /* getFileFromURL(pdf).then((f)
    {
      if (mounted) { setState(() {
        assetPDFPath = ValueNotifier(f.path);

      });}

    });*/
  }

  GetDataDetailVBDi(int id) async {
    String detailVBDi=  await getDataDetailVBDi(id, ActionXL,
        widget.MaDonVi);
    if(mounted){
      setState(() {
        var data =  json.decode(detailVBDi)['OData'];

        duthao = VanBanDiJson.fromJson(data);
        isLoading = true;

      });
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Thông tin',
              ),
              Tab(
                text: 'Toàn văn',
              ),
              Tab(
                text: 'Gửi nhận',
              ),
            ],
          ),
          title: Text('Chi tiết văn bản đi'),
        ),
        body: isLoading == true
            ? TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            ThongTinVBDi(id: widget.id,nam: year,MaDonVi:widget
                .MaDonVi,ttVbanDi:duthao),
            //!isLoadingPDF?
            //      (remotePDFpath.value != '' &&
            //     remotePDFpath.value
            //         .toLowerCase()
            //         .contains(".pdf")) ?
            // Container(
            //   child: PdfViewPage(
            //     path: assetPDFPath,
            //   ),
            // )
            //     : Container(
            //   child: Center(
            //     child: Text('Không có file PDF đính kèm'),
            //   ),
            // )
            //     : Center(
            //   child: CircularProgressIndicator(),
            // )

            // ViewPDF(idDuThao:widget.id,nam:year.toString()),
            ViewPDFVB(),
            NhatKyVBDi(id: widget.id,username:widget.username,
                nam:year),
          ],
        )
            : Center(
          child: CircularProgressIndicator(),
        ),
        bottomNavigationBar: BottomNav(id : widget.id,nam:year,
            MaDonVi:widget.MaDonVi),
      ),
    );
    // return GestureDetector(
    //   onTap: _handleUserInteraction,
    //   onPanDown: _handleUserInteraction,
    //   onScaleStart: _handleUserInteraction,
    //   child:DefaultTabController(
    //   length: 3,
    //   child: Scaffold(
    //     appBar: AppBar(
    //       leading: IconButton(
    //         icon: Icon(Icons.arrow_back),
    //         onPressed: () => Navigator.pop(context, false),
    //       ),
    //       bottom: TabBar(
    //         tabs: [
    //           Tab(
    //             text: 'Thông tin',
    //           ),
    //           Tab(
    //             text: 'Toàn văn',
    //           ),
    //           Tab(
    //             text: 'Gửi nhận',
    //           ),
    //         ],
    //       ),
    //       title: Text('Chi tiết văn bản đi'),
    //     ),
    //     body: isLoading == true
    //         ? TabBarView(
    //             physics: NeverScrollableScrollPhysics(),
    //             children: [
    //               ThongTinVBDi(id: widget.id,nam: year,MaDonVi:widget
    //                   .MaDonVi,ttVbanDi:duthao),
    //               //!isLoadingPDF?
    //               //      (remotePDFpath.value != '' &&
    //               //     remotePDFpath.value
    //               //         .toLowerCase()
    //               //         .contains(".pdf")) ?
    //               // Container(
    //               //   child: PdfViewPage(
    //               //     path: assetPDFPath,
    //               //   ),
    //               // )
    //               //     : Container(
    //               //   child: Center(
    //               //     child: Text('Không có file PDF đính kèm'),
    //               //   ),
    //               // )
    //               //     : Center(
    //               //   child: CircularProgressIndicator(),
    //               // )
    //
    //              // ViewPDF(idDuThao:widget.id,nam:year.toString()),
    //               ViewPDFVB(),
    //               NhatKyVBDi(id: widget.id,username:widget.username,
    //                   nam:year),
    //             ],
    //           )
    //         : Center(
    //             child: CircularProgressIndicator(),
    //           ),
    //     bottomNavigationBar: BottomNav(id : widget.id,nam:year,
    //         MaDonVi:widget.MaDonVi),
    //   ),
    // ),);
  }
}

