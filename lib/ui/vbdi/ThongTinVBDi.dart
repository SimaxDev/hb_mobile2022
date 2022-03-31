import 'dart:async';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:flutter/material.dart';
import 'package:hb_mobile2021/core/models/VanBanDiJson.dart';
import 'package:hb_mobile2021/core/services/VBDiService.dart';
import 'dart:convert';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
class ThongTinVBDi extends StatefulWidget {
  final int id;
  final int nam;
  final String MaDonVi;
  final ttVbanDi;

  ThongTinVBDi({this.id, this.nam,this.MaDonVi,this.ttVbanDi});

  @override
  _ThongTinVBDi createState() => _ThongTinVBDi();
}

class _ThongTinVBDi extends State<ThongTinVBDi> {
  bool isLoading = false;

  // List dataList = [];
  var duthao = null;
  List<dynamic> yKienitems=new List<Widget>();
  List<Widget> listYkien = new List<Widget>();
  String AuthToken;
  List<dynamic> butPheitems = new List<Widget>();
  List<Widget> listButPhe = new List<Widget>();

  String ActionXLYKien = "GetButPhe";
  String donViNhan="";
  String LogxulyText="";
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
    // TODO: implement initState
    _initializeTimer();
    super.initState();
    duthao = widget.ttVbanDi;
    var tendangnhap = sharedStorage.getString("username");
    this.GetYkienDataVBDi(widget.id,tendangnhap);

  }


  @override
  void dispose(){
     super.dispose();
     _timer.cancel();
  }
//lấy danh sách chi tiết văn bản đến

//lấy danh sách ý kiến văn bản đến
  GetYkienDataVBDi(int id,String tendangnhap) async {

    String data = await getYkienDataVBDi(tendangnhap,id,ActionXLYKien,widget
        .nam);

    yKienitems = json.decode(data)['OData'];
    isLoading = false;
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
                        maxLines: 3,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                Column(

                  children: [
                    Transform.translate(
                      offset: Offset(0,-10),
                      child: Container(
                          margin: EdgeInsets.only(top: 0, bottom: 10),
                          alignment:Alignment.center,
                          child: Text(GetDate(it['butpheTimeCreated'].toString()), style: new TextStyle(
                              fontSize: 13, color: Colors.black45))),
                    ),

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




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: _handleUserInteraction,
      onPanDown: _handleUserInteraction,
      onScaleStart: _handleUserInteraction,
      child:Scaffold(
      body: duthao == null
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue)))
          : getBody(),
    ),);
  }

  //UI
  Widget getBody() {
    VanBanDiJson vbdi = duthao;
   if(vbdi  != null){
      vbdiIsSentVanBan =  vbdi.vbdiIsSentVB;
      vbdiCanTDHB =  vbdi.vbdiCanTDHB1;
      vbdiSoKyHieu =  vbdi.SoKyHieu;
      checkThuHoi =  vbdi.checkThuHoi1;
      vbdiPBLookup =  vbdi.vbdiPBLookup;
      LogxulyText =  vbdi.LogxulyText;
      List DonViNhan= [];
      DonViNhan  = vbdi.DonViNhan;
      for(var item in DonViNhan)
      {
       var b= item["LookupValue"];
       donViNhan += b+",";
      }
      if(donViNhan !=  "")
      {
        donViNhan = donViNhan.substring(0,donViNhan.length-1);

      }
      Listpdf = vbdi.pdf1;
      List chuaPDF = [];
      List chuaPDFDK = [];
      for (var i in vbdi.pdf1) {
        if (i['ExtenFile'].contains("pdf")&&i['Name'].contains("signed")) {

          chuaPDF.add(i);
          // pdf2 = i['Url'];
          if(chuaPDF != null && chuaPDF !=[]&& chuaPDF.length >0){
            dynamic max = chuaPDF.first;
            // print(max);
            chuaPDF.forEach((e) {
              if (e['Name'].length > max['Name'].length) max = e;
            });
            pdf = max['Url'];
            namepdf=max['Name'];

          }
        }
        else{
          pdf = i['Url'];
        }

      }
      ListpdfDK = vbdi.pdfDK;
      for (var i in vbdi.pdfDK) {
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

      // pdf =  vbdi.pdf1;
      // namepdf =  vbdi.name;
    }



    return vbdi != null ? ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // LogxulyText.isNotEmpty && LogxulyText.contains("#VBThayThe_")
            //     ? Container(
            //   padding: EdgeInsets.only(left: 20.0,top: 15),
            //   child: Row(
            //     //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       Text(
            //         'Số đi',
            //     style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
            //     textAlign: TextAlign.justify,
            //
            //       ),
            //       InkWell(
            //         onTap: () {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (context) =>ThongTinVBDi() ),);
            //         },
            //         child:Text(
            //           '  Số đi',
            //           style: TextStyle(fontWeight: FontWeight.normal,
            //             fontSize: 14,color: Colors.lightBlueAccent),
            //         ),)
            //
            //
            //     ],
            //   ),
            //
            // ):SizedBox(),
            //   Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Số đi',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  // padding: EdgeInsets.only(left: 22.0),
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbdi.SoDi != null ? vbdi.SoDi: "" ,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
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
                    'Số ký hiệu',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),

                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  // padding: EdgeInsets.only(left: 22.0),
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbdi.SoKyHieu,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
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
                    'Trích yếu',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  // padding: EdgeInsets.only(left: 22.0),
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbdi.TrichYeu,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
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
                    'Loại văn bản',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  // padding: EdgeInsets.only(left: 22.0),
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbdi.LoaiVanBan,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
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
                    'PB soạn thảo',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  // padding: EdgeInsets.only(left: 22.0),
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbdi.PBSoan,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
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
                    'Ngày ban hành',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  // padding: EdgeInsets.only(left: 22.0),
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbdi.NgayBanHanh,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
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
                    'Người ký',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  // padding: EdgeInsets.only(left: 22.0),
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbdi.NguoiKy,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
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
                    'Chức vụ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  // padding: EdgeInsets.only(left: 22.0),
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbdi.ChucVu,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
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
                    'Ngày ký',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  // padding: EdgeInsets.only(left: 22.0),
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbdi.NgayKy,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
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
                    'Người soạn',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  // padding: EdgeInsets.only(left: 22.0),
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbdi.NguoiSoan,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
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
                    'Đơn vị nhận VB',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  // padding: EdgeInsets.only(left: 22.0),
                  //margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    donViNhan.toString(),
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
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
                    'Số bản lưu',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  // padding: EdgeInsets.only(left: 22.0),
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                  vbdi.SoBanLuu,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
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
                    'Độ mật',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  // padding: EdgeInsets.only(left: 22.0),
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbdi.DoMat,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
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
                    'Độ khẩn',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  // padding: EdgeInsets.only(left: 22.0),
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbdi.DoKhan,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
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
                    'Số tờ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  // padding: EdgeInsets.only(left: 22.0),
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbdi.SoTo,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
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
                    'Mã định danh VB',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  // padding: EdgeInsets.only(left: 22.0),
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                   vbdi.MaDinhDanh,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
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
                    'Ghi chú',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  // padding: EdgeInsets.only(left: 22.0),
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: Text(
                    vbdi.GhiChu,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
            Divider(),
          ],
        ),
       listYkien.length==0 || listYkien == null? SizedBox(): Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Text(
            'Danh sách xin ý kiến',
            style: TextStyle( fontSize: 12, fontStyle: FontStyle.italic,color: Colors.blue),
          ),
        ),
         //giải phân cách
        Container(
          child: Column(
            children: listYkien,
          ),
        )
      ],
    ) : Center(
        child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue))
    );
  }
}

String GetDate(String strDt){

  // return DateFormat('yyyy-MM-dd  kk:mm')
  //     .format(DateFormat('yyyy-MM-dd kk:mm').parse(strDt));
  var parsedDate = DateTime.parse(strDt);
  return ("${parsedDate.day}/${parsedDate.month}/${parsedDate.year}  "
      "${parsedDate.hour}:${parsedDate.minute}");
}