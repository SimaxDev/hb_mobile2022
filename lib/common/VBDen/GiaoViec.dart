import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'dart:async';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hb_mobile2021/common/HoSoCV/linhVucThemMoi.dart';
import 'package:hb_mobile2021/common/VBDen/GiaoViecCN.dart';
import 'package:hb_mobile2021/common/VBDen/GiaoViecPB.dart';
import 'package:hb_mobile2021/core/models/VanBanDenJson.dart';
import 'package:hb_mobile2021/core/services/VbdenService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/core/services/hoSoCVService.dart';

import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';

import 'dart:convert';

import 'package:path/path.dart';




class GiaoViec extends StatefulWidget {
  GiaoViec({Key? key, required this.id,required this.Yearvb,required this.MaDonVi}) ;
  int id;
  final int Yearvb;
  final String MaDonVi;

  @override
  _ThemMoiHSState createState() => _ThemMoiHSState();
}

class _ThemMoiHSState extends State<GiaoViec> {

  DateTime selectedDate =  DateTime.now();
  bool isLoading = false;
  late double _height;
  bool _checkbox = false;
  late double _width;
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
  late File selectedfile;
  List<int> Year = [1,2,3];
  String listLV = "";
   String? SoDen;
   int? dropdownValue ;
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
  List dataCheDoSD = [{"Title":"Khai th??c, tra c???u","ID":"1"},{"Title":"Thu th???p, l??u tr??? ","ID":"2"}];
  List dataLinhVuc = [];
  List dataMucDo = [{"Title":"Th?????ng","ID":"1"},{"Title":"Nhanh","ID":"2"},
    {"Title":"Kh???n c???p","ID":"3"}];
   var idCDSD;
   var idLV;
   var idMD;
  List chua = [];
  String base64PDF = "";
  _onDeleteItemPressed(item) {
    chua.removeAt(item);
    setState(() {});
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


// l???y file t??? ??i???n tho???i
  selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'mp4', 'doc'],
      //allowed extension to choose
    );

    if (result != null) {
      //if there is selected file
      selectedfile = File(result.files.single.path!);

      if (selectedfile != null) {
        // var bytes1 = await rootBundle.load(selectedfile.path);
        List<int> Bytes = await selectedfile.readAsBytesSync();
        print(Bytes);
        base64PDF = await base64Encode(Bytes);
        print("hdaf  " + base64PDF);
        chua.add(basename(selectedfile.path));
      }
    }
    setState(() {});
  }

  // th???i gian b???t ?????u
 _selectDateBD(BuildContext context) async {
   var now = new DateTime.now();
   var formatter = new DateFormat('dd-MM-yyyy').format(now);
   DateTime selectedDateBD = DateFormat('d-M-yyyy').parse(formatter);
    final DateTime? picked = await showDatePicker(
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
    final DateTime? picked = await showDatePicker(
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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: Text('Giao vi???c'),
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
                    child: Text('Nh???ng tr?????ng c?? d???u (*) l?? tr?????ng b???t bu???c ph???i nh???p.(*)',
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
                          'T??n c??ng vi???c(*)',
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
                          'S??? h??? s??',
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
                          'Ch?? gi???i',
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
                          'Th???i gian b???t ?????u(*)',
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
                          padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
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
                          'Th???i gian k???t th??c',
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
                          padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
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
                          'Th???i h???n b???o h??nh',
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
                          'Ng??n ng???',
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
                          'Ch??? ????? s??? d???ng',
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

                            });
                          },
                          hint:Text("Ch???n") ,isExpanded: true,
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
                          'L??nh v???c',
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
                              child: new Text
                                (item['Title']!=null?item['Title']:"" ),
                              value: item['ID'].toString(),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              idLV = newVal;

                            });
                          },
                          hint:Text("Ch???n l??nh v???c") ,
                          isExpanded: true,
                          underline:Container(),
                          style: const TextStyle(color: Colors.black,
                              fontWeight: FontWeight.normal,fontSize: 14),
                          value: idLV,
                        ):Text(
                          "Ch???n l??nh v???c",style: const TextStyle
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
                          'M???c ?????',
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
                          hint:Text("Ch???n") ,isExpanded: true,
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
                          'T???ng s??? v??n b???n',
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
                          'S??? l?????ng t???',
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
                          'S??? l?????ng trang',
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
                          'K?? hi???u th??ng tin',
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
                          'T??nh tr???ng v???t l??',
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
                          'T??? kh??a',
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
                          'C??c t??i li???u li??n quan',
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
                          "T???p ????nh k??m",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 12),
                        width:
                        MediaQuery.of(context).size.width * 0.675,

                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Column(
                          children: [
                            Container(
                              width:
                              MediaQuery.of(context).size.width *
                                  0.5,
                              child: TextButton(
                                child: Text('????nh k??m file...'),
                                // color: Colors.blueAccent,
                                // textColor: Colors.white,
                                onPressed: () {
                                  selectFile();
                                },
                              ),
                            ),
                            chua != null && chua!=[] &&chua.length >0
                                ?  Container
                              (child:
                            ListView
                                .builder(
                              shrinkWrap: true,
                              itemCount: chua.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(chua[index],style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13),
                                    maxLines:2,),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      size: 18.0,
                                      color: Color(0xffDE3E43),
                                    ),
                                    onPressed: () {
                                      _onDeleteItemPressed(index);
                                    },
                                  ),
                                );
                              },
                            ),):
                            Text(
                              "N??n s??? d???ng file pdf",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.blue),
                            ),
                          ],
                        ),
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
                      Text("Giao cho ph??ng ban"),

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
                              "1. Ph??n x??? l?? c?? nh??n",
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
                              "2. Ph??n x??? l?? ph??ng ban",
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
                            label: Text("Ghi nh???n",style: TextStyle
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
                              var tendangnhap = sharedStorage!.getString("username");

                              if(tenCV!= null&& tenCV!= ""&& _dateControllerBD.text!=
                                  null&& _dateControllerBD.text!= "")
                              {


                                if(idCT ==""&&idNTD =="")
                                {
                                  showAlertDialog(context, "Y??u c???u "
                                      "ch???n x??? l??? ");
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
                                    ("ThemMoiHSCV",tendangnhap!,
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


                                }


                                //
                                //  Navigator.of(context).pop();
                              }
                              else
                              {
                                showAlertDialog(context, "Y??u c???u "
                                    "nh???p c??c tr?????ng c???n thi???t(*)");
                              }


                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue[50]!),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                            )
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 10,right: 10,
                          bottom: 10),
                        child:   TextButton.icon (
                          // child: Text("????ng l???i",style: TextStyle(fontWeight: FontWeight.bold),),
                            icon: Icon(Icons.clear),
                            label: Text('Hu???',style: TextStyle
                              (fontWeight: FontWeight.bold)),
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
      ),





    );
  }


}
String trangthai(id){
  String tt ="";
  switch(id){
    case 1:
      tt = "Th?????ng";
      break;
    case 2:
      tt= "Nhanh";
      break;
    case 3:
      tt = "Kh???n c???p";
      break;

  }
  return tt;
}
String tinhtrang(id){
  String tt ="";
  switch(id){
    case 1:
      tt = "Khai th??c, tra c???u";
      break;
    case 2:
      tt= "Thu th???p, l??u tr??? ";
      break;

  }
  return tt;
}
