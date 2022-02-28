import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hb_mobile2021/core/models/VanBanDenJson.dart';
import 'package:hb_mobile2021/core/services/VbdenService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'package:hb_mobile2021/ui/main/viewPDF.dart';
import 'package:hb_mobile2021/ui/vbdi/view_pdf.dart';
import 'nhatky_vbden.dart';
import 'thongtin_vbden.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:hb_mobile2021/ui/vbden/BottomNavigator.dart';
import 'package:open_file/open_file.dart';


class ChiTietVBDen extends StatefulWidget {
  int id;
  int Yearvb;
  final String ListName;
  final String MaDonVi;



  ChiTietVBDen({this.id,this.Yearvb,this.ListName,this.MaDonVi});

  @override
  _ChiTietVBDen createState() => _ChiTietVBDen(ItemId:id);
}

class _ChiTietVBDen extends State<ChiTietVBDen> {
   int ItemId;
   _ChiTietVBDen({this.ItemId});
  bool isLoading = false;
  bool isLoadingPDF = true;
  var urlFile = null;
  ValueNotifier<String> assetPDFPath = ValueNotifier<String>('');
  ValueNotifier<String> remotePDFpath = ValueNotifier<String>('');
   var  ttduthao = null ;
   String ActionXL = "GetVBDByIDMobile";
  int year = 0;
   Timer _timer;


   void _initializeTimer() {
     _timer = Timer.periodic(const Duration(minutes:5), (_) {
       logOut(context);
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

   @override
  void initState() {
    // _initializeTimer();
    // TODO: implement initState
    super.initState();
    //getFileFromURL("http://qlvbapi.moj.gov.vn/Uploads/cvlan42019.pdf").then
    // ((f)
    GetDataDetailVBDen(widget.id);
    getFileFromURL(pdf).then((f)
    {
      if (mounted) {setState(() {
        assetPDFPath = ValueNotifier(f.path);

      });}

    });
    if (widget.MaDonVi.startsWith("sites"))
    {
      year =  widget.Yearvb;
      // List<string> lstTT = MaDonVi.Split('/').ToList();
      // if (lstTT.Count > 0 && lstTT.Count == 3)
      //   SYear = lstTT[1].ToInt32();
    }
  }
   GetDataDetailVBDen(int id) async {
     String detailVBDen =  await getDataDetailVBDen(id,ActionXL
         ,widget.MaDonVi,widget.Yearvb);
     if (mounted) { setState(() {
       var data =  json.decode(detailVBDen)['OData'];
       // ttduthao =  VanBanDenJson.fromJson(data);
       ttduthao = VanBanDenJson.fromJson(data);
       vanbanDen = ttduthao;
       isLoading = true;
     }); }

   }

  //lấy pdf
  Future<File> getFileFromURL(String url) async {
    try {
      var url11 = Uri.parse(url);
      var data = await http.get(url11);
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();//truy cap vao muc chinh
      File file = File("${dir.path}/VanBanGoc.pdf"); // tao 1 tep moi

      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url flie");
    }
  }

  @override
  Widget build(BuildContext context) {

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
             title: Text('Chi tiết văn bản đến'),
           ),
           body:  isLoading == true?TabBarView(
             physics: NeverScrollableScrollPhysics(),
             children: [
               //ThongTinVBDen(id:widget.id,username:widget.username),
               ThongTinVBDen(ttvbDen:ttduthao,id:widget.id, Yearvb: year),
               ViewPDFVB(),
               // Container(
               //   child: PdfViewPage(
               //     path: assetPDFPath,
               //   ),
               // ),
               NhatKyVBDen(id: widget.id,nam: year,),
             ],
           ):Center(
             child: CircularProgressIndicator(),
           ),
           bottomNavigationBar:isLoading == true? BottomNav(id  : ItemId,nam: year,
               MaDonVi:widget.MaDonVi,ttvbDen:ttduthao):SizedBox(),
         )
     );
    // return GestureDetector(
    //   onTap: _handleUserInteraction,
    //   onPanDown: _handleUserInteraction,
    //   onScaleStart: _handleUserInteraction,
    //   child:DefaultTabController(
    //     length: 3,
    //     child: Scaffold(
    //       appBar: AppBar(
    //         leading: IconButton(
    //           icon: Icon(Icons.arrow_back),
    //           onPressed: () => Navigator.pop(context, false),
    //         ),
    //         bottom: TabBar(
    //           tabs: [
    //             Tab(
    //               text: 'Thông tin',
    //             ),
    //             Tab(
    //               text: 'Toàn văn',
    //             ),
    //             Tab(
    //               text: 'Gửi nhận',
    //             ),
    //           ],
    //         ),
    //         title: Text('Chi tiết văn bản đến'),
    //       ),
    //      body:  isLoading == true?TabBarView(
    //        physics: NeverScrollableScrollPhysics(),
    //        children: [
    //          //ThongTinVBDen(id:widget.id,username:widget.username),
    //          ThongTinVBDen(ttvbDen:ttduthao,id:widget.id, Yearvb: year),
    //          ViewPDFVB(),
    //          // Container(
    //          //   child: PdfViewPage(
    //          //     path: assetPDFPath,
    //          //   ),
    //          // ),
    //          NhatKyVBDen(id: widget.id,nam: year,),
    //        ],
    //      ):Center(
    //        child: CircularProgressIndicator(),
    //      ),
    //       bottomNavigationBar:isLoading == true? BottomNav(id  : ItemId,nam: year,
    //           MaDonVi:widget.MaDonVi,ttvbDen:ttduthao):SizedBox(),
    //     )
    // ),);
  }
}
