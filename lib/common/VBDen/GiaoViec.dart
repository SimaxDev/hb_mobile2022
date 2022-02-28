
import 'dart:async';
import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hb_mobile2021/common/HoSoCV/linhVucThemMoi.dart';
import 'package:hb_mobile2021/common/VBDen/GiaoViecCN.dart';
import 'package:hb_mobile2021/common/VBDen/GiaoViecPB.dart';
import 'package:hb_mobile2021/common/VBDen/TreeChuyenNhanhVBD.dart';
import 'package:hb_mobile2021/core/models/VanBanDenJson.dart';
import 'package:hb_mobile2021/core/services/VbdenService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/core/services/hoSoCVService.dart';
import 'package:hb_mobile2021/restart.dart';
import 'package:hb_mobile2021/ui/hoSoCV/index.dart';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'package:hb_mobile2021/ui/main/viewPDF.dart';
import 'dart:convert';

import 'package:path/path.dart';




class GiaoViec extends StatefulWidget {
  GiaoViec({Key key, this.id,this.Yearvb,this.MaDonVi}) ;
  int id;
  final int Yearvb;
  final String MaDonVi;

  @override
  _ThemMoiHSState createState() => _ThemMoiHSState();
}

class _ThemMoiHSState extends State<GiaoViec> {
  DateTime _dateTime;
  DateTime selectedDate =  DateTime.now();
  bool isLoading = false;
  double _height;
  bool _checkbox = false;
  double _width;
  TextEditingController _dateController = TextEditingController();
  TextEditingController tenCV =  new TextEditingController();
  TextEditingController chuGiai =  new TextEditingController();
  TextEditingController thoiHanBaoQuan =  new TextEditingController();
  TextEditingController ngonNgu =  new TextEditingController();
  TextEditingController tongSoVB =  new TextEditingController();
  TextEditingController soLuongTo =  new TextEditingController();
  TextEditingController soLuongTrang =  new TextEditingController();
  TextEditingController kyHieuThongTin =  new TextEditingController();
  TextEditingController tinhTrangVL =  new TextEditingController();
  TextEditingController tuKhoa =  new TextEditingController();
  File selectedfile;
  List<int> Year = [1,2,3];
  String listLV = "";
  String SoDen;
  int dropdownValue ;
  List<int> ListTT = [1,2];
  int dropdownValueTT =1 ;
  List<ListDataLinhVuc> vanbanListLinhVuc = [] ;

  TextEditingController _dateControllerBD = TextEditingController();
  DateTime selectedDateKT = DateTime.now();
  TextEditingController _dateControllerKT = TextEditingController();
  bool XemTT =  false;
  String mucDo = "";
  String ActionXL = "GetVBDByIDMobile";
  var  ttduthao = null ;
  int DOnVI = 0;
  List data = [];
  List dataCheDoSD = [{"Title":"Khai thác, tra cứu","ID":"1"},{"Title":"Thu thập, lưu trữ ","ID":"2"}];
  List dataLinhVuc = [];
  List dataMucDo = [{"Title":"Thường","ID":"1"},{"Title":"Nhanh","ID":"2"},
    {"Title":"Khẩn cấp","ID":"3"}];
  String idCDSD;
  String idLV;
  String idMD;
  Timer _timer;


  void _initializeTimer() {
    _timer = Timer.periodic(const Duration(minutes:5), (_) {
      rester().logOutALL();
      _timer.cancel();
    });

  }

  void _handleUserInteraction([_]) {
    if(_timer != null){
      if (!_timer.isActive) {
        // This means the user has been logged out
        return;}

      _timer.cancel();
    }



    _initializeTimer();
  }


  @override
  void initState() {
    // TODO: implement initState
    //  if(getString("username"))

    super.initState();
    isLoading = true;
    DOnVI =  DonViInSiteID;
    GetDataLinhVuc();
    GetDataSoCV();
    GetDataLVB();
    GetSOhscv();
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy').format(now);
    _dateControllerBD =  TextEditingController(text:formatter) ;

  }
  @override
  void dispose(){
    super.dispose();
    EasyLoading.dismiss();
    idCT;idNTD;idChuTri;idPhoiHop;
    idTheoDoi;
    EasyLoading.dismiss();
  }
  GetDataSoCV() async {
    String detailVBDen =  await getDataSoCV("GetSoCongVan"
        ,DOnVI.toString(),widget.Yearvb);
    if (mounted) { setState(() {
      var data1 =  json.decode(detailVBDen)['OData'];
      data =  data1;

      // ttduthao =  VanBanDenJson.fromJson(data);
      print(ttduthao);
    }); }

  }
  GetDataLVB() async {
    String detailVBDen =  await LVB("GetLoaiVanBan"
        ,DOnVI.toString(),widget.Yearvb);
    if (mounted) { setState(() {
      var data2 =  json.decode(detailVBDen)['OData'];
      dataLinhVuc=  data2;
      // ttduthao =  VanBanDenJson.fromJson(data);

    }); }

  }


  GetNum(String id) async {
    String detailVBDen =  await GetNuma("GETNUM"
        ,id,widget.Yearvb);
    if (mounted) { setState(() {
      var data5 =  json.decode(detailVBDen)['OData'];

      // ttduthao =  VanBanDenJson.fromJson(data);

    }); }

  }
  GetSOhscv() async {
    String detailVBDen =  await GetSoHoSo("GETNUM"
        ,widget.Yearvb);
    if (mounted) { setState(() {
      SoDen =  json.decode(detailVBDen)['OData']['Data'][0]['SoHoSo'];

      // ttduthao =  VanBanDenJson.fromJson(data);

    }); }

  }


// lấy file từ điện thoại
  selectFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'mp4','doc'],
      //allowed extension to choose
    );

    if (result != null) {
      //if there is selected file
      selectedfile = File(result.files.single.path);
    }
  }

  // thời gian bắt đầu
 _selectDateBD(BuildContext context) async {
   var now = new DateTime.now();
   var formatter = new DateFormat('dd-MM-yyyy').format(now);
   DateTime selectedDateBD = DateFormat('d-M-yyyy').parse(formatter);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateBD,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));
    if (picked != null)
      if (mounted) {setState(() {
        selectedDateBD = picked;
        _dateControllerBD.text =  DateFormat('dd-MM-yyyy')
            .format(DateFormat('yyyy-MM-dd').parse(selectedDateBD.toString()));
      });}

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
  GetDataLinhVuc() async {
    String detailVBDT = await getDataHomeHSCV1("GetLinhVuc","");
    if (mounted) {setState(() {
      List vanban = [];
      //vanbanListLinhVuc = json.decode(detailVBDT)['OData'];
      vanban = json.decode(detailVBDT)['OData'].cast<Map<String, dynamic>>();
      vanbanListLinhVuc = (vanban).map((e) => ListDataLinhVuc.fromJson(e)).toList();

    });}

  }



  @override
  Widget build(BuildContext context) {
    VanBanDenJson vbDen = vanbanDen ;
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return GestureDetector(
        onTap: _handleUserInteraction,
        onPanDown: _handleUserInteraction,
        onScaleStart: _handleUserInteraction,
        child:Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            ),
            title: Text('Giao việc'),
          ),
          body:
              ListView(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(children: [
                          SizedBox(height: 20,),
                          Container(
                            child: Text('Những trường có dấu (*) là trường bắt buộc phải nhập.(*)',
                              style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                          SizedBox(height: 20,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.3,
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text(
                                    'Tên công việc(*)',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black38 ,

                                  ),
                                  borderRadius: BorderRadius.circular(5),

                                ),
                                height:MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.64,
                                padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                child: TextFormField(
                                  controller: tenCV,
                                  //onChanged: (newValue) => vbDen.SoDen =
                                  //n.toString(),

                                  // initialValue: vbDen.SoDen!= null??vbDen.SoDen,
                                  autovalidateMode: AutovalidateMode
                                      .onUserInteraction,
                                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                                  decoration: InputDecoration(
                                      disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                      border: InputBorder.none,
                                      // labelText: 'Time',
                                      contentPadding: EdgeInsets.only(bottom: 20.0, left: 5)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.3,
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text(
                                  'Số hồ sơ',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black38 ,

                                  ),
                                  borderRadius: BorderRadius.circular(5),

                                ),
                                height:MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.64,
                                padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                child: TextFormField(
                                  controller: TextEditingController
                                    (text:SoDen == null  ?"0": SoDen
                                      .toString()),
                                  //onChanged: (newValue) => vbDen.SoDen =
                                  //n.toString(),

                                  // initialValue: vbDen.SoDen!= null??vbDen.SoDen,
                                  autovalidateMode: AutovalidateMode
                                      .onUserInteraction,
                                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                                  decoration: InputDecoration(
                                      disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                      border: InputBorder.none,
                                      // labelText: 'Time',
                                      contentPadding: EdgeInsets.only(bottom: 20.0, left: 5)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.3,
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text(
                                  'Chú giải',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black38 ,

                                  ),
                                  borderRadius: BorderRadius.circular(5),

                                ),
                                height:MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.64,
                                padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                child: TextFormField(
                                  controller:chuGiai,
                                  //onChanged: (newValue) => vbDen.SoDen =
                                  //n.toString(),

                                  // initialValue: vbDen.SoDen!= null??vbDen.SoDen,
                                  autovalidateMode: AutovalidateMode
                                      .onUserInteraction,
                                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                                  decoration: InputDecoration(
                                      disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                      border: InputBorder.none,
                                      // labelText: 'Time',
                                      contentPadding: EdgeInsets.only(bottom: 20.0, left: 5)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.3,
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text(
                                  'Thời gian bắt đầu(*)',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(right: 20),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black38 ,

                                    ),
                                    borderRadius: BorderRadius.circular(5),

                                  ),
                                  height:MediaQuery.of(context).size.height * 0.05,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.64,
                                  padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                  child:  InkWell(
                                    onTap: () {
                                      _selectDateBD(context);
                                    },
                                    child: Container(
                                      width: _width / 1.8,
                                      height: _height / 20,
                                      alignment: Alignment.center,
                                      // decoration: BoxDecoration(color: Colors
                                      // .grey[200]),
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 14),
                                        // textAlign: TextAlign.center,
                                        enabled: false,
                                        //  keyboardType: TextInputType.text,
                                        //controller: _dateController == null ? vbDen
                                        // .NgayDen : _dateController,
                                        controller: _dateControllerBD,

                                        decoration: InputDecoration(
                                            disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                            // labelText: 'Time',
                                            contentPadding: EdgeInsets.only(bottom: 15.0)),
                                      ),
                                    ),
                                  )
                              ),

                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.3,
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text(
                                  'Thời gian kết thúc',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(right: 20),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black38 ,

                                    ),
                                    borderRadius: BorderRadius.circular(5),

                                  ),
                                  height:MediaQuery.of(context).size.height * 0.05,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.64,
                                  padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                  child:  InkWell(
                                    onTap: () {
                                      _selectDate(context);
                                    },
                                    child: Container(
                                      width: _width / 1.8,
                                      height: _height / 20,
                                      alignment: Alignment.center,
                                      // decoration: BoxDecoration(color: Colors
                                      // .grey[200]),
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 14),
                                        // textAlign: TextAlign.center,
                                        enabled: false,
                                        //  keyboardType: TextInputType.text,
                                        //controller: _dateController == null ? vbDen
                                        // .NgayDen : _dateController,
                                        controller: _dateController,
                                        decoration: InputDecoration(
                                            disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                            // labelText: 'Time',
                                            contentPadding: EdgeInsets.only(bottom: 15.0)),
                                      ),
                                    ),
                                  )
                              ),

                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.3,
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text(
                                  'Thời hạn bảo hành',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black38 ,

                                  ),
                                  borderRadius: BorderRadius.circular(5),

                                ),
                                height:MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.64,
                                padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                child: TextFormField(

                                  controller: thoiHanBaoQuan,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                                  decoration: InputDecoration(
                                      disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                      // labelText: 'Time',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(bottom: 20.0, left: 5)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.3,
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text(
                                  'Ngôn ngữ',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black38 ,

                                  ),
                                  borderRadius: BorderRadius.circular(5),

                                ),
                                height:MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.64,
                                padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                child: TextFormField(
                                 //keyboardType: TextInputType.number,
                                  controller: ngonNgu,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                                  decoration: InputDecoration(
                                      disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                      // labelText: 'Time',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(bottom: 20.0, left: 5)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.3,
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text(
                                  'Chế độ sử dụng',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black38 ,

                                  ),
                                  borderRadius: BorderRadius.circular(5),


                                ),
                                height:MediaQuery.of(context).size.height * 0.06,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.64,
                                padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                                child:DropdownButton(
                                  items: dataCheDoSD.map((item) {
                                    return new DropdownMenuItem(
                                  child:Text(item['Title'] ),

                                      value: item['ID'].toString(),
                                    );
                                  }).toList(),
                                  onChanged: (newVal) {
                                    setState(() {
                                      idCDSD = newVal;
                                      print("idCDSC "  +idCDSD);
                                    });
                                  },
                                  hint:Text("Chọn") ,isExpanded: true,
                                  underline:Container(),
                                  style: const TextStyle(color: Colors.black,
                                      fontWeight: FontWeight.normal,fontSize: 14),
                                  value: idCDSD,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.3,
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text(
                                  'Lĩnh vực',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black38 ,

                                  ),
                                  borderRadius: BorderRadius.circular(5),


                                ),
                                height:MediaQuery.of(context).size.height * 0.06,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.64,
                                padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                                child:dataLinhVuc != null  ?new
                                DropdownButton(
                                  items: dataLinhVuc.map((item) {
                                    return new DropdownMenuItem(
                                      child: new Text(item['Title'] ),
                                      value: item['ID'].toString(),
                                    );
                                  }).toList(),
                                  onChanged: (newVal) {
                                    setState(() {
                                      idLV = newVal;

                                    });
                                  },
                                  hint:Text("Chọn lĩnh vực") ,
                                  isExpanded: true,
                                  underline:Container(),
                                  style: const TextStyle(color: Colors.black,
                                      fontWeight: FontWeight.normal,fontSize: 14),
                                  value: idLV,
                                ):Text(
                                  "Chọn lĩnh vực",style: const TextStyle
                                  (color:
                                Colors.black54,
                                    fontWeight: FontWeight.normal,fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.3,
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text(
                                  'Mức độ',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black38 ,

                                  ),
                                  borderRadius: BorderRadius.circular(5),


                                ),
                                height:MediaQuery.of(context).size.height * 0.06,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.64,
                                padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                                child:DropdownButton(
                                  items: dataMucDo.map((item) {
                                    return new DropdownMenuItem(
                                      child: new Text(item['Title'], ),
                                      value: item['ID'].toString(),
                                    );
                                  }).toList(),
                                  onChanged: (newVal) {
                                    setState(() {
                                      idMD = newVal;
                                      print("idLinhVuc "  +idMD);
                                    });
                                  },
                                  hint:Text("Chọn") ,isExpanded: true,
                                  underline:Container(),
                                  style: const TextStyle(color: Colors.black,
                                      fontWeight: FontWeight.normal,fontSize: 14),
                                  value: idMD,
                                ),

                              ),
                            ],
                          ),
                          SizedBox(height: 5,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.3,
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text(
                                  'Tổng số văn bản',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black38 ,

                                  ),
                                  borderRadius: BorderRadius.circular(5),

                                ),
                                height:MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.64,
                                padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                child: TextFormField(
                                  //keyboardType: TextInputType.number,
                                  controller: tongSoVB,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                                  decoration: InputDecoration(
                                      disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                      // labelText: 'Time',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(bottom: 20.0, left: 5)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.3,
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text(
                                  'Số lượng tờ',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black38 ,

                                  ),
                                  borderRadius: BorderRadius.circular(5),

                                ),
                                height:MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.64,
                                padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                child: TextFormField(
                                  //keyboardType: TextInputType.number,
                                  controller: soLuongTo,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                                  decoration: InputDecoration(
                                      disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                      // labelText: 'Time',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(bottom: 20.0, left: 5)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.3,
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text(
                                  'Số lượng trang',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black38 ,

                                  ),
                                  borderRadius: BorderRadius.circular(5),

                                ),
                                height:MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.64,
                                padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                child: TextFormField(
                                  //keyboardType: TextInputType.number,
                                  controller: soLuongTrang,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                                  decoration: InputDecoration(
                                      disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                      // labelText: 'Time',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(bottom: 20.0, left: 5)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.3,
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text(
                                  'Ký hiệu thông tin',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black38 ,

                                  ),
                                  borderRadius: BorderRadius.circular(5),

                                ),
                                height:MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.64,
                                padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                child: TextFormField(
                                  //keyboardType: TextInputType.number,
                                  controller: kyHieuThongTin,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                                  decoration: InputDecoration(
                                      disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                      // labelText: 'Time',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(bottom: 20.0, left: 5)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.3,
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text(
                                  'Tình trạng vật lý',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black38 ,

                                  ),
                                  borderRadius: BorderRadius.circular(5),

                                ),
                                height:MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.64,
                                padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                child: TextFormField(
                                  //keyboardType: TextInputType.number,
                                  controller: tinhTrangVL,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                                  decoration: InputDecoration(
                                      disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                      // labelText: 'Time',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(bottom: 20.0, left: 5)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.3,
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text(
                                  'Từ khóa',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black38 ,

                                  ),
                                  borderRadius: BorderRadius.circular(5),

                                ),
                                height:MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.64,
                                padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                child: TextFormField(
                                  //keyboardType: TextInputType.number,
                                  controller: tuKhoa,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                                  decoration: InputDecoration(
                                      disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                      // labelText: 'Time',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(bottom: 20.0, left: 5)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(

                                padding: EdgeInsets.only(left: 15.0),
                                child: Text(
                                  'Các tài liệu liên quan',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),

                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.28,
                                padding: EdgeInsets.only(left: 15.0,bottom: 20),
                                child: Text(
                                  "Tệp đính kèm",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 12),
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),


                                child: Column(children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.5,

                                    child: FlatButton(
                                      child: Text('Đính kèm file...'),
                                      color: Colors.blueAccent,
                                      textColor: Colors.white,
                                      onPressed: () {
                                        selectFile();
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.5,
                                    margin: EdgeInsets.all(10),
                                    //show file name here
                                    child:selectedfile != null?
                                    Text(basename(selectedfile.path)):
                                    Text("",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12,fontStyle: FontStyle.italic,
                                          color: Colors.blue),),
                                    //basename is from path package, to get filename from path
                                    //check if file is selected, if yes then show file name
                                  ),

                                ],),

                              )
                            ],
                          ),

                          Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Checkbox(
                                  value: _checkbox,
                                  onChanged: (value) {
                                    setState(() {
                                      _checkbox = !_checkbox;
                                    });
                                  },
                                ),
                              Text("Giao cho phòng ban"),

                            ],
                          ),         SizedBox(height: 5,),
                          _checkbox == false ? Column(
                         children: [
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Container(

                                 padding: EdgeInsets.only(left: 15.0,bottom: 20),
                                 child: Text(
                                   "1. Phân xử lý cá nhân",
                                   style: TextStyle(fontWeight: FontWeight
                                       .bold, fontSize:16),
                                 ),
                               ),

                             ],
                           ),
                           SizedBox(height: 5,),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Container(

                                // padding: EdgeInsets.only(left: 15.0,bottom:
                          // 20),
                                 child:SingleChildScrollView(
                                   child:GiaoViecCN(id:widget.id,nam:widget.Yearvb),
                                 )
                               ),

                             ],
                           ),
                          ],):SizedBox(),
                          _checkbox == true ? Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(

                                    padding: EdgeInsets.only(left: 15.0,bottom: 20),
                                    child: Text(
                                      "2. Phân xử lý phòng ban",
                                      style: TextStyle(fontWeight: FontWeight
                                          .bold, fontSize:16),
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween,
                                children: [
                                  Container(

                                      padding: EdgeInsets.only(
                                          bottom: 20),
                                      child:SingleChildScrollView(
                                        child:GiaoViecPB(id:widget.id,nam:widget
                                            .Yearvb),
                                      )
                                  ),

                                ],
                              ),
                            ],):SizedBox(),







                          SizedBox(height: 15,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Padding(padding: EdgeInsets.only(left: 10,right: 10,
                                  bottom: 10),
                                child:   TextButton.icon (
                                    icon: Icon(Icons.send_and_archive),
                                    label: Text("Ghi nhận",style: TextStyle
                                      (fontWeight:
                                    FontWeight.bold),),
                                    onPressed: ()  async {
                                      String base64PDF = "";
                                      var ch ;
                                      if (selectedfile != null) {
                                        // var bytes1 = await rootBundle.load(selectedfile.path);
                                        List<int> Bytes = await  selectedfile.readAsBytesSync();
                                        print(Bytes);
                                        base64PDF =await  base64Encode(Bytes);
                                        print(base64PDF);
                                      }
                                      var thanhcong = null;
                                      bool isAllSpaces(String input) {
                                        String output = input.replaceAll(' ', '');
                                        if(output == '') {
                                          return true;
                                        }
                                        return false;
                                      }
                                      var tendangnhap = sharedStorage.getString("username");

                                      if(tenCV!= null&& tenCV!= ""&& _dateControllerBD.text!=
                                          null&& _dateControllerBD.text!= "")
                                          {


                                    if(idCT ==""&&idNTD =="")
                                      {
                                        showAlertDialog(context, "Yêu cầu "
                                            "chọn xử lý? ");
                                      }else{
                                      var ch ;
                                      EasyLoading.show();
                                      if(idMD == null)
                                      { idMD="";

                                      }

                                      if(idLV == null){
                                        idLV="";
                                      }

                                      if(idCDSD == null){
                                        idCDSD="";

                                      }
                                      if(widget.id == null){
                                        widget.id = 0;
                                      }

                                      thanhcong=  await
                                      postGiaoViecVBD
                                        ("ThemMoiHSCV",tendangnhap,
                                          widget.Yearvb,tenCV.text,SoDen
                                              .toString(),
                                          chuGiai.text,_dateControllerBD
                                              .text, _dateController.text,
                                          thoiHanBaoQuan.text,ngonNgu.text,
                                          idCDSD.toString(),idLV.toString()
                                          ,idMD.toString(),tongSoVB.text
                                              .toString(),soLuongTo.text.toString(),
                                          soLuongTrang.text.toString(),
                                          kyHieuThongTin.text,
                                          tinhTrangVL.text,tuKhoa.text,
                                          idCT,idNTD,idChuTri,idPhoiHop,
                                          idTheoDoi,widget.id);
                                      EasyLoading.dismiss();
                                      idCT="";idNTD="";idChuTri="";idPhoiHop="";
                                      idTheoDoi="";
                                      Navigator.of(context).pop();
                                      showAlertDialog(context, json.decode(thanhcong)['Message']);
                                      _timer.cancel();

                                    }


                                        //
                                        //  Navigator.of(context).pop();
                                      }
                                      else
                                      {
                                        showAlertDialog(context, "Yêu cầu "
                                            "nhập các trường cần thiết(*)");
                                      }


                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue[50]),
                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                    )
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10,right: 10,
                                  bottom: 10),
                                child:   TextButton.icon (
                                  // child: Text("Đóng lại",style: TextStyle(fontWeight: FontWeight.bold),),
                                    icon: Icon(Icons.clear),
                                    label: Text('Huỷ',style: TextStyle
                                      (fontWeight: FontWeight.bold)),
                                    onPressed: () {
                                      _timer.cancel();
                                      EasyLoading.dismiss();
                                      Navigator.of(context).pop();
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                    )
                                ),
                              ),

                            ],),SizedBox(height: 15,),

                        ],),



                      ],
                    ),
                  )
                ],
              ),





      ));
  }


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
String tinhtrang(id){
  String tt ;
  switch(id){
    case 1:
      tt = "Khai thác, tra cứu";
      break;
    case 2:
      tt= "Thu thập, lưu trữ ";
      break;

  }
  return tt;
}
