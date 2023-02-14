import 'dart:convert';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:flutter/material.dart';
import 'package:hb_mobile2021/core/models/VanBanDenJson.dart';
import 'package:hb_mobile2021/core/services/VbdenService.dart';
import 'package:hb_mobile2021/ui/main/viewPDF.dart';
import 'package:hb_mobile2021/ui/main/view_pdf_dinh_kem.dart';
import 'nhatky_vbden.dart';
import 'thongtin_vbden.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:hb_mobile2021/ui/vbden/BottomNavigator.dart';


class ChiTietVBDen extends StatefulWidget {
  int id;
  int Yearvb;
  final String ListName;
  String MaDonVi;



  ChiTietVBDen({required this.id,required this.Yearvb,required this.ListName,required this.MaDonVi});

  @override
  _ChiTietVBDen createState() => _ChiTietVBDen(ItemId:id);
}

class _ChiTietVBDen extends State<ChiTietVBDen> {
   int ItemId;
   _ChiTietVBDen({required this.ItemId});
  bool isLoading = false;
  bool isLoadingPDF = true;
  var urlFile = null;
  ValueNotifier<String> assetPDFPath = ValueNotifier<String>('');
  ValueNotifier<String> remotePDFpath = ValueNotifier<String>('');
   var  ttduthao = null ;
   String ActionXL = "GetVBDByIDMobile";
  int year = 2023;
  List FileTaiLieu =[];

   @override
   void dispose(){
     super.dispose();
     pdf = "";
     // if(_timer != null){
     //   _timer.cancel();
     // }
   }

   @override
  void initState() {
    // _initializeTimer();
    // TODO: implement initState
    super.initState();
    //getFileFromURL("http://qlvbapi.moj.gov.vn/Uploads/cvlan42019.pdf").then
    // ((f)
    GetDataDetailVBDen(widget.id);
    // getFileFromURL(pdf).then((f)
    // {
    //   if (mounted) {setState(() {
    //     assetPDFPath = ValueNotifier(f.path);
    //
    //   });}
    //
    // });
    if(widget.MaDonVi != null){
      if (widget.MaDonVi.startsWith("sites"))
      {
        year =  widget.Yearvb;
      }
    }

  }
   GetDataDetailVBDen(int id) async {
     if(widget.MaDonVi == null){
       setState(() {
         widget.MaDonVi= "";
       });
     }
     String detailVBDen =  await getDataDetailVBDen(id,ActionXL
         ,widget.MaDonVi,widget.Yearvb);
     if (mounted) { setState(() {
       var data =  json.decode(detailVBDen)['OData'];

       // ttduthao =  VanBanDenJson.fromJson(data);
       ttduthao = VanBanDenJson.fromJson(data);
       FileTaiLieu = json.decode(detailVBDen)
       ['OData']['vanBanDen']['lstFileTaiLieuDinhKem'] != null ?json.decode
         (detailVBDen)['OData']['vanBanDen']['lstFileTaiLieuDinhKem']:[];
       vanbanDen = ttduthao;
       isLoading = true;
     }); }

   }

  //lấy pdf
  // Future<File> getFileFromURL(String url) async {
  //   try {
  //     var url11 = Uri.parse(url);
  //     var data = await http.get(url11);
  //     var bytes = data.bodyBytes;
  //     var dir = await getApplicationDocumentsDirectory();//truy cap vao muc chinh
  //     File file = File("${dir.path}/VanBanGoc.pdf"); // tao 1 tep moi
  //
  //     File urlFile = await file.writeAsBytes(bytes);
  //     return urlFile;
  //   } catch (e) {
  //     throw Exception("Error opening url flie");
  //   }
  // }

  @override
  Widget build(BuildContext context) {

     return FileTaiLieu != null && FileTaiLieu.length >0
         ?DefaultTabController(
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
               ViewPDFDK(),
               NhatKyVBDen(id: widget.id,nam: year,),
             ],
           ):Center(
             child: CircularProgressIndicator(),
           ),
           bottomNavigationBar:isLoading == true? BottomNav(id  : ItemId,nam: year,
               MaDonVi:widget.MaDonVi,ttvbDen:ttduthao):SizedBox(),
         )
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




  }
}
