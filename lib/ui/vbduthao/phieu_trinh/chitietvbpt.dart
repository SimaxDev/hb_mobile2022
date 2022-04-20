import 'dart:async';
import 'dart:developer';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hb_mobile2021/core/services/DataControllerGetxx.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hb_mobile2021/core/services/VBDuThaoService.dart';

class ThongTinPhieuTrinh extends StatefulWidget {
  ThongTinPhieuTrinh({Key key, this.idPhieuTrinh, this.nam,this.duThaoPT})
      : super(key: key);
  final int idPhieuTrinh;
  String nam;
  final duThaoPT;


  @override
  _ThongTinVBDT createState() => _ThongTinVBDT();
}

class _ThongTinVBDT extends State<ThongTinPhieuTrinh> {
//  List duthaoList = [];
  var duThao;

  bool isLoading = false;
  List<dynamic> yKienitems;
  List<Widget> lstYKien = new List<Widget>();

  String mesDuThao = "";
  String tenDsYKien="";



  @override
  void initState() {

    super.initState();
    duThao =  widget.duThaoPT;
     isLoading = true;
  }
   @override
   void dispose(){
    super.dispose();

    pdf = "";
   }

  //lấy danh sách chi tiết văn bản dự thảo


//lấy danh sách ý kiến văn bản đến

  //tạo list view
  Widget getBody() {

    var phongchucnang = "" ;
    var vandetrinh =  "" ;
    var nguoitrinh =  "" ;
    var nguoiKy =  "" ;
    var nguoiDuyet =  "" ;
    var tomtatnd =  "";
    var ngaytrinh  =  "" ;
    if(duThao != null){
      
    phongchucnang = duThao['totrinhPhongBan'] != null?
    duThao['totrinhPhongBan']['LookupValue']  : "" ;
    vandetrinh = duThao['Titles'] != null ? duThao['Titles']  : "" ;
    nguoitrinh = duThao['totrinhNguoiTrinh_x003a_Title'] != null ?
    duThao['totrinhNguoiTrinh_x003a_Title']['LookupValue']  : "" ;
    nguoiKy = duThao['totrinhNguoiDuyetCuoi'] != null ?
    duThao['totrinhNguoiDuyetCuoi']['LookupValue']  : "" ;
    nguoiDuyet = duThao['totrinhCurrentNguoiDuyet'] != null ?
    duThao['totrinhCurrentNguoiDuyet']['LookupValue']  : "" ;
    tomtatnd = duThao['totrinhNoiDung'] != null ? duThao['totrinhNoiDung']  : "";
   List pdfPT1 = [];
    pdfPT1  = duThao['ListFileAttach'] != null &&duThao['ListFileAttach']
        .length >0 ? duThao['ListFileAttach'] :[];
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




    ngaytrinh  = DateFormat('dd-MM-yyyy')
        .format(DateFormat('yyyy-MM-dd').parse(duThao['totrinhNgayTrinh'])) != null ? DateFormat('dd-MM-yyyy')
        .format(DateFormat('yyyy-MM-dd').parse(duThao['totrinhNgayTrinh'])) : "" ;
    }

    return (vandetrinh == null || vandetrinh.isEmpty) &&  (tomtatnd == null || tomtatnd.isEmpty)
        ?
    Center(child:Text("Văn bản dự thảo "
        "không kèm "
        "theo phiếu trình",style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
    ))
        :  ListView(
        shrinkWrap: true,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: EdgeInsets.only(left: 22.0),
                    child: Text('Người trình',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    // padding: EdgeInsets.only(left: 22.0),
                    padding: EdgeInsets.fromLTRB(22.0,15, 0, 15),
                    child: Text(nguoitrinh == null   ?  "" :  nguoitrinh,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14
                      ),
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
                    padding: EdgeInsets.only(left: 22.0),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text('Ngày trình',
                      style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(22.0,15, 0, 15),
                    child: Text(ngaytrinh,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal
                      ),
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
                    padding: EdgeInsets.only(left: 22.0),
                    child: Text('Phòng ban',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    // padding: EdgeInsets.only(left: 22.0),
                    padding: EdgeInsets.fromLTRB(22.0,15, 0, 15),
                    child: Text(phongchucnang == null   ?  "" :  phongchucnang,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14
                      ),
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
                    padding: EdgeInsets.only(left: 22.0),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text('Người phê duyệt',
                      style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(22.0,15, 0, 15),
                    child: Text(nguoiDuyet!= null ? nguoiDuyet : "",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal
                      ),
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
                    padding: EdgeInsets.only(left: 22.0),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text('Người ký',
                      style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(22.0,15, 0, 15),
                    child: Text(nguoiKy,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal
                      ),
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
                    padding: EdgeInsets.only(left: 22.0),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text('Vấn đề trình',
                      style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(22.0,15, 0, 15),
                    child: Text(vandetrinh == null ? "" : vandetrinh,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal
                      ),textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
              Divider(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 22.0),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text('Tóm tắt nội dung',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(22.0,15, 0, 15),
                    child: Text(tomtatnd,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14
                      ),textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
              Divider(),


            ],
          ),

        ]
    );
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: isLoading == false
         ? Center(
         child: CircularProgressIndicator(
             valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue)))
         : getBody(),
   );
  }
}

String ttDuthao(id) {
  String tt;
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
