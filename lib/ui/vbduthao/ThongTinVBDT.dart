import 'dart:async';
import 'dart:developer';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hb_mobile2021/core/models/VanBanDuThaoJSon.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hb_mobile2021/core/services/VBDuThaoService.dart';

class ThongTinVBDT extends StatefulWidget {
  ThongTinVBDT({Key? key, required this.idDuThao, required this.nam, required this.MaDonVi,this.ttDuThao})
      : super(key: key);
  final int idDuThao;
  String nam;
  final String MaDonVi;
  final ttDuThao;

  @override
  _ThongTinVBDT createState() => _ThongTinVBDT();
}

class _ThongTinVBDT extends State<ThongTinVBDT> {
//  List duthaoList = [];
  var duThao;

  bool isLoading = false;
  late List<dynamic> yKienitems;
  List<Widget> lstYKien = <Widget>[];
  String ActionXL = "GetVBDTByID";
  String ActionXLYKien = "GetYKien";
  String mesDuThao = "";
  String tenDsYKien="";
  late Timer _timer;


  @override
  void dispose() {

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    duThao =  widget.ttDuThao;

      GetallYKien();
  }

  //lấy danh sách chi tiết văn bản dự thảo


//lấy danh sách ý kiến văn bản đến
  GetallYKien()async{

    if (widget.nam == null) {
      DateTime now = DateTime.now();
      String  nam1 =  DateFormat('yyyy').format(now) ;
      widget.nam = nam1;
    }
    String data = await getYkienDataVBDT(
        widget.idDuThao, ActionXLYKien, widget.nam);
    setState(() {
      isLoading = true;
      yKienitems = json.decode(data)['OData'];
    });
    isLoading = false;

      GetYkienDataVBDT();
  }
  GetYkienDataVBDT() {

    for (var it in yKienitems) {
      lstYKien.add(new Row(
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
                          it['butpheLanhDao_x003a_Title']['Title'].toString(),
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
                        it['Title'].toString(),
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        overflow: TextOverflow.clip,
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
                          alignment: Alignment.topLeft,
                          child: Text(
                              it != null &&
                                      it['butpheTimeCreated'].toString() != null
                                  ? GetDate(it['butpheTimeCreated'].toString())
                                  : "",
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
      lstYKien.add(new Divider());
    }
  }

  //tạo list view
  Widget getBody() {

    VanBanDuThaoJson vbDT = duThao ;


    var trichYeu = "";
    var ldKyVB = "";
    var checkThuHoi1 = false;
    var ngaytrinhky = "";
    var nguoiSoanThao = "";
    var lanhDao2 = "";
    var lanhDao4 = "";
    int trangThaiLD = 0;
    var trangThai = "";
    var donviSoanthao = "";
    var loaiVanban = "";
    var vbdiCurrentDSXuly_x003a_Title = [];
    var   vbdiCurrentDSXuly = [];
    vanbanDT =  duThao;
    if(vbDT != null){
       trichYeu =  vbDT.trichYeu;

       ldKyVB =  vbDT.ldKyVB;

     checkThuHoi1 =  vbDT.checkThuHoi1 ;


     ngaytrinhky =  vbDT.ngaytrinhky;

     nguoiSoanThao =  vbDT.nguoiSoanThao;

   lanhDao2 =
       vbDT.lanhDao2;

    lanhDao4 =  vbDT.lanhDao4;
    trangThaiLD  =  vbDT.trangThaiLD;
     trangThai =  vbDT.trangThai;
    donviSoanthao =  vbDT.donviSoanthao;
     loaiVanban =  vbDT.loaiVanban;
   vbdiCurrentDSXuly_x003a_Title = vbDT.vbdiCurrentDSXuly_x003a_Title;
   vbdiCurrentDSXuly = vbDT.vbdiCurrentDSXuly_x003a_Title;
   if(vbdiCurrentDSXuly_x003a_Title !=null &&vbdiCurrentDSXuly_x003a_Title
       !="" ){
     for( var item  in vbdiCurrentDSXuly_x003a_Title)
     {
       List DsYKien =  [];
       var  ten =  item['LookupValue'];
       tenDsYKien = ten + ",";
     }
     if(tenDsYKien !=  ""){
       tenDsYKien = tenDsYKien.substring(0,tenDsYKien.length-1);
   }



    }
       List pdf1 =[];
       List chuaPDFDK =[];
       pdf1 =  vbDT.pdfDT;

    }

    mesDuThao = mesDT;
    return vbDT == null || vbDT == ""
        ? Center(
            child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue)))
        : ListView(children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Trích yếu',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      // padding: EdgeInsets.only(left: 22.0),
                      padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                      child: Text(
                        loaiVanban == null
                            ? trichYeu
                            : loaiVanban +
                                " -"
                                    " " +
                                trichYeu,
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 14),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 20.0),
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Text(
                        'Ngày trình ký',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                      child: Text(
                        ngaytrinhky,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 20.0),
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Text(
                        'Trạng thái',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                      child: Text(
                        trangThai,
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 14),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Đơn vị soạn/Người soạn',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                      child: Text(
                        donviSoanthao == null
                            ? nguoiSoanThao
                            : donviSoanthao + "/" + nguoiSoanThao,
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 14),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
                Divider(),
                vbdiCurrentDSXuly.length >0? Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(
                          'DS xin ý kiến',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                        child: Text(
                          tenDsYKien,
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 14),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                ],):SizedBox(),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Lãnh đạo ký văn bản',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                      child: Text(
    ldKyVB,
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 14),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
                Divider(),
                vbdiNguoiSoanID == currentUserID
                    && (vbdiTrangThaiVB == 2||vbdiTrangThaiVB == 4)?Column(children: [
                  trangThaiLD == 2
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(
                          'Lãnh đạo đang xử lý',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                        child: Text(
                          lanhDao2+"(Duyệt/cho ý kiến)",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 14),
                          textAlign: TextAlign.justify,
                        ),
                      ),

                      //),
                    ],
                  )
                      : SizedBox(),
                  trangThaiLD == 4
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(
                          'Lãnh đạo đang xử lý',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                        child: Text(
                          lanhDao4+"(Ký/phát hành VB)",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 14),
                          textAlign: TextAlign.justify,
                        ),
                      ),

                      //),
                    ],
                  )
                      : SizedBox(),
                  trangThaiLD != 2 && trangThaiLD != 4
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(
                          'Lãnh đạo đang xử lý',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                        child: Text(
                          "",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 14),
                          textAlign: TextAlign.justify,
                        ),
                      ),

                      //),
                    ],
                  )
                      : SizedBox(),
                  Divider(),
                ]
                  ,):SizedBox(),

              ],
            ),
            lstYKien == null || lstYKien.length == 0
                ? SizedBox()
                : Column(
                    children: [
                      Container(
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
                      Divider(),
                    ],
                  ),
            Container(
              child: Column(
                children: lstYKien,
              ),
            ),
          ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: duThao == null
          ? Center(
          child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue)))
          : getBody(),
    );
  }
}

String ttDuthao(id) {
  String tt='';
  switch (id) {
    case 0:
      tt = "Đã thu hồi";
      break;
    case 1:
      tt = "Đã chuyển phát hành";
      break;
    case 2:
      tt = "Đang soạn thảo/Xin ý kiến";
      break;
    case 3:
      tt = "Đã phê duyệt";
      break;
    case 4:
      tt = "Đang trình ký";
      break;
    case 5:
      tt = "Đã ký";
      break;
    case 6:
      tt = "Đang  làm lại";
      break;
    case 8:
      tt = "Chờ xác nhận thu hồi";
      break;
  }
  return tt;
}

String GetDate(String strDt) {
  // return DateFormat('yyyy-MM-dd  kk:mm')
  //     .format(DateFormat('yyyy-MM-dd kk:mm').parse(strDt));
  var parsedDate = DateTime.parse(strDt);
  return ("${parsedDate.day}/${parsedDate.month}/${parsedDate.year}  "
      "${parsedDate.hour}:${parsedDate.minute}");
}
