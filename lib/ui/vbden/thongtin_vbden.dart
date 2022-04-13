import 'dart:async';
import 'dart:math';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:hb_mobile2021/core/models/VanBanDenJson.dart';
import 'package:hb_mobile2021/core/models/VanBanDiJson.dart';
import 'package:hb_mobile2021/core/services/DataControllerGetxx.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/core/services/VbdenService.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';

class ThongTinVBDen extends StatefulWidget {
  int id;
  int Yearvb;
  final ttvbDen;

  ThongTinVBDen({this.id, this.Yearvb, this.ttvbDen});

  @override
  _ThongTinVBDen createState() => _ThongTinVBDen();
}

class _ThongTinVBDen extends State<ThongTinVBDen> {
  bool isLoading = false;
  List<dynamic> yKienitems;
  List<dynamic> butPheitems;
  var ttduthao = null;

  List<Widget> listYkien = new List<Widget>();
  List<Widget> listButPhe = new List<Widget>();

  // String ActionXL = "GetVBDByIDMobile";
  String ActionXLYKien = "GetYKien";
  String ActionXLButPhe = "GetButPhe";
  String yKienThuHoi = "";

  final DataController input = Get.put(DataController());
  Timer _timer;

  void _initializeTimer() {
    _timer = Timer.periodic(const Duration(minutes: 5), (_) {
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
  void dispose() {

    if(_timer != null){
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    _initializeTimer();
    super.initState();
    ttduthao = widget.ttvbDen;
    var tendangnhap = sharedStorage.getString("username");
    // GetDataDetailVBDen(widget.id);
    GetallYKien();
    GetallButPhe();
  }

//lấy danh sách chi tiết văn bản đến
//   GetDataDetailVBDen(int id) async {
//     String detailVBDen =  await getDataDetailVBDen(id,ActionXL
//         ,widget.MaDonVi,widget.Yearvb);
//     if (mounted) { setState(() {
//       var data =  json.decode(detailVBDen)['OData'];
//       // ttduthao =  VanBanDenJson.fromJson(data);
//       ttduthao = VanBanDenJson.fromJson(data);
//       vanbanDen = ttduthao;
//       print(ttduthao);
//     }); }
//
//   }
//lấy danh sách ý kiến văn bản đến


  GetallYKien()async{

    if (widget.Yearvb == null) {
      DateTime now = DateTime.now();
      String  nam1 =  DateFormat('yyyy').format(now) ;
      widget.Yearvb = int.parse(nam1);
    }
    String data = await getYkienDataVBDen(
        widget.id, ActionXLYKien, widget.Yearvb);
    setState(() {
      isLoading = true;
      yKienitems = json.decode(data)['OData'];
    });
    isLoading = false;

    GetYkienDataVBDen();
  }
  GetYkienDataVBDen() async {
    // String data =
    //     await getYkienDataVBDen(tendangnhap, id, ActionXLYKien, widget.Yearvb);
    //
    // yKienitems = json.decode(data)['OData'];
    for (var it in yKienitems) {
      listYkien.add(new Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.fromLTRB(10.0, 3, 0, 0),
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: Text(
                          it['ykienNguoiDung']['Title'],
//it['ykienNguoiDung'].contains("#")?
//                           it['ykienNguoiDung'].split("#")[1].toString():
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        it['ykienNoiDung'].toString(),
                        maxLines: 3,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 0, bottom: 10),
                        alignment: Alignment.center,
                        child: Text(GetDate(it['ykienTimeCreated'].toString()),
                            style: new TextStyle(
                                fontSize: 13, color: Colors.black45))),
                  ],
                )
              ],
            ),
          ),
        ],
      ));
      listYkien.add(new Divider());
    }
  }

  //lấy danh sach butphe vbden
  GetallButPhe()async{

    if (widget.Yearvb == null) {
      DateTime now = DateTime.now();
      String  nam1 =  DateFormat('yyyy').format(now) ;
      widget.Yearvb = int.parse(nam1);
    }
    String data = await getYkienDataVBDen(
        widget.id, ActionXLButPhe, widget.Yearvb);
    setState(() {
      isLoading = true;
      butPheitems = json.decode(data)['OData'];
    });
    isLoading = false;

    GetButPheDataVBDen();
  }


  GetButPheDataVBDen() async {
    // if (mounted) {
    //   setState(() {
    //     isLoading = true;
    //   });
    // }
    //
    // String data =
    //     await getYkienDataVBDen(tendangnhap, id, ActionXLButPhe, widget.Yearvb);
    // isLoading = false;
    // butPheitems = json.decode(data)['OData'];

    for (var it in butPheitems) {
      listButPhe.add(new Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.fromLTRB(10.0, 3, 0, 0),
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: Text(
                          it['butpheLanhDao']['Title'].toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        it['butpheNoiDung'].toString(),
                        maxLines: 3,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Transform.translate(
                      offset: Offset(0, -10),
                      child: Container(
                          margin: EdgeInsets.only(top: 0, bottom: 10),
                          alignment: Alignment.center,
                          child: Text(
                              GetDate(it['butpheTimeCreated'].toString()),
                              style: new TextStyle(
                                  fontSize: 13, color: Colors.black45))),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ));
      listButPhe.add(new Divider());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleUserInteraction,
      onPanDown: _handleUserInteraction,
      onScaleStart: _handleUserInteraction,
      child: Scaffold(
        body: ttduthao == null
            ? Center(
                child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue)))
            : getBody(),
      ),
    );
  }

  getBody() {
    VanBanDenJson vbDen = ttduthao;

    thuHoiVBD = vbDen.ThuHoi;
    String LogxulyText = vbDen.LogxulyText;
    checkThuHoi = vbDen.checkThuHoi1;
   if ((!(LogxulyText == null || LogxulyText.isEmpty)
        && !LogxulyText.contains("#DYCapNhap#") 
        && !LogxulyText.contains("#TCCapNhap#")
        && !LogxulyText.contains("#TCThayThe#") 
        && !LogxulyText.contains("#DYThayThe#") 
        && !LogxulyText.contains("#DYThuHoi#") 
        && !LogxulyText.contains("#TCThuHoi#") 
        && !LogxulyText.contains("#DYLayLai#")
        && !LogxulyText.contains("#vbdaduocthaythe;")
        && !LogxulyText.contains("#tuchoi_2#")) 
        || (LogxulyText == null || LogxulyText.isEmpty)){
     setState(() {
       isTraCuu = true;
     });

    };
    // isTraCuu = vbDen.isTraCuu;
    XemDB = vbDen.UserChuaXL;
    vbdTTXuLyVanBanLT = vbDen.vbdTTXuLyVBLT;
    vbdPhuongThuc = vbDen.vbdPT;
    vbdSoVanBan = vbDen.vbdSVB;
    vanbandenCapNhat = vbDen.vanbandenCapNhat;
    vbdIsSentVanBan = vbDen.vbdIsSentVB;
    lstvbdUserChuaXuLy = vbDen.UserChuaXLID;
    for (var item in lstvbdUserChuaXuLy) {
      if ((item['LookupId'] == currentUserID ) ) {
        setState(() {
          vbdUserChuaXuLy = true;
        });

      } else {
        // setState(() {
        //   vbdUserChuaXuLy = false;
        // });

      }
    }
    print(vbdUserChuaXuLy);

    vbdHanXuLy = vbDen.HanXL;
    checkbtnXDB = vbDen.checkbtnXDB1;

    String vbChuaXL = vbDen.CBChuaXuLy;

    Listpdf = vbDen.pdf1;
    ListpdfDK = vbDen.pdfDK;

    List chuaPDF = [];
    List chuaPDFDK = [];
    for (var i in vbDen.pdf1) {
      if (i['ExtenFile'].contains("pdf") &&i['Name'].contains("signed")) {

        chuaPDF.add(i);
        // pdf2 = i['Url'];
        if(chuaPDF != null && chuaPDF !=[]&& chuaPDF.length >0){
          dynamic max = chuaPDF.first;
          // print(max);
          chuaPDF.forEach((e) {
            if (e['Name'].length > max['Name'].length) max = e;
          });
          pdf = (max['Url']);
          namepdf = (max['Name']);
        }
      }
      else{
        pdf = (i['Url']);
      }

    }

    for (var i in vbDen.pdfDK) {
      if (i['ExtenFile'].contains("pdf") ) {

        chuaPDFDK.add(i);
        // pdf2 = i['Url'];
        if(chuaPDFDK != null && chuaPDFDK !=[]&& chuaPDFDK.length >0){
          dynamic max = chuaPDFDK.first;
          // print(max);
          chuaPDFDK.forEach((e) {
            if (e['Name'].length > max['Name'].length) max = e;
          });
          pdfDK = (max['Url']);
          namepdf = (max['Name']);
        }
      }
      else{
        pdfDK = (i['Url']);
      }

    }


    yKienThuHoi = vbDen.yKienThuHoi;

    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 5,
            ),

    // (yKienThuHoi.isNotEmpty ||
    // yKienThuHoi != null)&& (vbdTTXuLyVanBanLT != 29
    // && vbdTTXuLyVanBanLT !=16 && vbdTTXuLyVanBanLT !=15
    // && vbdTTXuLyVanBanLT !=14 && vbdTTXuLyVanBanLT != 13
    // && vbdTTXuLyVanBanLT != 18 && vbdTTXuLyVanBanLT != 21
    // && vbdTTXuLyVanBanLT != 23 && vbdTTXuLyVanBanLT != 25
    // && vbdTTXuLyVanBanLT != 27
    // && vbdPhuongThuc == 2 )
    //             ? Column(
    //           children: [
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Container(
    //                   width: MediaQuery.of(context).size.width * 0.4,
    //                   padding: EdgeInsets.only(left: 20.0),
    //                   child: Text(
    //                     'Ý kiến thu hồi/lấy lại/thay thế',
    //                     style: TextStyle(
    //                         fontWeight: FontWeight.bold, fontSize: 14),
    //                   ),
    //                 ),
    //                 Container(
    //                   width: MediaQuery.of(context).size.width * 0.6,
    //                   padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
    //                   child: Text(
    //                     yKienThuHoi,
    //                     style: TextStyle(
    //                         fontWeight: FontWeight.normal,
    //                         fontSize: 14,
    //                         color: Colors.red),
    //                     // overflow: TextOverflow.ellipsis,
    //                     textAlign: TextAlign.start,
    //                   ),
    //                 )
    //               ],
    //             ),
    //             Divider(),
    //           ],
    //         )
    //             : SizedBox(),



    //         (yKienThuHoi.isNotEmpty ||
    // yKienThuHoi != null)
            !(yKienThuHoi?.isEmpty ?? true)
                && (vbdTTXuLyVanBanLT != 29 && vbdTTXuLyVanBanLT !=16
                && vbdTTXuLyVanBanLT !=15 && vbdTTXuLyVanBanLT !=14
                && vbdTTXuLyVanBanLT != 13 && vbdTTXuLyVanBanLT != 18
                && vbdTTXuLyVanBanLT != 21 && vbdTTXuLyVanBanLT != 23
                && vbdTTXuLyVanBanLT != 25
                && vbdTTXuLyVanBanLT != 27 && vbdPhuongThuc != 2)
            
            
            // yKienThuHoi.isNotEmpty ||
            //         yKienThuHoi != null &&
            //             (vbdTTXuLyVanBanLT != 29 &&
            //                 vbdTTXuLyVanBanLT != 16 &&
            //                 vbdTTXuLyVanBanLT != 15 &&
            //                 vbdTTXuLyVanBanLT != 14 &&
            //                 vbdTTXuLyVanBanLT != 13 &&
            //                 vbdTTXuLyVanBanLT != 18 &&
            //                 vbdTTXuLyVanBanLT != 21 &&
            //                 vbdTTXuLyVanBanLT != 23 &&
            //                 vbdTTXuLyVanBanLT != 25 &&
            //                 vbdTTXuLyVanBanLT != 27)
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            padding: EdgeInsets.only(left: 20.0),
                            child: Text(
                              'Ý kiến thu hồi/lấy lại/thay thế',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                            child: Text(
                              yKienThuHoi,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: Colors.red),
                              // overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            ),
                          )
                        ],
                      ),
                      Divider(),
                    ],
                  )
                : SizedBox(),

            (vbdTTXuLyVanBanLT == 16 ||
                    vbdTTXuLyVanBanLT == 15 ||
                    vbdTTXuLyVanBanLT == 14) && vbdPhuongThuc == 2
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            padding: EdgeInsets.only(left: 20.0),
                            child: Text(
                              'Trạng thái',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                            child: Text(
                              "Đã từ chối thu hồi/lấy lại/thay thế",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: Colors.red),
                              // overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            ),
                          )
                        ],
                      ),
                      Divider(),
                    ],
                  )
                : SizedBox(),

            ( vbdTTXuLyVanBanLT == 18 ||
                    vbdTTXuLyVanBanLT == 21 ||
                    vbdTTXuLyVanBanLT == 23 ||
                    vbdTTXuLyVanBanLT == 25) && vbdPhuongThuc == 2
    ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            padding: EdgeInsets.only(left: 20.0),
                            child: Text(
                              'Trạng thái',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                            child: Text(
                              "Đã đồng ý thu hồi/lấy lại/thay thế",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: Colors.red),
                              // overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            ),
                          )
                        ],
                      ),
                      Divider(),
                    ],
                  )
                : SizedBox(),


            vbDen.ID>0  &&( (vbdTTXuLyVanBanLT==26 && vanbandenCapNhat != null) 
                || vbdTTXuLyVanBanLT==17
                || vbdTTXuLyVanBanLT==24 || vbdTTXuLyVanBanLT==28)
                && vbdPhuongThuc != 2 ?

            (
                (LogxulyText.isNotEmpty ||
                LogxulyText != null
                    && !LogxulyText.contains("#DYCapNhap#")
                    && !LogxulyText.contains("#TCCapNhap#")
                    && !LogxulyText.contains("#TCThayThe#")
                    && !LogxulyText.contains("#DYThuHoi#")
                    && !LogxulyText.contains("#TCThuHoi#")
                    && !LogxulyText.contains("#DYLayLai#"))
                || LogxulyText.isEmpty ||
                LogxulyText == null


                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.lightBlue[50], width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: TextButton.icon(
                        icon: Icon(Icons.delete_forever_outlined),
                        label: Text(
                          "Từ chối",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(
                              Colors.orangeAccent),
                          foregroundColor:
                          MaterialStateProperty.all<Color>(
                              Colors.white),
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.lightBlue[50], width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: TextButton.icon(
                        icon: Icon(Icons.send_and_archive),
                        label: Text(
                          "Đồng ý",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () async {
                          EasyLoading.show();
                          Navigator.of(context).pop();
                          EasyLoading.dismiss();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(
                              Colors.lightBlue[50]),
                          foregroundColor:
                          MaterialStateProperty.all<Color>(
                              Colors.blue),
                        )),
                  ),
                ),
              ],
            )
                : SizedBox()): SizedBox(),


            vbDen.ID>0  && ((vbdTTXuLyVanBanLT==26 && vanbandenCapNhat != null)
                || vbdTTXuLyVanBanLT==17 || vbdTTXuLyVanBanLT==24
                || vbdTTXuLyVanBanLT==28) && vbdPhuongThuc == 2
                //&& CheckVBNoiBo > 0

           ? (
                      (LogxulyText.isNotEmpty ||
                        LogxulyText != null && !LogxulyText.contains("#DYCapNhap#")
                        && !LogxulyText.contains("#TCCapNhap#") && !LogxulyText.contains("#TCThayThe#")
                        && !LogxulyText.contains("#DYThuHoi_" + currentUserID.toString()+"#")
                        && !LogxulyText.contains("#TCThuHoi_" + currentUserID.toString()+"#")
                        && !LogxulyText.contains("#DYLayLai_" + currentUserID.toString()+"#"))
                    ||LogxulyText.isEmpty ||
                    LogxulyText == null


                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.lightBlue[50], width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: TextButton.icon(
                            icon: Icon(Icons.delete_forever_outlined),
                            label: Text(
                              "Từ chối",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () async {
                              var tendangnhap = sharedStorage.getString("username");
                              EasyLoading.show();
                              // var thanhcong = await postChuyenVBDi(widget.id,
                              //   "TUCHOI",widget.Yearvb,yKienTuChoi);
                              Navigator.of(context).pop();
                              EasyLoading.dismiss();
                             // showAlertDialog(context, json.decode
                              //(thanhcong)['Message']);
                            },
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all<Color>(
                                  Colors.orangeAccent),
                              foregroundColor:
                              MaterialStateProperty.all<Color>(
                                  Colors.white),
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.lightBlue[50], width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: TextButton.icon(
                            icon: Icon(Icons.send_and_archive),
                            label: Text(
                              "Đồng ý",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () async {
                              EasyLoading.show();
                              Navigator.of(context).pop();
                              EasyLoading.dismiss();
                            },
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all<Color>(
                                  Colors.lightBlue[50]),
                              foregroundColor:
                              MaterialStateProperty.all<Color>(
                                  Colors.blue),
                            )),
                      ),
                    ),
                  ],
                )
                    : SizedBox()): SizedBox(),


          
            

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Số ký hiệu',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbDen.SoKyHieu,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
            Divider(),
            //giải phân cách
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Ngày ban hành',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                  child: Text(
                    vbDen.NgayBanHanh,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Loại văn bản',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbDen.LoaiVanBan,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'CQ ban hành',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                  child: Text(
                    ttduthao.CoQuanBanHanh,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Hạn xử lý',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbDen.HanXL,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Người ký',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbDen.NguoiKy,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Ngày đến',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbDen.NgayDen,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Ngày vào sổ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbDen.NgayVaoSo,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Văn bản nhận liên thông',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbDen.VBNhanLT,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Thời gian nhận',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbDen.ThoiGianNhan,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Trích yếu',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbDen.TrichYeu,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Mã định danh đơn vị',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbDen.MaDinhDanhDonVi,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Mã định danh VB',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbDen.MaDinhDanhVB,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Độ  mật',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbDen.DoMat,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Độ khẩn',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbDen.DoKhan,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
            Divider(),
            (vbDen.vbdNguoiDungPT >0 || vbDen.vbdPhongBanPT >0)&& groupID ==
                198
           ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        'PB/CB Xử lý chính',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                      child: Text(
                        vbDen.XuLyChinh,
                        style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                        textAlign: TextAlign.justify,
                      ),
                    )
                  ],
                ),
                Divider(),
              ],
            ):SizedBox(),

            (vbDen.vbdUserXuLyC >0 && (groupID == 198)) ?Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      'PB/CB phụ trách',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                    child: Text(
                      vbDen.CBPhuTrach,
                      style:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                      textAlign: TextAlign.justify,
                    ),
                  )
                ],
              ),
              Divider(),
            ],):SizedBox(),
            (vbDen.vbdNguoiDungPT >0 && !(groupID == 198)) ?Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      'PB/CB phụ trách',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                    child: Text(
                      vbDen.XuLyChinh,
                      style:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                      textAlign: TextAlign.justify,
                    ),
                  )
                ],
              ),
              Divider(),
            ],):SizedBox(),
            (vbDen.CBPhoiHop.isEmpty ||vbDen.CBPhoiHop != null ) ? Column
              (children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Cán bộ phối hợp xử lý VB',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                    child: Text(
                      vbDen.CBPhoiHop,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Colors.red),
                      textAlign: TextAlign.justify,
                    ),
                  )
                ],
              ),
              Divider(),
            ],):SizedBox(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Cán bộ xem để biết',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbDen.CBXemDeBiet,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'PB/CB nhận VB',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbDen.NhanVB,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Cán bộ chưa xử lý/kết thúc văn bản',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.red),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbChuaXL,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.red),
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
            Divider(),
          ],
        ),
        listButPhe == null || listButPhe.length == 0
            ? Container()
            : Container(
                //padding: EdgeInsets.only(left: 18.0),
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                alignment: Alignment.center,
                child: Text(
                  'Danh sách bút phê',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontStyle: FontStyle.italic),
                ),
              ),
        Container(
          child: Column(
            children: listButPhe,
          ),
        ),
        Divider(),
        listYkien == null || listYkien.length == 0
            ? Container()
            : Container(
                // padding: EdgeInsets.only(left: 18.0),
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  'Danh sách xin ý kiến',
                  style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.blue),
                ),
              ),
        Container(
          child: Column(
            children: listYkien,
          ),
        ),
      ],
    );
  }
}

//chuyển đổi datetime
String GetDate(String strDt) {
  // return DateFormat('yyyy-MM-dd  kk:mm')
  //     .format(DateFormat('yyyy-MM-dd kk:mm').parse(strDt));
  var parsedDate = DateTime.parse(strDt);
  return ("${parsedDate.day}/${parsedDate.month}/${parsedDate.year}  "
      "${parsedDate.hour}:${parsedDate.minute}");
}

String getTrangThaiNoiNhan(int trangthai) {
  switch (trangthai) {
    case 3:
      return "Đã cập nhật/thu hồi/lấy lại/thay thế";
      break;
    case 2:
      return "Đang yêu cầu cập nhật/thu hồi/lấy lại/thay thế";
      break;
    case 4:
      return "Từ chối cập nhật/thu hồi/lấy lại/thay thế";
      break;
    default:
      return "";
      break;
  }
}
