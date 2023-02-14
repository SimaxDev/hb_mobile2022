import 'dart:developer' as Dev;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hb_mobile2021/core/services/VBDuThaoService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:hb_mobile2021/ui/main/view_pdf_dinh_kem.dart';
import 'package:hb_mobile2021/ui/vbdi/view_pdf.dart';
import 'package:hb_mobile2021/ui/vbduthao/BottomNavigator.dart';
import 'package:hb_mobile2021/ui/vbduthao/phieu_trinh/view_pdf.dart';
import 'ThongTinVBDT.dart';
import 'NhatKyDuThao.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:hb_mobile2021/common/SearchDropdownListServer.dart';
import 'phieu_trinh/chitietvbpt.dart';

import 'package:hb_mobile2021/core/models/VanBanDuThaoJSon.dart';
class ThongTinDuThaoWidget extends StatefulWidget {
  ThongTinDuThaoWidget({Key? key, required this.idDuThao,required this.users,required this.nam,required this.MaDonVi}) :
super
      (key:
  key);
  final int idDuThao;
  final String users;
   String nam;
  final String MaDonVi;

  @override
  State<StatefulWidget> createState() {
    return TabBarVBDuThao();
  }
}

class TabBarVBDuThao extends State<ThongTinDuThaoWidget> {
  bool isLoading = false;

//  String assetPDFPath = "";
  ValueNotifier<String> assetPDFPath = ValueNotifier<String>('');
  ValueNotifier<String> remotePDFpath = ValueNotifier<String>('');
  var duThao = null;
  var duThaoPT = null;
  var urlFile = null;
  var idPhieuTrinh = null;
  late String AuthToken;
  bool isLoadingPDF = true;
  List _myActivities = [];
   var detailVBDT = null;
  String ActionXL = "GetVBDTByID";
  List<ListData> vanbanList = [];
  var ActionXL1 = "";
  var chitiet =  null;
  var  daduyet= null;
  var vanban =  null;
  var tendangnhap = "";
  int year=2023;
  double pdfWidth = 612.0;
  double pdfHeight = 792.0;
  String ActionXLPT = "GetToTrinh";
  String FileTaiLieu ="";

  List<String> _colors = <String>['', 'Văn bản 1', 'Văn bản 2', 'Văn bản 3', 'Văn bản 4'];
  String _color = '';




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
    super.initState();
    // _initializeTimer();
    GetDataDetailVBDT();
    GetDataDetailVBPT();
    tendangnhap = sharedStorage!.getString("username")!;
    if (tendangnhap == null || tendangnhap == "") {
      tendangnhap = widget.users;
    }

    // GetDataNguoiPhoiHop(tendangnhap);
    // GetIdUser(tendangnhap);
    // isyKienField == false ?

    if(widget.MaDonVi != null){
      if (widget.MaDonVi.startsWith("sites")) {
        String a = "2023";


        if(widget.nam != null){
          a = widget.nam;
        }
        year = int.parse(a);
        // List<string> lstTT = MaDonVi.Split('/').ToList();
        // if (lstTT.Count > 0 && lstTT.Count == 3)
        //   SYear = lstTT[1].ToInt32();
      }
    }

  }

  GetDataDetailVBDT() async {
    if (widget.nam == null) {
      DateTime now = DateTime.now();
      String  nam1 =  DateFormat('yyyy').format(now) ;
      widget.nam = nam1;
    }
    String detailVBDT = await getDataDetailVBDT(
        widget.idDuThao, ActionXL, widget.nam, widget.MaDonVi);
    if(mounted){
      setState(() {
      var  duThaoDT = json.decode(detailVBDT)['OData'];
      FileTaiLieu = json.decode(detailVBDT)['OData']
      ['FileTaiLieu'] != null ?json.decode(detailVBDT)['OData']['FileTaiLieu']:"";
        duThao = VanBanDuThaoJson.fromJson(duThaoDT);
        isLoading = true;
      });
    }

  }
  GetDataDetailVBPT() async {
    if (widget.nam == null) {
      DateTime now = DateTime.now();
      String  nam1 =  DateFormat('yyyy').format(now) ;
      widget.nam = nam1;
    }
    String PT = await getDataDetailVBPT(
        widget.idDuThao, ActionXLPT, widget.nam);
    if(mounted){
     setState(() {
        duThaoPT = json.decode(PT)['OData'];
        List pdfPT1 = [];
        pdfPT1  = duThaoPT['ListFileAttach'] != null &&duThaoPT['ListFileAttach']
            .length >0 ? duThaoPT['ListFileAttach'] :[];
        ListpdfPT = pdfPT1;


        List chuaPDF = [];
        for (var i in pdfPT1) {
          if (i['ExtenFile'].contains("pdf")) {

            chuaPDF.add(i);
            // pdf2 = i['Url'];
            if(chuaPDF != null && chuaPDF !=[]&& chuaPDF.length >0){
              dynamic max = chuaPDF.first;
              // print(max);
              chuaPDF.forEach((e) {
                if (e['Name'].length > max['Name'].length) max = e;
              });
              pdfPT = max['Url'];
              namepdf=max['Name'];

            }
          }
          else
          {
            pdfPT = i['Url'];
          }
        }
      });
    }

  }

  Future<File> createFileOfPdfUrl(String filePath) async {
    Completer<File> completer = Completer();

    try {
      final url = 'http://qlvbapi.moj.gov.vn/' + filePath;
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


  List<bool> isSelected = [false, false, false];
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return FileTaiLieu != null && FileTaiLieu != "" ?DefaultTabController(
      length: 6,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child:
              TabBar(
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Tab(
                      child: Align(
                        alignment: Alignment.center,

                        child: Text(
                          'Dự thảo',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13),
                        ),
                      )
                  ),
                  Tab(
                      child: Align(

                        alignment: Alignment.center,
                        child: Text(
                          'Phiếu trình',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13),
                        ),
                      )),
                  Tab(
                      child: Align(

                        alignment: Alignment.center,
                        child: Text(
                          'TL kèm theo DT',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13),
                        ),
                      )),
                  // Tab(
                  //     child: Align(
                  //
                  //       alignment: Alignment.center,
                  //       child: Text(
                  //         'TL kèm theo PT',
                  //         textAlign: TextAlign.center,
                  //         style: TextStyle(fontSize: 13),
                  //       ),
                  //     )),
                  Tab(
                      child: Align(

                        alignment: Alignment.center,
                        child: Text(
                          'Toàn văn-DT',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13),
                        ),
                      )),
                  Tab(
                      child: Align(

                        alignment: Alignment.center,
                        child: Text(
                          'Toàn văn-PT',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13),
                        ),
                      )),
                  Tab(
                      child: Align(

                        alignment: Alignment.center,
                        child: Text(
                          'Gửi nhận',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13),
                        ),
                      )),
                ],
              ) ,
            ),
            title: Text('Chi tiết văn bản dự thảo'),
          ),),
        body: isLoading == true
            ? TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            ThongTinVBDT(
                idDuThao: widget.idDuThao,nam:widget.nam,MaDonVi:widget
                .MaDonVi,ttDuThao :duThao
            ),
            ThongTinPhieuTrinh(
                idPhieuTrinh: widget.idDuThao,nam: widget.nam,duThaoPT:duThaoPT
            ),
            ViewPDFDK(),
            // ViewPDFDK(),
            // ViewPDF(idDuThao: widget.idDuThao,nam: widget.nam,left:0,
            //     top:0,pdfWidth: pdfWidth,pdfHeight: pdfHeight ),
            ViewPDF(idDuThao: widget.idDuThao,nam: widget.nam,left:0,viewPDF: '',
                top:0,pdfWidth: pdfWidth,pdfHeight: pdfHeight ),
            ViewPDFPT(idDuThao: widget.idDuThao,nam: widget.nam, viewPDF: '',
                ),
            // !isLoadingPDF
            //     ? (remotePDFpath.value != '' && remotePDFpath.value.toLowerCase().contains(".pdf"))
            //         ? Container(
            //             child: PdfViewPage(
            //               path: remotePDFpath,
            //               // idDuThao: widget.idDuThao,
            //               // token: AuthToken
            //             ),
            //           )
            //         : Container(
            //             child: Center(
            //               child: Text('Không có file PDF đính kèm'),
            //             ),
            //           )
            //     : Center(
            //         child: CircularProgressIndicator(),
            //       ),
            NhatKyDuThao(
                idDuThao: widget.idDuThao,
                username:widget.users,nam:widget.nam
            ),
          ],
        )
            : Center(
          child: CircularProgressIndicator(),
        ),
        bottomNavigationBar:isLoading == true?  PreferredSize(preferredSize: Size.fromHeight(50.0),
          child: BottomNav(id:widget.idDuThao,username :  widget
              .users,nam:year.toString(),MaDonVi:widget.MaDonVi,ttDuThao:duThao
          ),):SizedBox(),
      ),
    ):DefaultTabController(
      length: 5,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child:
              TabBar(
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Tab(
                      child: Align(
                        alignment: Alignment.center,

                        child: Text(
                          'Dự thảo',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13),
                        ),
                      )
                  ),
                  Tab(
                      child: Align(

                        alignment: Alignment.center,
                        child: Text(
                          'Phiếu trình',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13),
                        ),
                      )),
                  Tab(
                      child: Align(

                        alignment: Alignment.center,
                        child: Text(
                          'Toàn văn-DT',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13),
                        ),
                      )),
                  Tab(
                      child: Align(

                        alignment: Alignment.center,
                        child: Text(
                          'Toàn văn-PT',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13),
                        ),
                      )),
                  Tab(
                      child: Align(

                        alignment: Alignment.center,
                        child: Text(
                          'Gửi nhận',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13),
                        ),
                      )),
                ],
              ) ,
            ),
            title: Text('Chi tiết văn bản dự thảo'),
          ),),
        body: isLoading == true
            ? TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            ThongTinVBDT(
                idDuThao: widget.idDuThao,nam:widget.nam,MaDonVi:widget
                .MaDonVi,ttDuThao :duThao
            ),
            ThongTinPhieuTrinh(
                idPhieuTrinh: widget.idDuThao,nam: widget.nam,duThaoPT:duThaoPT
            ),
            ViewPDF(idDuThao: widget.idDuThao,nam: widget.nam,left:0,viewPDF: '',
                top:0,pdfWidth: pdfWidth,pdfHeight: pdfHeight ),
            ViewPDFPT(idDuThao: widget.idDuThao,nam: widget.nam,viewPDF:'' ,
            ),
            // !isLoadingPDF
            //     ? (remotePDFpath.value != '' && remotePDFpath.value.toLowerCase().contains(".pdf"))
            //         ? Container(
            //             child: PdfViewPage(
            //               path: remotePDFpath,
            //               // idDuThao: widget.idDuThao,
            //               // token: AuthToken
            //             ),
            //           )
            //         : Container(
            //             child: Center(
            //               child: Text('Không có file PDF đính kèm'),
            //             ),
            //           )
            //     : Center(
            //         child: CircularProgressIndicator(),
            //       ),
            NhatKyDuThao(
                idDuThao: widget.idDuThao,
                username:widget.users,nam:widget.nam
            ),
          ],
        )
            : Center(
          child: CircularProgressIndicator(),
        ),
        bottomNavigationBar:isLoading == true?  PreferredSize(preferredSize: Size.fromHeight(50.0),
          child: BottomNav(id:widget.idDuThao,username :  widget
              .users,nam:year.toString(),MaDonVi:widget.MaDonVi,ttDuThao:duThao
          ),):SizedBox(),
      ),
    );

  }

  void _tapSign() {
    Dev.log('message');
  }



  // GetIdUser(String tendangnhap) async {
  //
  //  detailVBDT = await GetInfoUserService(tendangnhap);
  // }
  //
  //
  // GetDataNguoiPhoiHop(String tendangnhap) async {
  //   String detailVBDT = await getDataCVB(tendangnhap, ActionXL);
  //   setState(() {
  //     vanban = json.decode(detailVBDT)['OData'];
  //     chitiet = VanBanDuThaoJson.fromJson(vanban);
  //     var lstData = (vanban as List).map((e) => ListData.fromJson(e)).toList();
  //     List<ListData> lstDataSearch = List<ListData>();
  //     lstData.forEach((element) {
  //       lstDataSearch.add(element);
  //       vanbanList = lstDataSearch;
  //
  //     });
  //   });
  // }



}
