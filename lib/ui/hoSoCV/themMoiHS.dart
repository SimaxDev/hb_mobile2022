
import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hb_mobile2021/common/HoSoCV/linhVucThemMoi.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/core/services/hoSoCVService.dart';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';
import 'dart:convert';

import 'package:path/path.dart';






class ThemMoiHS extends StatefulWidget {
  ThemMoiHS({Key? key}) : super(key: key);

  @override
  _ThemMoiHSState createState() => _ThemMoiHSState();
}

class _ThemMoiHSState extends State<ThemMoiHS> {
  bool isLoading = false;
  TextEditingController _maHoSo =  new TextEditingController();
  TextEditingController _sohoSo =  new TextEditingController();
  TextEditingController _tenCongViec =  new TextEditingController();
  TextEditingController _thoiHanBH =  new TextEditingController();
  TextEditingController _noiDung =  new TextEditingController();
  TextEditingController _soLuongTo =  new TextEditingController();
  TextEditingController _soLuongTrang =  new TextEditingController();
  TextEditingController _ngonNgu =  new TextEditingController();
  TextEditingController _tuKhoa =  new TextEditingController();
  late File selectedfile;
  List<int> Year = [1,2,3];
  String listLV = "";
   int? dropdownValue ;
  List<int> ListTT = [1,2];
  int dropdownValueTT =1 ;
  List<ListDataLinhVuc> vanbanListLinhVuc = [] ;
  List dataLinhVuc = [];
   String? idLV;
  DateTime selectedDateBD = DateTime.now();
  TextEditingController _dateControllerBD = TextEditingController(); 
  DateTime selectedDateKT = DateTime.now();
  TextEditingController _dateControllerKT = TextEditingController();
  bool XemTT =  false;
  String mucDo = "";
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
    // if (_timer != null) {
    //   _timer.cancel();
    // }

    isLoading = true;
    GetDataLinhVuc();
   // _initializeTimer();
  }


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

  // thời gian bắt đầu
  Future<Null> _selectDateBD(BuildContext context) async {
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

  // thời gian kết thức
  Future<Null> _selectDateKT(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDateKT,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));
    if (picked != null)
      if (mounted) {setState(() {
        selectedDateKT = picked;
        _dateControllerKT.text =  DateFormat('dd-MM-yyyy')
            .format(DateFormat('yyyy-MM-dd').parse(selectedDateKT.toString()));
      });}

  }
  GetDataLinhVuc() async {
    DateTime now = DateTime.now();
    String Yearvb = DateFormat('yyyy').format(now);
    String detailVBDT = await getDataHomeHSCV1("GetLinhVuc",Yearvb);
    if (mounted) {setState(() {
      dataLinhVuc =  json.decode(detailVBDT)['OData'];
      List vanban = [];
      //vanbanListLinhVuc = json.decode(detailVBDT)['OData'];
      vanban = json.decode(detailVBDT)['OData'].cast<Map<String, dynamic>>();
      vanbanListLinhVuc = (vanban).map((e) => ListDataLinhVuc.fromJson(e)).toList();

    });}

  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          title: Text('Thêm mới hồ sơ công việc'),
        ),
        body: ListView(
          children: [
            Column(
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
                          'Mã hồ sơ(*)',
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
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Yêu cầu nhập giá trị cho trường này';
                            }

                          },
                          controller: _maHoSo,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          'Số hồ sơ(*)',
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
                          validator: (value){

                            if(value!.isEmpty){
                              return 'Yêu cầu nhập giá trị cho trường này';
                            }

                          },
                          keyboardType: TextInputType.number,
                          controller: _sohoSo,
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
                        height:MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.64,
                        padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: DropdownButton<int>(

                          hint: Text("Chọn cơ quan"),
                          value: dropdownValue,isExpanded: true,
                          underline:Container(),
                          style: const TextStyle(color: Colors.black,
                              fontWeight: FontWeight.normal,fontSize: 14),

                          onChanged: ( newValue) {
                            if (mounted) {setState(() {
                              dropdownValue = newValue!;
                              if(dropdownValue != null)
                              {
                                mucDo =dropdownValue.toString();
                              }
                            });}

                          },
                          items: Year.map<DropdownMenuItem<int>>((int
                          value) {
                            return DropdownMenuItem<int>(
                                value: value,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Text(trangthai(value)),
                                ));
                          }).toList(),
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
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black38 ,

                          ),
                          borderRadius: BorderRadius.circular(5),


                        ),
                        margin: EdgeInsets.only(right: 20),
                        width: MediaQuery.of(context).size.width * 0.64,
                        ///height: MediaQuery.of(context).size.height * 0.07,
                        padding: EdgeInsets.only(left: 10),
                       // alignment: Alignment.topLeft,
                        child:
                        DropdownButton(
                          items: dataLinhVuc.map((item) {
                            return  DropdownMenuItem(
                              child:
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                child: Text(item['Title']),
                              ),
                              value: item['ID'].toString(),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              idLV = newVal as String;

                            });
                          },
                          hint:Text("Chọn lĩnh vực") ,
                          isExpanded: true,
                          underline:Container(),
                          style: const TextStyle(color: Colors.black,
                              fontWeight: FontWeight.normal,fontSize: 14),
                          value: idLV,
                        ),

                        // child: linhVucHSCV(
                        //   listDataLinhVuc: vanbanListLinhVuc,
                        //   multipleSelection: true,
                        //   // text: Text("Hya"),
                        //   title:"Chọn lĩnh vực",
                        //   // searchHintText: 'Tìm kiếm',
                        //   onSaved: (value) {
                        //
                        //     for( var item in value)
                        //       {
                        //         listLV += item.toString();
                        //       }
                        //
                        //
                        //   },
                        //
                        // ),
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
                          'Tiêu đề hồ sơ(*)',
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
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Yêu cầu nhập giá trị cho trường này';
                            }

                          },
                          controller: _tenCongViec,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          'Nội dung công việc',
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
                        // height:MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.64,
                        padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                        child: TextFormField(
                          controller: _noiDung,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                          minLines: 6, // any number you need (It works as the rows for the textarea)
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
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
                          'Ngày bắt đầu(*)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _selectDateBD(context);
                        },
                        child:Container(
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
                            enabled: false,
                            keyboardType: TextInputType.text,
                            controller: _dateControllerBD== null ?
                            selectedDateBD  as TextEditingController: _dateControllerBD,
                            // onSaved: (val) {
                            //   _setDate1 = val;
                            // },
                            decoration: InputDecoration(
                                disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                // labelText: 'Time',
                                contentPadding: EdgeInsets.only(bottom: 20.0, left: 5)),
                            validator: (value){
                              if(value!.isEmpty){
                                return 'Yêu cầu nhập giá trị cho trường này';
                              }

                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),

                          ),
                        ),),

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
                          'Ngày kết thúc',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _selectDateKT(context);
                        },
                        child:Container(
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
                            enabled: false,
                            keyboardType: TextInputType.text,
                            controller: _dateControllerKT == null ?
                            selectedDateBD as TextEditingController : _dateControllerKT,
                            // onSaved: (val) {
                            //   _setDate1 = val;
                            // },
                            decoration: InputDecoration(
                                disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                // labelText: 'Time',
                                contentPadding: EdgeInsets.only(bottom: 20.0, left: 5)),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),

                          ),
                        ),),

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
                          'Thời hạn bảo quản',
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
                          controller: _thoiHanBH,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          controller: _soLuongTo,
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
                          controller: _soLuongTrang,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: DropdownButton<int>(
                          underline: Container(),
                          value: dropdownValueTT,isExpanded: true,
                          style: const TextStyle(color: Colors.black,
                              fontWeight: FontWeight.normal,fontSize: 14),

                          onChanged: ( newValue) {
                            if (mounted) { setState(() {
                              dropdownValueTT = newValue!;
                            });}

                          },
                          items: ListTT.map<DropdownMenuItem<int>>((int
                          value) {
                            return DropdownMenuItem<int>(
                                value: value,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Text(tinhtrang(value)),
                                ));
                          }).toList(),
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
                          controller: _ngonNgu,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          'Từ khoá',
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
                          controller: _tuKhoa,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.3,
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text(
                          'Xem thông tin?',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      Checkbox(
                          value: XemTT, onChanged: (val){
                        if (mounted) {setState(() {
                          XemTT= val!;
                        });}


                      }),

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
                            .width * 0.28,
                        padding: EdgeInsets.only(left: 15.0,bottom: 20),
                        child: Text(
                          "File đính kèm",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 12),
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Column(children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,

                            child: ElevatedButton(
                              child: Text('Đính kèm file...'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent, // background (button) color
                                foregroundColor: Colors.white,  // foreground (text) color

                              ),
                              onPressed: () {
                                selectFile();
                              },
                            ),
                          ),


                        ],),

                      )
                    ],
                  ),
                  Container(child: ListView.builder(
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
                  ),),



                  SizedBox(height:15,),
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

                              var thanhcong = null;
                              bool isAllSpaces(String input) {
                                String output = input.replaceAll(' ', '');
                                if(output == '') {
                                  return true;
                                }
                                return false;
                              }

                              var tendangnhap = sharedStorage!.getString("username");
                              String iaa =  _maHoSo.text;
                              // .trim();
                              if(isAllSpaces(iaa)||isAllSpaces(_sohoSo.text)
                                  ||isAllSpaces(_sohoSo.text)
                                  ||isAllSpaces(_tenCongViec.text)
                                  ||isAllSpaces(_dateControllerBD.text))
                              {showAlertDialog(context,"Nhập trường bắt buộc"
                                  "(*)");
                              }
                              else
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
                                String base64PDF = "";
                                var ch ;
                                if (selectedfile != null) {
                                  // var bytes1 = await rootBundle.load(selectedfile.path);
                                  List<int> Bytes = await  selectedfile.readAsBytesSync();
                                  print(Bytes);
                                  base64PDF =await  base64Encode(Bytes);
                                  print(base64PDF);
                                }
                                EasyLoading.show();
                                DateTime now = DateTime.now();
                                String Yearvb = DateFormat('yyyy').format(now);
                                thanhcong=  await
                                postThemHSCV
                                  ("ThemMoiHSCV",_tenCongViec.text,tendangnhap!,Yearvb,
                                    XemTT.toString(),_sohoSo.text,_noiDung.text,_dateControllerBD.text,
                                    _dateControllerKT.text,_maHoSo.text,idLV.toString(),_thoiHanBH.text,
                                    _soLuongTo.text,_soLuongTrang.text,dropdownValueTT.toString(),_ngonNgu.text,
                                    _tuKhoa.text,base64PDF,mucDo);
                                EasyLoading.dismiss();
                                // reloadContacts();

                                Navigator.of(context).pop(true);
                                showAlertDialog(context, json.decode(thanhcong)['Message']);


                                //
                                //  Navigator.of(context).pop();
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
                          // child: Text("Đóng lại",style: TextStyle(fontWeight: FontWeight.bold),),
                            icon: Icon(Icons.clear),
                            label: Text('Đóng lại',style: TextStyle(fontWeight: FontWeight.bold)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            )
                        ),
                      ),

                    ],),
                ],),



              ],
            ),
          ],
        ),

      ),
    );
  }






}
String trangthai(id){
  String tt='' ;
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
  String tt='' ;
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
