
import 'dart:async';
import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hb_mobile2021/common/HoSoCV/linhVucThemMoi.dart';
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
import 'SearchDropdownCQBH.dart';




class SuaVBD extends StatefulWidget {
  SuaVBD({Key key, this.id,this.Yearvb,this.MaDonVi}) ;
  final int id;
  final int Yearvb;
  final String MaDonVi;

  @override
  _ThemMoiHSState createState() => _ThemMoiHSState();
}

class _ThemMoiHSState extends State<SuaVBD> {
  DateTime _dateTime;
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;
  double _height;
  double _width;
  String _setDate;
  TextEditingController _dateController = TextEditingController();
  TextEditingController soDen =  new TextEditingController();
  TextEditingController ngayDen =  new TextEditingController();
  TextEditingController soKH =  new TextEditingController();
  TextEditingController ngayBH =  new TextEditingController();
  TextEditingController trichYeu =  new TextEditingController();
  TextEditingController nguoiKy =  new TextEditingController();
  TextEditingController GhiChu =  new TextEditingController();
  TextEditingController _ngonNgu =  new TextEditingController();
  TextEditingController _tuKhoa =  new TextEditingController();
  File selectedfile;
  List<int> Year = [1,2,3];
  String listLV = "";
  int SoDen =0;
  int dropdownValue ;
  List<int> ListTT = [1,2];
  int dropdownValueTT =1 ;
  List<ListDataLinhVuc> vanbanListLinhVuc = [] ;
  DateTime selectedDateBD = DateTime.now();
  TextEditingController _dateControllerBD = TextEditingController();
  DateTime selectedDateKT = DateTime.now();
  TextEditingController _dateControllerKT = TextEditingController();
  bool XemTT =  false;
  String mucDo = "";
  String ActionXL = "GetVBDByIDMobile";
  var  ttduthao = null ;
  int DOnVI = 0;
  List data = [];
  List dataCQBH = [];
  List dataLVB = [];
  List dataDoMat = [];
  List dataDoKhan= [];
  String idSCV;
  String idLVB;
  String idLVBS;
  String idDoMat;
  String idDoKhan;
  String idCQBH;
  Timer _timer;
  List<ListData> coquanBHlist = [];
  String idCQBHlist = "";
  void _initializeTimer() {
    _timer = Timer.periodic(const Duration(minutes: 35), (_) {
      rester().logOutALL();
      _timer.cancel();
      print('ket thuc');
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
    //  if(getString("username"))

    super.initState();
    _initializeTimer();
    isLoading = true;
    DOnVI =  DonViInSiteID;
    GetDataLinhVuc();
    GetDataSoCV();
    GetDataLVB();
    GetDataDoMat();
    GetDataDoKhan();
    GetDataCQBH();
    VanBanDenJson vbDen = vanbanDen ;
    _dateController =  TextEditingController(text:vbDen.NgayDen);
    _dateControllerBD =  TextEditingController(text:vbDen.NgayBanHanh);

  }
  @override
  void dispose(){
    super.dispose();
    _timer.cancel();
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
      dataLVB=  data2;
      // ttduthao =  VanBanDenJson.fromJson(data);

    }); }

  }

  GetNum(String id) async {
    String detailVBDen =  await GetNuma("GETNUM"
        ,id,widget.Yearvb);
    if (mounted) { setState(() {
      var data5 =  json.decode(detailVBDen)['OData'];
      SoDen =  data5[0]['vbdSoVanBan'];
      // ttduthao =  VanBanDenJson.fromJson(data);

    }); }

  }
  GetDataDoMat() async {
    String detailVBDen =  await APIDoMat("GetTinhChatVanBan"
        ,DOnVI.toString(),widget.Yearvb);
    if (mounted) { setState(() {
      var data3 =  json.decode(detailVBDen)['OData'];
      dataDoMat =  data3;
      // ttduthao =  VanBanDenJson.fromJson(data);

    }); }

  }
  GetDataCQBH() async {
    VanBanDenJson vbDen = vanbanDen;
    String detailVBDen =  await APICQBH("GetCoQuanBanHanh",widget.Yearvb,"");
    if (mounted) { setState(() {
      var data4 =  json.decode(detailVBDen)['OData'];
      dataCQBH =  data4;
      // ttduthao =  VanBanDenJson.fromJson(data);
      var lstData = (data4).map((e) => ListData.fromJson(e)).toList();
      List<ListData> lstDataSearch = List<ListData>();
      lstData.forEach((element) {
        lstDataSearch.add(element);
        coquanBHlist = lstDataSearch;
      });
    }); }

  }

  GetDataDoKhan() async {
    String detailVBDen =  await APIDoKhan("GetTinhChatVanBan"
        ,DOnVI.toString(),widget.Yearvb);
    if (mounted) { setState(() {
      var data3 =  json.decode(detailVBDen)['OData'];
      dataDoKhan =  data3;
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
  Future<Null> _selectDateBD(BuildContext context) async {
    VanBanDenJson vbDen = vanbanDen ;
    String dv1 =  vbDen.NgayBanHanh;
    DateTime dateTime1 = DateFormat('d-M-yyyy').parse(dv1);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateTime1,
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
    VanBanDenJson vbDen = vanbanDen ;
    String dv =  vbDen.NgayDen;
    DateTime dateTime1 = DateFormat('d-M-yyyy').parse(dv);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateTime1,
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
        child:DefaultTabController(length: 2,
          child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context, false),
                ),
                title: Text('Sửa văn bản đến'),
                bottom: TabBar(
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Sửa VB',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13),
                          ),
                        )
                    ),
                    Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Toàn văn',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13),
                          ),
                        )),

                  ],
                ),
              ),
              body:TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  vbDen != null?  ListView(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Column(children: [
                              SizedBox(height: 20,),
                              Container(
                                child: Text('Các trường có dấu * yêu cầu phải nhập',
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
                                      'Sổ công văn(*)',
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
                                    padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                                    child: data != null ? new DropdownButton(
                                      items: data.map((item) {
                                        return new DropdownMenuItem(
                                          child: Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.55,
                                            child: Text(item['Title'],maxLines: 1,),
                                          ),
                                          value: item['ID'].toString(),
                                        );
                                      }).toList(),
                                      onChanged: (newVal) {
                                        setState(() {
                                          idSCV = newVal;
                                          print(newVal);
                                          GetNum(idSCV);
                                        });
                                      },

                                      hint:Text("Chọn sổ công văn") ,
                                      underline:Container(),
                                      style: const TextStyle(color: Colors.black,
                                          fontWeight: FontWeight.normal,fontSize: 14),
                                      value: vbDen.soCongVanID !=null &&  idSCV== null ? vbDen.soCongVanID.toString() : idSCV,
                                    ):  Text(
                                      "Chọn sổ công văn",style: const TextStyle
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
                                      'Loại văn bản(*)',
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
                                    height:MediaQuery.of(context).size.height * 0.045,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.64,
                                    padding: EdgeInsets.fromLTRB(10, 5, 0, 5),

                                    child: dataLVB != null  ?new
                                    DropdownButton(
                                      //value: vbDen.LoaiVanBan,
                                      items: dataLVB.map((item) {

                                        return new DropdownMenuItem(
                                          child: Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.55,
                                            child: Text(item['Title']   ,maxLines: 1,),

                                          ),

                                          value: item['ID'].toString(),
                                        );
                                      }).toList(),
                                      onChanged: (newVal) {
                                        setState(() {
                                          idLVB = newVal;
                                          print(newVal);
                                        });
                                      },
                                      hint:Text("Chọn loại văn bản") ,

                                      underline:Container(),
                                      style: const TextStyle(color: Colors.black,
                                          fontWeight: FontWeight.normal,fontSize: 14),
                                     value: vbDen.LoaiVanBanID != null &&  idLVB == null ? vbDen.LoaiVanBanID.toString() : idLVB,

                                    ):Text(
                                      "Chọn loại văn bản",style: const TextStyle
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
                                      'Số đến(*)',
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
                                      controller: TextEditingController(text:vbDen.SoDen.toString()),
                                      onChanged: (newValue) => vbDen.SoDen = int.parse(newValue) ,
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
                                      'Ngày đến(*)',
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
                                      'Số ký hiệu(*)',
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

                                      controller: TextEditingController(text:vbDen.SoKyHieu),
                                      onChanged: (newValue) => vbDen.SoKyHieu =  newValue,
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
                                      'Ngày BH(*)',
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
                                            controller:_dateControllerBD,
                                            onChanged: (newValue) =>   newValue=vbDen.NgayBanHanh ,
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
                                      'Trích yếu(*)',
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
                                      keyboardType: TextInputType.number,
                                      controller: TextEditingController(text:vbDen.TrichYeu),
                                      onChanged: (newValue) => vbDen.TrichYeu =  newValue,
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
                                      'Cơ quan BH(*)',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                  ),
                                  /*Container(
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
                                    padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                                    child:dataCQBH != null? new DropdownButton(
                                      items: dataCQBH.map((item) {
                                        return new DropdownMenuItem(
                                          child: Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.55,
                                            child: Text(item['Title'],maxLines: 1,),
                                          ),
                                          value: item['ID'].toString(),
                                        );
                                      }).toList(),
                                      onChanged: (newVal) {
                                        setState(() {
                                          idCQBH = newVal;
                                          print(newVal);
                                        });
                                      },
                                      hint:Text("Chọn cơ quan BH") ,
                                      underline:Container(),
                                      style: const TextStyle(color: Colors.black,
                                          fontWeight: FontWeight.normal,fontSize: 14),
                                      value: vbDen.CoQuanBanHanhID != null &&  idCQBH == null ? vbDen.CoQuanBanHanhID.toString() : idCQBH,
                                    ):Text(
                                      "Chọn cơ quan BH",style: const TextStyle (color:
                                    Colors.black54,
                                        fontWeight: FontWeight.normal,fontSize: 14),
                                    ),
                                  ),*/
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.64,
                                    ///height: MediaQuery.of(context).size.height * 0.07,
                                   // padding: EdgeInsets.only(left: 15.0),
                                    margin: EdgeInsets.only(right: 20),
                                    child: SearchServerCQBH(
                                      listData: coquanBHlist,
                                      multipleSelection: false,
                                      // text: Text("Hya"),
                                      title: vbDen.CoQuanBanHanhID != null &&  idCQBH == null ? vbDen.CoQuanBanHanh: "Chọn cơ quan BH ",
                                      // searchHintText: 'Tìm kiếm',
                                      onSaved: (value) {
                                        if (mounted) {setState(() {
                                              idCQBH = (value.toString()) ;
                                              print(value);

                                        });}
                                      },
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
                                      'Người ký(*)',
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
                                    child:Text(vbDen.NguoiKy),
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
                                      'Chức vụ',
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
                                      child: Text(vbDen.ChucVuNK)
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
                                      'Ghi chú',
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

                                      controller: GhiChu,
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
                                      'Độ mật',
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
                                    padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                                    child:dataDoMat != null? new DropdownButton(
                                      items: dataDoMat.map((item) {
                                        return new DropdownMenuItem(
                                          child: Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.55,
                                            child: Text(item['Title']),
                                          ),
                                          value: item['ID'].toString(),
                                        );
                                      }).toList(),
                                      onChanged: (newVal) {
                                        setState(() {
                                          idDoMat = newVal;
                                          print(newVal);
                                        });
                                      },
                                      hint:Text("Chọn ") ,
                                      underline:Container(),
                                      style: const TextStyle(color: Colors.black,
                                          fontWeight: FontWeight.normal,fontSize: 14),
                                      value: idDoMat,
                                    ):Text(
                                      "Chọn",style: const TextStyle (color:
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
                                      'Độ khẩn',
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
                                    padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                                    child:dataDoKhan!= null? new DropdownButton(
                                      items: dataDoKhan.map((item) {
                                        return new DropdownMenuItem(
                                          child: Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.55,
                                            child: Text(item['Title']),
                                          ),
                                          value: item['ID'].toString(),
                                        );
                                      }).toList(),
                                      onChanged: (newVal) {
                                        setState(() {
                                          idDoKhan = newVal;
                                          print(newVal);
                                        });
                                      },
                                      hint:Text("Chọn ") ,
                                      underline:Container(),
                                      style: const TextStyle(color: Colors.black,
                                          fontWeight: FontWeight.normal,fontSize: 14),
                                      value: idDoKhan,
                                    ):Text(
                                      "Chọn",style: const TextStyle (color:
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
                                      'Mã định danh văn bản',
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
                                      child: Text(vbDen.MaDinhDanhVB)
                                  ),
                                ],
                              ),
                              SizedBox(height: 15,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Padding(padding: EdgeInsets.only(left: 10,right: 10,
                                      bottom: 10),
                                    child:   TextButton.icon (
                                        icon: Icon(Icons.send_and_archive),
                                        label: Text("Lưu",style: TextStyle
                                          (fontWeight:
                                        FontWeight.bold),),
                                        onPressed: ()  async {

                                          var thanhcong = null;
                                          bool isAllSpaces(String input) {
                                            String output = input.replaceAll(' ', '');
                                            if(output == '') {
                                              return true;
                                            }
                                            return false;
                                          }
                                          var tendangnhap = sharedStorage.getString("username");

                                          if(_dateController.text != null&& _dateController.text!= ""
                                              &&vbDen.SoKyHieu!= null&& vbDen.SoKyHieu!= ""
                                              && _dateControllerBD.text!= null &&
                                              _dateControllerBD.text!= ""
                                              &&vbDen.TrichYeu!= null && vbDen.TrichYeu!= ""

                                              &&vbDen.NguoiKy!= null&& vbDen
                                              .NguoiKy!= "")
                                            // String iaa =  _maHoSo.text;
                                            // // .trim();
                                            // if(isAllSpaces(iaa)||isAllSpaces(_sohoSo.text)
                                            //     ||isAllSpaces(_sohoSo.text)
                                            //     ||isAllSpaces(_tenCongViec.text)
                                            //     ||isAllSpaces(_dateControllerBD.text))
                                            // {showAlertDialog(context,"Nhập trường bắt buộc"
                                            //     "(*)");
                                            // }
                                            // else
                                              {
                                            Container(
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.only(top: 10, ),
                                              child: CircularProgressIndicator(
                                                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                                              ),
                                            )
                                            ;
                                            //setState(() async {

                                            var ch ;
                                            EasyLoading.show();

                                            if(idSCV == null)
                                            {
                                              idSCV = vbDen.soCongVanID.toString();
                                            }
                                            if(idLVB == null)
                                            {
                                              idLVB = vbDen.LoaiVanBanID.toString();
                                            }
                                            if(idCQBH == null )
                                            {
                                              idCQBH = vbDen.CoQuanBanHanhID.toString() ;
                                            }
                                            if(SoDen == null)
                                            {
                                              SoDen = vbDen.SoDen;
                                            }
                                            if(idDoMat == null)
                                            {
                                              idDoMat = "";
                                            }
                                            if(idDoKhan == null)
                                            {
                                              idDoKhan = "";
                                            }
                                            thanhcong=  await
                                            postSuaVBD
                                              ("UPDATE",widget.id.toString(),tendangnhap,
                                                widget.Yearvb,idSCV,SoDen.toString(),idLVB,
                                                _dateController.text,vbDen
                                                    .SoKyHieu,_dateControllerBD.text,vbDen
                                                    .TrichYeu,idCQBH,GhiChu.text,
                                                idDoKhan, idDoMat,vbDen.NguoiKyID,
                                                vbDen.ChucVuNKID,vbDen.MaDinhDanhVB);
                                            EasyLoading.dismiss();

                                            Navigator.of(context).pop();
                                            showAlertDialog(context, json.decode(thanhcong)['Message']);

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
                                        label: Text('Đóng lại',style: TextStyle(fontWeight: FontWeight.bold)),
                                        onPressed: () {
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
                  ): Container(),
                  ViewPDFVB(),
                ],
              )




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
      tt = "Chưa tạo";
      break;
    case 2:
      tt= "Đã tạo";
      break;

  }
  return tt;
}
