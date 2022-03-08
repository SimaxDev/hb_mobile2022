import 'dart:async';
import 'dart:math';

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

    _timer.cancel();
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
    GetYkienDataVBDen(widget.id, tendangnhap);
    GetButPheDataVBDen(widget.id, tendangnhap);
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
  GetYkienDataVBDen(int id, String tendangnhap) async {
    String data =
        await getYkienDataVBDen(tendangnhap, id, ActionXLYKien, widget.Yearvb);

    yKienitems = json.decode(data)['OData'];
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
  GetButPheDataVBDen(int id, String tendangnhap) async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    String data =
        await getYkienDataVBDen(tendangnhap, id, ActionXLButPhe, widget.Yearvb);
    isLoading = false;
    butPheitems = json.decode(data)['OData'];

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

    checkThuHoi = vbDen.checkThuHoi1;
    XemDB = vbDen.UserChuaXL;
    vbdTTXuLyVanBanLT = vbDen.vbdTTXuLyVBLT;
    vbdPhuongThuc = vbDen.vbdPT;
    vbdSoVanBan = vbDen.vbdSVB;
    vanbandenCapNhat = vbDen.vanbandenCapNhat;
    vbdIsSentVanBan = vbDen.vbdIsSentVB;
    lstvbdUserChuaXuLy = vbDen.UserChuaXLID;
    for (var item in lstvbdUserChuaXuLy) {
      if (item['LookupId'] == currentUserID) {
        vbdUserChuaXuLy = true;
        break;
      } else {
        vbdUserChuaXuLy = false;
      }
    }

    vbdHanXuLy = vbDen.HanXL;
    checkbtnXDB = vbDen.checkbtnXDB1;
    String LogxulyText = vbDen.LogxulyText;
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

            yKienThuHoi.isNotEmpty ||
                    yKienThuHoi != null &&
                        (vbdTTXuLyVanBanLT != 29 &&
                            vbdTTXuLyVanBanLT != 16 &&
                            vbdTTXuLyVanBanLT != 15 &&
                            vbdTTXuLyVanBanLT != 14 &&
                            vbdTTXuLyVanBanLT != 13 &&
                            vbdTTXuLyVanBanLT != 18 &&
                            vbdTTXuLyVanBanLT != 21 &&
                            vbdTTXuLyVanBanLT != 23 &&
                            vbdTTXuLyVanBanLT != 25 &&
                            vbdTTXuLyVanBanLT != 27)
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

            vbdTTXuLyVanBanLT == 16 ||
                    vbdTTXuLyVanBanLT == 15 ||
                    vbdTTXuLyVanBanLT == 14
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

            vbdTTXuLyVanBanLT == 18 ||
                    vbdTTXuLyVanBanLT == 21 ||
                    vbdTTXuLyVanBanLT == 23 ||
                    vbdTTXuLyVanBanLT == 25
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

            //          (LogxulyText != null || LogxulyText.isNotEmpty
            //              && ! LogxulyText.contains("#DYCapNhap#")
            //              && ! LogxulyText.contains("#TCCapNhap#")
            //              && ! LogxulyText.contains("#TCThayThe#")
            //              && ! LogxulyText.contains("#DYThayThe#")
            //              && ! LogxulyText.contains("#DYThuHoi#")
            //              && ! LogxulyText.contains("#TCThuHoi#")
            //              && ! LogxulyText.contains("#DYLayLai#"))
            //              || LogxulyText.isEmpty
            //              ?Container(
            // child: Column(
            //  children: [
            //    vbDen.ID>0 &&  vbdPhuongThuc!=2
            //        && ((vbdTTXuLyVanBanLT==26
            //        // && vanbandenCapNhatID > 0
            //    )
            //        ||vbdTTXuLyVanBanLT == 22
            //        || vbdTTXuLyVanBanLT==17
            //        ||vbdTTXuLyVanBanLT==24
            //        || vbdTTXuLyVanBanLT== 28
            //        || vbdTTXuLyVanBanLT == 20)?
            //    Column(children: [
            //      vbdTTXuLyVanBanLT==17 || vbdTTXuLyVanBanLT==24
            //          || vbdTTXuLyVanBanLT==28 ||
            //          vbdTTXuLyVanBanLT==17 ?
            //      Column(children: [
            //        Row(
            //          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //          children: [
            //            Container(
            //              width: MediaQuery.of(context).size.width * 0.4,
            //              padding: EdgeInsets.only(left: 20.0),
            //              child: Text(
            //                'Văn bản đến qua mạng',
            //                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            //              ),
            //            ),
            //            vbDen.ID>0 && vbdTTXuLyVanBanLT==26 &&
            //                vbdPhuongThuc != 2
            //                //&& vanbandenCapNhat.ID > 0
            //                ? Container(
            //                width: MediaQuery.of(context).size.width * 0.6,
            //                padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
            //                child:Row(
            //                  children: [
            //                    Expanded(
            //                      child: Text(
            //                        "Trạng thái: Cập nhật văn bản; Chờ cập nhật cho văn bản",
            //                        style: TextStyle(fontWeight: FontWeight.normal,
            //                            fontSize: 14,color: Colors.red),
            //                        // overflow: TextOverflow.ellipsis,
            //                        textAlign: TextAlign.start,
            //
            //                      ),
            //                    ),
            //                    Text(
            //                      vbDen.SoKyHieu,
            //                      style: TextStyle(fontWeight: FontWeight.normal,
            //                          fontSize: 14,color: Colors.blue),
            //                      // overflow: TextOverflow.ellipsis,
            //                      textAlign: TextAlign.start,
            //
            //                    )
            //
            //
            //                  ],)
            //            ):SizedBox(),
            //
            //            vbDen.ID>0 && (vbdTTXuLyVanBanLT==28)
            //                && vbdPhuongThuc != 2
            //            ? Container(
            //                width: MediaQuery.of(context).size.width * 0.6,
            //                padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
            //
            //
            //                child:Row(
            //                  children: [
            //                    Expanded(
            //                      child: Text(
            //                        "Trạng thái: Thu hồi văn bản; Đang chờ thu hồi văn bản",
            //                        style: TextStyle(fontWeight: FontWeight.normal,
            //                            fontSize: 14,color: Colors.red),
            //                        // overflow: TextOverflow.ellipsis,
            //                        textAlign: TextAlign.start,
            //
            //                      ),
            //                    ),
            //                    Text(
            //                      vbDen.SoKyHieu,
            //                      style: TextStyle(fontWeight: FontWeight.normal,
            //                          fontSize: 14,color: Colors.blue),
            //                      // overflow: TextOverflow.ellipsis,
            //                      textAlign: TextAlign.start,
            //
            //                    )
            //
            //
            //                  ],)
            //            ):SizedBox(),
            //
            //
            //            vbDen.ID>0 && (vbdTTXuLyVanBanLT==22) && vbdPhuongThuc != 2
            //                ? Container(
            //                width: MediaQuery.of(context).size.width * 0.6,
            //                padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
            //
            //
            //                child:Row(
            //                  children: [
            //                    Expanded(
            //                      child: Text(
            //                        "Trạng thái: Thu hồi văn bản; Văn bản thu hồi",
            //                        style: TextStyle(fontWeight: FontWeight.normal,
            //                            fontSize: 14,color: Colors.red),
            //                        // overflow: TextOverflow.ellipsis,
            //                        textAlign: TextAlign.start,
            //
            //                      ),
            //                    ),
            //                    Text(
            //                      vbDen.SoKyHieu,
            //                      style: TextStyle(fontWeight: FontWeight.normal,
            //                          fontSize: 14,color: Colors.blue),
            //                      // overflow: TextOverflow.ellipsis,
            //                      textAlign: TextAlign.start,
            //
            //                    )
            //
            //
            //                  ],)
            //            ):SizedBox(),
            //
            //            vbDen.ID>0 &&  vbdTTXuLyVanBanLT==17 && vbdPhuongThuc != 2
            //                ? Container(
            //                width: MediaQuery.of(context).size.width * 0.6,
            //                padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
            //
            //
            //                child:Row(
            //                  children: [
            //                    Expanded(
            //                      child: Text(
            //                        "Trạng thái:Thay thế văn bản; Chờ thay thế văn bản",
            //                        style: TextStyle(fontWeight: FontWeight.normal,
            //                            fontSize: 14,color: Colors.red),
            //                        // overflow: TextOverflow.ellipsis,
            //                        textAlign: TextAlign.start,
            //
            //                      ),
            //                    ),
            //                    Text(
            //                      vbDen.SoKyHieu,
            //                      style: TextStyle(fontWeight: FontWeight.normal,
            //                          fontSize: 14,color: Colors.blue),
            //                      // overflow: TextOverflow.ellipsis,
            //                      textAlign: TextAlign.start,
            //
            //                    )
            //
            //
            //                  ],)
            //            ):SizedBox(),
            //
            //            vbDen.ID>0  && vbdTTXuLyVanBanLT==20 && vbdPhuongThuc != 2
            //                ? Container(
            //                width: MediaQuery.of(context).size.width * 0.6,
            //                padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
            //                child:Row(
            //                  children: [
            //                    Expanded(
            //                      child: Text(
            //                        "Trạng thái: Thay thế văn bản; Văn bản thay thế",
            //                        style: TextStyle(fontWeight: FontWeight.normal,
            //                            fontSize: 14,color: Colors.red),
            //                        // overflow: TextOverflow.ellipsis,
            //                        textAlign: TextAlign.start,
            //
            //                      ),
            //                    ),
            //                    Text(
            //                      vbDen.SoKyHieu,
            //                      style: TextStyle(fontWeight: FontWeight.normal,
            //                          fontSize: 14,color: Colors.blue),
            //                      // overflow: TextOverflow.ellipsis,
            //                      textAlign: TextAlign.start,
            //
            //                    )
            //
            //
            //                  ],)
            //            ):SizedBox(),
            //
            //            vbDen.ID>0  && vbdTTXuLyVanBanLT==24 && vbdPhuongThuc !=2
            //                ? Container(
            //                width: MediaQuery.of(context).size.width * 0.6,
            //                padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
            //                child:Row(
            //                  children: [
            //                    Expanded(
            //                      child: Text(
            //                        "Trạng thái: Chờ lấy lại",
            //                        style: TextStyle(fontWeight: FontWeight.normal,
            //                            fontSize: 14,color: Colors.red),
            //                        // overflow: TextOverflow.ellipsis,
            //                        textAlign: TextAlign.start,
            //
            //                      ),
            //                    ),
            //                    Text(
            //                      vbDen.SoKyHieu,
            //                      style: TextStyle(fontWeight: FontWeight.normal,
            //                          fontSize: 14,color: Colors.blue),
            //                      // overflow: TextOverflow.ellipsis,
            //                      textAlign: TextAlign.start,
            //
            //                    )
            //
            //
            //                  ],)
            //            ):SizedBox(),
            //
            //
            //
            //
            //          ],
            //        ),
            //
            //        Divider(),
            //      ],): SizedBox(),
            //
            //    ], ):SizedBox(),
            //  ],
            //  )
            //
            //          ):SizedBox(),

            // ((LogxulyText.isNotEmpty||  LogxulyText != null)
            //     && (LogxulyText.contains("#DYCapNhap#")|| LogxulyText.contains
            //       ("#DYThayThe#")
            //         ||( LogxulyText.contains("#DYThuHoi#") && vbdTTXuLyVanBanLT==28)
            //         || LogxulyText.contains("#DYLayLai#"))) ?
            //
            //           Column(children: [
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Container(
            //                   width: MediaQuery.of(context).size.width * 0.4,
            //                   padding: EdgeInsets.only(left: 20.0),
            //                   child: Text(
            //                     'Văn bản đến qua mạng',
            //                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            //                   ),
            //                 ),
            //                 (LogxulyText.isNotEmpty || LogxulyText != null &&
            // LogxulyText.contains("#DYCapNhap#"))
            //                     || (ID>0 && vbdTTXuLyVanBanLT==26 && vbdPhuongThuc != 2
            //                     //&& vanbandenCapNhat.ID > 0
            //                 ) ? Container(
            //                     width: MediaQuery.of(context).size.width * 0.6,
            //                     padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
            //
            //
            //                     child:Row(
            //                       children: [
            //                         Expanded(
            //                           child: Text(
            //                             "Trạng thái: Đồng ý cập nhật văn bản",
            //                             style: TextStyle(fontWeight: FontWeight.normal,
            //                                 fontSize: 14,color: Colors.red),
            //                             // overflow: TextOverflow.ellipsis,
            //                             textAlign: TextAlign.start,
            //
            //                           ),
            //                         ),
            //                         Text(
            //                           vbDen.SoKyHieu,
            //                           style: TextStyle(fontWeight: FontWeight.normal,
            //                               fontSize: 14,color: Colors.blue),
            //                           // overflow: TextOverflow.ellipsis,
            //                           textAlign: TextAlign.start,
            //
            //                         )
            //
            //
            //                       ],)
            //                 ):SizedBox(),
            //
            //                 vbDen.ID>0 && (vbdTTXuLyVanBanLT==28) && vbdPhuongThuc !=
            //                     2? Container(
            //                     width: MediaQuery.of(context).size.width * 0.6,
            //                     padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
            //
            //
            //                     child:Row(
            //                       children: [
            //                         Expanded(
            //                           child: Text(
            //                             "Trạng thái: Đồng ý thu hồi văn bản",
            //                             style: TextStyle(fontWeight: FontWeight.normal,
            //                                 fontSize: 14,color: Colors.red),
            //                             // overflow: TextOverflow.ellipsis,
            //                             textAlign: TextAlign.start,
            //
            //                           ),
            //                         ),
            //                         Text(
            //                           vbDen.SoKyHieu,
            //                           style: TextStyle(fontWeight: FontWeight.normal,
            //                               fontSize: 14,color: Colors.blue),
            //                           // overflow: TextOverflow.ellipsis,
            //                           textAlign: TextAlign.start,
            //
            //                         )
            //
            //
            //                       ],)
            //                 ):SizedBox(),
            //
            //
            //                 vbDen.ID>0&& vbdTTXuLyVanBanLT==17 && vbdPhuongThuc != 2
            //                     ? Container(
            //                     width: MediaQuery.of(context).size.width * 0.6,
            //                     padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
            //
            //
            //                     child:Row(
            //                       children: [
            //                         Expanded(
            //                           child: Text(
            //                             "Trạng thái: Đồng ý thay thế văn bản",
            //                             style: TextStyle(fontWeight: FontWeight.normal,
            //                                 fontSize: 14,color: Colors.red),
            //                             // overflow: TextOverflow.ellipsis,
            //                             textAlign: TextAlign.start,
            //
            //                           ),
            //                         ),
            //                         Text(
            //                           vbDen.SoKyHieu,
            //                           style: TextStyle(fontWeight: FontWeight.normal,
            //                               fontSize: 14,color: Colors.blue),
            //                           // overflow: TextOverflow.ellipsis,
            //                           textAlign: TextAlign.start,
            //
            //                         )
            //
            //
            //                       ],)
            //                 ):SizedBox(),
            //
            //                 vbDen.ID>0 && vbdTTXuLyVanBanLT==20 && vbdPhuongThuc != 2
            //                     ? Container(
            //                     width: MediaQuery.of(context).size.width * 0.6,
            //                     padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
            //                     child:Row(
            //                       children: [
            //                         Expanded(
            //                           child: Text(
            //                             "Trạng thái: Đồng ý thay thế văn bản",
            //                             style: TextStyle(fontWeight: FontWeight.normal,
            //                                 fontSize: 14,color: Colors.red),
            //                             // overflow: TextOverflow.ellipsis,
            //                             textAlign: TextAlign.start,
            //
            //                           ),
            //                         ),
            //                         Text(
            //                           vbDen.SoKyHieu,
            //                           style: TextStyle(fontWeight: FontWeight.normal,
            //                               fontSize: 14,color: Colors.blue),
            //                           // overflow: TextOverflow.ellipsis,
            //                           textAlign: TextAlign.start,
            //
            //                         )
            //
            //
            //                       ],)
            //                 ):SizedBox(),
            //
            //                 vbDen.ID>0 && vbdTTXuLyVanBanLT==24 && vbdPhuongThuc !=2 ? Container(
            //                     width: MediaQuery.of(context).size.width * 0.6,
            //                     padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
            //                     child:Row(
            //                       children: [
            //                         Expanded(
            //                           child: Text(
            //                             "Trạng thái: Đồng ý lấy lại văn bản",
            //                             style: TextStyle(fontWeight: FontWeight.normal,
            //                                 fontSize: 14,color: Colors.red),
            //                             // overflow: TextOverflow.ellipsis,
            //                             textAlign: TextAlign.start,
            //
            //                           ),
            //                         ),
            //                         Text(
            //                           vbDen.SoKyHieu,
            //                           style: TextStyle(fontWeight: FontWeight.normal,
            //                               fontSize: 14,color: Colors.blue),
            //                           // overflow: TextOverflow.ellipsis,
            //                           textAlign: TextAlign.start,
            //
            //                         )
            //
            //
            //                       ],)
            //                 ):SizedBox(),
            //
            //               ],
            //             ),
            //
            //             Divider(),
            //           ],):SizedBox()
            //         ,
            //
            //   (LogxulyText != null || LogxulyText.isNotEmpty
            //       && ( LogxulyText.contains("#TCCapNhap#")
            //       || LogxulyText.contains("#TCThayThe#") || LogxulyText.contains
            //         ("#TCThuHoi#")))
            //               ?Column(children: [
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Container(
            //                   width: MediaQuery.of(context).size.width * 0.4,
            //                   padding: EdgeInsets.only(left: 20.0),
            //                   child: Text(
            //                     'Văn bản đến qua mạng',
            //                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            //                   ),
            //                 ),
            //                 (LogxulyText != null || LogxulyText.isNotEmpty&&
            //                     LogxulyText.contains("#TCCapNhap#")) || (ID>0 &&
            //                     vbdTTXuLyVanBanLT==29 && vbdPhuongThuc != 2
            //                     //&& vanbandenCapNhat.ID > 0
            //                 )? Container(
            //                     width: MediaQuery.of(context).size.width * 0.6,
            //                     padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
            //
            //
            //                     child:Row(
            //                       children: [
            //                         Expanded(
            //                           child: Text(
            //                             "Trạng thái: Từ chối cập nhật văn bản",
            //                             style: TextStyle(fontWeight: FontWeight.normal,
            //                                 fontSize: 14,color: Colors.red),
            //                             // overflow: TextOverflow.ellipsis,
            //                             textAlign: TextAlign.start,
            //
            //                           ),
            //                         ),
            //                         Text(
            //                           vbDen.SoKyHieu,
            //                           style: TextStyle(fontWeight: FontWeight.normal,
            //                               fontSize: 14,color: Colors.blue),
            //                           // overflow: TextOverflow.ellipsis,
            //                           textAlign: TextAlign.start,
            //
            //                         )
            //
            //
            //                       ],)
            //                 ):SizedBox(),
            //
            //                 vbDen.ID>0 && (vbdTTXuLyVanBanLT==15) && vbdPhuongThuc !=
            //                     2? Container(
            //                     width: MediaQuery.of(context).size.width * 0.6,
            //                     padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
            //                     child:Row(
            //                       children: [
            //                         Expanded(
            //                           child: Text(
            //                             "Trạng thái: Từ chối thu hồi văn bản",
            //                             style: TextStyle(fontWeight: FontWeight.normal,
            //                                 fontSize: 14,color: Colors.red),
            //                             // overflow: TextOverflow.ellipsis,
            //                             textAlign: TextAlign.start,
            //
            //                           ),
            //                         ),
            //                         Text(
            //                           vbDen.SoKyHieu,
            //                           style: TextStyle(fontWeight: FontWeight.normal,
            //                               fontSize: 14,color: Colors.blue),
            //                           // overflow: TextOverflow.ellipsis,
            //                           textAlign: TextAlign.start,
            //
            //                         )
            //
            //
            //                       ],)
            //                 ):SizedBox(),
            //
            //                 vbDen.ID>0  && vbdTTXuLyVanBanLT==16 && vbdPhuongThuc != 2? Container(
            //                     width: MediaQuery.of(context).size.width * 0.6,
            //                     padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
            //                     child:Row(
            //                       children: [
            //                         Expanded(
            //                           child: Text(
            //                             "Trạng thái: Từ chối thay thế văn bản",
            //                             style: TextStyle(fontWeight: FontWeight.normal,
            //                                 fontSize: 14,color: Colors.red),
            //                             // overflow: TextOverflow.ellipsis,
            //                             textAlign: TextAlign.start,
            //
            //                           ),
            //                         ),
            //                         Text(
            //                           vbDen.SoKyHieu,
            //                           style: TextStyle(fontWeight: FontWeight.normal,
            //                               fontSize: 14,color: Colors.blue),
            //                           // overflow: TextOverflow.ellipsis,
            //                           textAlign: TextAlign.start,
            //
            //                         )
            //
            //
            //                       ],)
            //                 ):SizedBox(),
            //
            //                 vbDen.ID>0  && vbdTTXuLyVanBanLT==14 && vbdPhuongThuc !=2? Container(
            //                     width: MediaQuery.of(context).size.width * 0.6,
            //                     padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
            //                     child:Row(
            //                       children: [
            //                         Expanded(
            //                           child: Text(
            //                             "Trạng thái: Từ chối lấy lại văn bản",
            //                             style: TextStyle(fontWeight: FontWeight.normal,
            //                                 fontSize: 14,color: Colors.red),
            //                             // overflow: TextOverflow.ellipsis,
            //                             textAlign: TextAlign.start,
            //
            //                           ),
            //                         ),
            //                         Text(
            //                           vbDen.SoKyHieu,
            //                           style: TextStyle(fontWeight: FontWeight.normal,
            //                               fontSize: 14,color: Colors.blue),
            //                           // overflow: TextOverflow.ellipsis,
            //                           textAlign: TextAlign.start,
            //
            //                         )
            //
            //
            //                       ],)
            //                 ):SizedBox(),
            //
            //
            //               ],
            //             ),
            //
            //
            //             Divider(),
            //           ],): SizedBox(),

            vbDen.ID > 0 &&
                        ((vbdTTXuLyVanBanLT == 26 &&
                                vanbandenCapNhat != null) ||
                            vbdTTXuLyVanBanLT == 17 ||
                            vbdTTXuLyVanBanLT == 24 ||
                            vbdTTXuLyVanBanLT ==
                                28 /*|| vbdTTXuLyVanBanLT==20*/) &&
                        (LogxulyText.isNotEmpty ||
                            LogxulyText != null &&
                                !LogxulyText.contains("#DYCapNhap#") &&
                                !LogxulyText.contains("#TCCapNhap#") &&
                                !LogxulyText.contains("#TCThayThe#") &&
                                !LogxulyText.contains("#DYThuHoi#") &&
                                !LogxulyText.contains("#TCThuHoi#") &&
                                !LogxulyText.contains("#DYLayLai#")) ||
                    LogxulyText.isEmpty ||
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
                : SizedBox(),

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
        yKienitems == null || yKienitems.length == 0
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
