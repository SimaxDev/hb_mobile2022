import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hb_mobile2021/core/models/VanBanDiJson.dart';
import 'package:hb_mobile2021/core/services/VBDiService.dart';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:hb_mobile2021/ui/main/viewPDF.dart';
import 'package:hb_mobile2021/ui/main/view_pdf_dinh_kem.dart';
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
  String MaDonVi;
  final String nam;
  ChiTietVanBanDi({required this.id,required this.username,required this.nam,required this.MaDonVi});
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
  int year = 2022;
  String ActionXL = "GetVBDiByID";
  ValueNotifier<String> assetPDFPath = ValueNotifier<String>('');
  ValueNotifier<String> remotePDFpath = ValueNotifier<String>('');
  String FileTaiLieu ="";


  Future<File> createFileOfPdfUrl(String filePath) async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
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





  @override
  void initState() {
    // TODO: implement initState
    //_initializeTimer();
    super.initState();
    GetDataDetailVBDi(widget.id);
    if(widget.MaDonVi != null ){
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
    }

   /* getFileFromURL(pdf).then((f)
    {
      if (mounted) { setState(() {
        assetPDFPath = ValueNotifier(f.path);

      });}

    });*/
  }

  GetDataDetailVBDi(int id) async {
    if(widget.MaDonVi == null){
      setState(() {
        widget.MaDonVi= "";
      });
    }
    String detailVBDi=  await getDataDetailVBDi(id, ActionXL,
        widget.MaDonVi);
    if(mounted){
      setState(() {
        var data =  json.decode(detailVBDi)['OData'];

        duthao = VanBanDiJson.fromJson(data);
        FileTaiLieu = json.decode(detailVBDi)
        ['OData']['FileTaiLieu'] != null ?json.decode
          (detailVBDi)['OData']['FileTaiLieu']:"";
        isLoading = true;

      });
    }

  }
  @override
  void dispose(){
    super.dispose();
    pdf = "";

  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return FileTaiLieu != null && FileTaiLieu != "" ? DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                  child: Align(
                    alignment: Alignment.center,

                    child: Text(
                      'Thông tin',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13),
                    ),
                  )
              ), Tab(
                  child: Align(
                    alignment: Alignment.center,

                    child: Text(
                      'Toàn văn',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13),
                    ),
                  )
              ),
              Tab(
                  child: Align(
                    alignment: Alignment.center,

                    child: Text(
                      'Tài liệu kèm theo',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13),
                    ),
                  )
              ),
              Tab(
                  child: Align(
                    alignment: Alignment.center,

                    child: Text(
                      'Gửi nhận',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13),
                    ),
                  )
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
            ViewPDFDK(),
            NhatKyVBDi(id: widget.id,username:widget.username,
                nam:year),
          ],
        )
            : Center(
          child: CircularProgressIndicator(),
        ),
        bottomNavigationBar: BottomNav(id : widget.id,nam:year,
            MaDonVi:widget.MaDonVi,ttVbanDi:duthao),
      ),
    ):DefaultTabController(
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
            MaDonVi:widget.MaDonVi,ttVbanDi:duthao),
      ),
    );




  }
}

