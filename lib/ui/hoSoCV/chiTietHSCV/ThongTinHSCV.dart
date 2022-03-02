
import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hb_mobile2021/core/services/VbdenService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/core/services/hoSoCVService.dart';
import 'package:hb_mobile2021/core/models/hoSoCVJson.dart';
import 'package:hb_mobile2021/ui/hoSoCV/cayThongTinHSCV.dart';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hb_mobile2021/core/services/VBDuThaoService.dart';

import '../BottomNavigator.dart';

class thongTinHSCV extends StatefulWidget {
  thongTinHSCV({Key key, this.idHS,this.nam}) : super(key: key);
  final int idHS;
  final String nam;

  @override
  _thongTinHSCV createState() => _thongTinHSCV();
}

class _thongTinHSCV extends State<thongTinHSCV> {

//  List duthaoList = [];
  var hoSoCV = null ;
  bool isLoading = false;
  List<dynamic> yKienitems;
  List<Widget> lstYKien = new List<Widget>();
  String ActionXL = "GetHSCVDetail";
  String ActionXLYKien = "LayDanhSachYKien";
  String mesDuThao= "";
  DateTime _dateTime;
  DateTime selectedDate = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  double _height;
  double _width;
  String titleDrawer = "";
  String idVBDlienQuan="";


  @override
  void initState() {
    super.initState();
    var tendangnhap = sharedStorage.getString("username");
    if((widget.idHS != null || widget.idHS != ""))
    {
      GetDataDetailHSCV(widget.idHS);
      this.GetYkienDataHSCV(widget.idHS);
    }


  }
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text =  DateFormat('dd-MM-yyyy')
            .format(DateFormat('yyyy-MM-dd').parse(selectedDate.toString()));

      });
  }
  //lấy danh sách chi tiết hồ sơ công việc
  GetDataDetailHSCV(int idHS) async {
    String detailVBDT =  await getDataDetailHSCV2( idHS, ActionXL,widget.nam);
    if(mounted){
      setState(() {
        var  hoSoCV1 =  json.decode(detailVBDT)['OData'];
        hoSoCV = hoSoCVJson.fromJson(hoSoCV1);

      });
    }

  }
//lấy danh sách ý kiến hồ sơ công việc
  GetYkienDataHSCV(int idHS) async {

    String data = await getYkienDataHSCV(idHS,ActionXLYKien);
    isLoading = false;
    yKienitems = json.decode(data)['OData'];
    for (var it in yKienitems) {
      lstYKien.add(
          new Row(
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
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                              it['xlcvUserName']['Title'].toString(),


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
                          width: MediaQuery.of(context).size.width * 0.7,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Transform.translate(
                          offset: Offset(0,-10),
                          child: Container(
                              margin: EdgeInsets.only(top: 0, bottom: 10),
                              alignment:Alignment.topLeft,
                              child: Text(it !=  null && it['xlcvThoiGianGui'].toString() != null ? GetDate
                                (it['xlcvThoiGianGui']
                                  .toString() ) : "", style: new TextStyle(
                                  fontSize: 13, color: Colors.black45))),
                        ),

                      ],
                    )


                  ],
                ),
              ),

            ],
          )
      );
      lstYKien.add(new Divider());
    }
  }
  //tạo list view
  Widget getBody() {
    hoSoCVJson hsCV = hoSoCV;
    if( hsCV != null){
      titleDrawer =  hsCV.tenHoSo;
      hscvNguoiPhuTrach =  hsCV.hscvNguoiPhuTrach;
      ChuyenVT = hsCV.ChuyenVT;
      hscvTrangThaiXuLy = hsCV.hscvTrangThaiXuLy;
      hscvNguoiLap = hsCV.hscvNguoiLap;
      checkKetThucHSCV = hsCV.checkKetThucHSCV;
      checkChuyenVaoHS = hsCV.checkChuyenVaoHS;
      strListId =  hsCV.hscvCongViecLienQuan;
      strListVanBanLienQuanID =  hsCV.hscvVanBanDenLienQuan;
      strListVanBanDiLienQuan =  hsCV.hscvVanBanDiLienQuan;

      if(hsCV.hscvVanBanDenLienQuan != null && hsCV.hscvVanBanDenLienQuan.length>0)
      {
        for(var id in hsCV.hscvVanBanDenLienQuan)
        {
          if(!idVBDlienQuan.contains(id['LookupId'].toString())){
            idVBDlienQuan += id['LookupId'].toString()+"," ;
          }

        }


      }
    }


    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return hoSoCV == null || hoSoCV == "" ?  Center(child: CircularProgressIndicator(valueColor: new
    AlwaysStoppedAnimation<Color>(Colors.blue)))
        :ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:  <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text('Tên hồ sơ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    // padding: EdgeInsets.only(left: 22.0),
                    padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                    child: Text(hsCV.tenHoSo,
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
                    padding: EdgeInsets.only(left: 20.0),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text('Mã hồ sơ',
                      style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                    child: Text(hsCV.maHoSo,
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
                    padding: EdgeInsets.only(left: 20.0),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text('Số hồ sơ',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                    child: Text(hsCV.soHoSo.toString(),
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
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text('Thời gian bắt đầu',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                    child: Text(hsCV.thoiGianBD,
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
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text('Thời gian kết thúc',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                    child:
                      Text(hsCV.thoiGianKT,
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
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text('Thời gian bảo quản',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                    child: Text(hsCV.thoiGianBH,
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
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text('Ngôn ngữ',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight:  FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                    child: Text( hsCV.ngonNgu,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14
                      ),
                      textAlign: TextAlign.justify,
                    ),

                  ),


                  //),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text('Chế độ sử dụng',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight:  FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                    child: Text( hsCV.cheDoSD,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14
                      ),
                      textAlign: TextAlign.justify,
                    ),

                  ),


                  //),
                ],
              ),
              Divider(),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text('Lĩnh vực',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight:  FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                    child: Text(hsCV.linhVuc.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14
                      ),
                      textAlign: TextAlign.justify,
                    ),

                  ),


                  //),
                ],
              ),
              Divider(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text('Mức độ',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight:  FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                    child: Text(hsCV.mucDo == null || hsCV.mucDo ==0 ? ""
                        :trangthai
                      (hsCV.mucDo),
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14
                      ),
                      textAlign: TextAlign.justify,
                    ),

                  ),


                  //),
                ],
              ),
              Divider(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text('Tổng số văn bản',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight:  FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                    child: Text( hsCV.tongSoVB.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14
                      ),
                      textAlign: TextAlign.justify,
                    ),

                  ),


                  //),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text('Số Lượng tờ',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight:  FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                    child: Text( hsCV.soLuongTo.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14
                      ),
                      textAlign: TextAlign.justify,
                    ),

                  ),


                  //),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text('Số lượng trang',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight:  FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                    child: Text( hsCV.soLuongTrang.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14
                      ),
                      textAlign: TextAlign.justify,
                    ),

                  ),


                  //),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text('Ký hiệu thông tin',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight:  FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                    child: Text( hsCV.kyHieuTT,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14
                      ),
                      textAlign: TextAlign.justify,
                    ),

                  ),


                  //),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text('Tình trạng vật lý',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight:  FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                    child: Text( hsCV.tinhTrangVL,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14
                      ),
                      textAlign: TextAlign.justify,
                    ),

                  ),


                  //),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text('Từ khóa',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight:  FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                    child: Text( hsCV.tuKhoa,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14
                      ),
                      textAlign: TextAlign.justify,
                    ),

                  ),


                  //),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text('Người lập',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight:  FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                    child: Text( hsCV.nguoiLap,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14
                      ),
                      textAlign: TextAlign.justify,
                    ),

                  ),


                  //),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text('Nội dung',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight:  FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                    child: Text( hsCV.noiDung,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14
                      ),
                      textAlign: TextAlign.justify,
                    ),

                  ),


                  //),
                ],
              ),
              Divider(),
                //
                // ((!boolChuyenSangHSCV) && (itemHosoContainHS != null &&
                //   itemHosoContainHS.Count > 0 ))
    hsCV.hscvCongViecLienQuan  !=""? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text('Thuộc hồ sơ',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight:  FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                    child: Text( hsCV.hscvCongViecLienQuanText,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        color: Colors.blue
                      ),
                      textAlign: TextAlign.justify,
                    ),

                  ),


                  //),
                ],
              ) : SizedBox(),
              Divider(),

            ],
          ),
          yKienitems == null || yKienitems.length == 0 ? SizedBox():
          Column(
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(  'Danh sách xin ý kiến',
                  style: TextStyle( fontSize: 12, fontStyle: FontStyle.italic,color: Colors.blue),
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
        ]
    ) ;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Chi tiết hồ sơ công việc"),
       ),
      body: isLoading ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue))) :  getBody(),
      bottomNavigationBar: BottomNavHSCV(id  : widget.idHS),
      drawer:new Drawer(
        child: new ListView(
          children: <Widget>[
            Container(
              color: Colors.white12,
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height / 8,
              child: DrawerHeader(
                  child: Container(
                    child: Text(
                      "Thông tin chi tiết",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  )),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              child: cayThongTinHSCV(title: titleDrawer,idHS:widget.idHS,
                  idVBDlienQuan:idVBDlienQuan),
            )
          ],
        ),
      ),
    );
  }
}


String ttDuthao(id){
  String tt ;
  switch(id){
    case 0:
      tt = "Đã thu hồi";
      break;
    case 1:
      tt = "Đã chuyển phát hành";
      break;
    case 2:
      tt= "Đang soạn thảo/Xin ý kiến";
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
String trangthai(id){
  String tt ;
  switch(id){
    case 1:
      tt = "Thường";
      break;
    case 2:
      tt= "Nhanh";
      break;
    case 3:
      tt = "Khẩn cấp";
      break;

  }
  return tt;
}
String GetDate(String strDt){

  // return DateFormat('yyyy-MM-dd  kk:mm')
  //     .format(DateFormat('yyyy-MM-dd kk:mm').parse(strDt));
  var parsedDate = DateTime.parse(strDt);
  return ("${parsedDate.day}/${parsedDate.month}/${parsedDate.year}  "
      "${parsedDate.hour}:${parsedDate.minute}");
}
