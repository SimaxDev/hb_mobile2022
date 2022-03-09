import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hb_mobile2021/common/ChuVuUser.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:hb_mobile2021/core/models/UserJson.dart';
import 'package:hb_mobile2021/core/services/UserService.dart';

import 'ThongTinUser.dart';



class EditUser extends StatefulWidget  {
  final gui;
  EditUser({Key key,this.utser, this.gui}) : super(key: key);
  UserJson utser;
  String cls;
  @override
  _EditUserState createState() => _EditUserState(utser);
}

class _EditUserState extends State<EditUser>  {
  final UserJson utser;
  List<String> GioiTinh = ['Nữ', "Nam"];
  var dropdownValue ;
  int gioitinh = 0;
  var idChucVu;
  bool valuesecond = false;
  bool valuesecond1 = false;
  bool isLoading = false;
  _EditUserState(this.utser);
  TextEditingController _controller;
  DateTime _dateTime;
  DateTime selectedDate = DateTime.now();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  double _height;
  double _width;
  String _setDate;
  List<ListData> vanbanList = [];
  FocusNode myFocusNode;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
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
    _initializeTimer();
    super.initState();
    GetDataChucVu();
    myFocusNode = FocusNode();
    _dateController = TextEditingController(text:  widget.utser.NgaySinh);
    _controller = TextEditingController(text: widget.utser.Title);
    _controller.addListener(() {
      final String text = _controller.text.toLowerCase();
      _controller.value = _controller.value.copyWith(
        // text: text,
        selection:
        //TextSelection.fromPosition(TextPosition(offset: _controller.text.length)),
        TextSelection(baseOffset: _controller.text.length, extentOffset: _controller.text.length),
        composing: TextRange.empty,
      );
    });
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }
  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: _dateTime ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;

    setState(() => _dateTime = newDate);
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(DateTime.now().year - 50),
        lastDate: DateTime(DateTime.now().year + 50));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }
  GetDataChucVu() async {
    String tendangnhap = tendangnhapAll;
    String detailChucVu = await getDataChucVu(tendangnhap, "GetAllChucVu");
    setState(() {
      var vanban = json.decode(detailChucVu)['OData'];
      var lstData = (vanban as List).map((e) => ListData.fromJson(e)).toList();
      List<ListData> lstDataSearch = List<ListData>();
      lstData.forEach((element) {
        lstDataSearch.add(element);
        vanbanList = lstDataSearch;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return
      GestureDetector(
        onTap: _handleUserInteraction,
        onPanDown: _handleUserInteraction,
        onScaleStart: _handleUserInteraction,
        child:Scaffold(
      appBar: AppBar(title: Text('Cập nhật thông tin cá nhân'),),
      body:SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(height: 30,),
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
                    'Họ và tên*',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  alignment :Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.6,
                  height:MediaQuery.of(context).size.height * 0.04,
                  margin: EdgeInsets.only(right: 10),
                  child: TextFormField(
                    controller: TextEditingController(text:this.utser.Title),style: TextStyle(fontSize: 14),

                    onChanged: (newValue) => this.utser.Title =  newValue,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.lightBlue)),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                    ),

                  ),
                ),
                // Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: Colors.black38 ,
                //
                //     ),
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   margin: EdgeInsets.only(right: 10),
                //   // child: ConstrainedBox(
                //     constraints: BoxConstraints.tightFor(width: MediaQuery.of(context).size.width * 0.6,height:
                //      MediaQuery.of(context).size.height * 0.04),
                //     child: TextField(
                //       controller: _controller,
                //       style: TextStyle(fontSize: 14,),
                //       decoration: InputDecoration(
                //         contentPadding:
                //         EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                //         border: OutlineInputBorder(),
                //       ),
                //       onChanged: (text){
                //         setState(() {
                //           this.utser.Title = text;
                //         });
                //       },
                //     ),
                //   ),

               // ),
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
                      'Ngày sinh',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black38 ,
                          width: 1 ,
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.605,
                      height: MediaQuery.of(context).size.height * 0.04,
                      child: TextFormField(
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.left,
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: _dateController ,
                        onSaved: (val){
                          setState(() {
                            _setDate =  val;
                          });
                        },
                        decoration: new InputDecoration(
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                          border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.black45),

                          ),
                        ),
                      ),
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
                    'Giới tính*',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),

                Container(

                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black38 ,
                        width: 1 ,
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    width: MediaQuery.of(context).size.width * 0.605,
                    height: MediaQuery.of(context).size.height * 0.04,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child:DropdownButton<String>(
                        value: getTrangThai(widget.utser.GioiTinh) ,
                        style: const TextStyle(
                            color: Colors.black, fontSize: 14),
                        underline: Container(
                          height: 0,
                          color: Colors.white70,
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            dropdownValue = newValue ;
                            if(dropdownValue =="Nam"){
                              gioitinh =  1;
                              widget.utser.GioiTinh = gioitinh;
                            }
                            widget.utser.GioiTinh = gioitinh;
                          });
                        },isExpanded: true,
                        items: GioiTinh.map<DropdownMenuItem<String>>((
                            String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ) ,
                    )

    )
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
                    margin: EdgeInsets.only(right: 10),
                    // decoration: BoxDecoration(
                    //   border: Border.all(
                    //     color: Colors.black38 ,
                    //     width: 2.0 ,
                    //   ),
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                  width: MediaQuery.of(context).size.width * 0.605,
                  height: MediaQuery.of(context).size.height * 0.05,
                    child:
                    ChucVuUser(
                      listData: vanbanList,
                       title: 'Chọn',
                      searchHintText: 'Tìm kiếm',
                        onSaved: (value) {
                          setState(() {
                             idChucVu = value[0] ;
                          });
                        },
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
                    'Địa chỉ Email*',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  alignment :Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.6,
                 height:MediaQuery.of(context).size.height * 0.04,
                  margin: EdgeInsets.only(right: 10),
                  child: TextFormField(
                    controller: TextEditingController(text:this.utser.Email),style: TextStyle(fontSize: 14),

                    onChanged: (newValue) => this.utser.Email =  newValue,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.lightBlue)),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                    ),

                  ),
                ),
                // Container(
                //   alignment: Alignment.center,
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: Colors.black38 ,
                //
                //     ),
                //     borderRadius: BorderRadius.circular(10),
                //
                //   ),
                //   margin: EdgeInsets.only(right: 10),
                //   // child: ConstrainedBox(
                //   //   constraints: BoxConstraints.tightFor(
                //         width: MediaQuery.of(context).size.width * 0.6,
                //         height:MediaQuery.of(context).size.height * 0.04,
                //     //),
                //     child: TextField(
                //       controller: TextEditingController.fromValue(new TextEditingValue
                // (text: this.utser.Email,selection: new TextSelection.collapsed(offset: this.utser.Email.length))),
                //       style: TextStyle(fontSize: 14),
                //       decoration: InputDecoration(
                //
                //         contentPadding:
                //         EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                //         border: OutlineInputBorder(),
                //       ),
                //       onChanged: (text){
                //         setState(() {
                //           this.utser.Email = text;
                //         });
                //       },
                //     ),
                //   ),

               // ),


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
                    'Điện thoại DĐ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  alignment :Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.6,
                  height:MediaQuery.of(context).size.height * 0.04,
                  margin: EdgeInsets.only(right: 10),
                  child: TextFormField(
                    controller: TextEditingController(text:this.utser.SDT),style: TextStyle(fontSize: 14),
                    keyboardType: TextInputType.number,
                    onChanged: (newValue) => this.utser.SDT =  newValue,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.lightBlue)),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                    ),

                  ),
                ),
                // Container(
                //   alignment: Alignment.center,
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: Colors.black38 ,
                //     ),
                //     borderRadius: BorderRadius.circular(10),
                //
                //   ),
                //   margin: EdgeInsets.only(right: 10),
                //   // child: ConstrainedBox(
                //   //   constraints: BoxConstraints.tightFor(
                //       width: MediaQuery.of(context).size.width * 0.6,height:
                //     MediaQuery.of(context).size.height * 0.04,
                //     //),
                //     child: TextField(
                //           controller: TextEditingController.fromValue(new TextEditingValue
                //             (text: this.utser.SDT,selection: new TextSelection.collapsed(offset: this.utser.SDT.length))),
                //       style: TextStyle(fontSize: 14),
                //       decoration: InputDecoration(
                //
                //         contentPadding:
                //         EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                //         border: OutlineInputBorder(),
                //       ),
                //       onChanged: (text){
                //         setState(() {
                //           this.utser.SDT = text;
                //         });
                //       },
                //     ),
                //   ),

               // ),
              ],
            ), SizedBox(height: 5,),
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
                    'Điện thoại nhà riêng',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  alignment :Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.6,
                  height:MediaQuery.of(context).size.height * 0.04,
                  margin: EdgeInsets.only(right: 10),
                  child: TextFormField(
                    controller: TextEditingController(text:this.utser.SDTN),style: TextStyle(fontSize: 14),
                    keyboardType: TextInputType.number,
                    onChanged: (newValue) => this.utser.SDTN =  newValue,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.lightBlue)),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                    ),

                  ),
                ),
                // Container(  margin: EdgeInsets.only(right: 10),
                //   alignment: Alignment.center,
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: Colors.black38 ,
                //
                //     ),
                //     borderRadius: BorderRadius.circular(10),
                //
                //   ),
                //   // child: ConstrainedBox(
                //   //   constraints: BoxConstraints.tightFor(
                //         width: MediaQuery.of(context).size.width * 0.6,height:
                //     MediaQuery.of(context).size.height * 0.04,
                //    // ),
                //     child: TextField(
                //       controller: TextEditingController.fromValue(new TextEditingValue
                //         (text: this.utser.SDTN,selection: new TextSelection.collapsed(offset: this.utser.SDTN.length))),
                //
                //       style: TextStyle(fontSize: 14),
                //       decoration: InputDecoration(
                //         contentPadding:
                //         EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                //         border: OutlineInputBorder(),
                //       ),
                //       onChanged: (text){
                //         setState(() {
                //           this.utser.SDTN = text;
                //         });
                //       },
                //     ),
                //   ),

                //),
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
                    'Địa chỉ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),

                Container(
                  alignment :Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.6,
                  height:MediaQuery.of(context).size.height * 0.04,
                  margin: EdgeInsets.only(right: 10),
                  child: TextFormField(
                    controller: TextEditingController(text:this.utser.DiaChi),style: TextStyle(fontSize: 14),

                    onChanged: (newValue) => this.utser.DiaChi =  newValue,
                    autovalidateMode: AutovalidateMode.onUserInteraction,

                    maxLines: 100,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.lightBlue)),
                      contentPadding:
                      EdgeInsets.only(top: 10,left: 10,right: 10),
                    ),

                  ),
                ),
                // Container( margin: EdgeInsets.only(right: 10),
                //   alignment: Alignment.center,
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: Colors.black38 ,
                //
                //     ),
                //     borderRadius: BorderRadius.circular(10),
                //
                //   ),
                //   child: ConstrainedBox(
                //     constraints: BoxConstraints.tightFor(width: MediaQuery.of(context).size.width * 0.6,height:
                //     MediaQuery.of(context).size.height * 0.04),
                //
                //     child: TextField(
                //       controller: TextEditingController.fromValue(new TextEditingValue
                //         (text: this.utser.DiaChi,selection: new TextSelection.collapsed(offset: this.utser.DiaChi.length))),
                //       style: TextStyle(fontSize: 14),
                //       decoration: InputDecoration(
                //
                //         contentPadding:
                //         EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                //         border: OutlineInputBorder(),
                //       ),
                //       onChanged: (text){
                //         setState(() {
                //           this.utser.DiaChi = text;
                //         });
                //       },
                //     ),
                //   ),
                //
                // ),
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
                    'Nhận email thông báo',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Center(
                  child: Checkbox(
                    value: utser.cbNhanEmail,
                    onChanged: (bool value) {
                      setState(() {
                        utser.cbNhanEmail = value;
                      });
                    },
                  ),
                )

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
                    'Nhận SMS thông báo',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Center(
                  child: Checkbox(
                    value: utser.cbNhanSMS,
                    onChanged: (bool value) {
                      setState(() {
                        utser.cbNhanSMS = value;
                      });
                    },
                  ),
                )

              ],
            ),
            SizedBox(height: 5,),

            SizedBox(height: 20,),

            Container(

                height: 50,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: RaisedButton(
                  color: Colors.blue,
                  shape:  RoundedRectangleBorder(
                      side:new  BorderSide(color: Colors.blue,), //the outline color
                      borderRadius: new BorderRadius.all(new Radius.circular(10))),

                  textColor: Colors.white,
                  child: Text('Cập nhật',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),),
                  onPressed: () async {
                    var thanhcong =  null;
                    String tendangnhap = tendangnhapAll;
                      //update data
                    EasyLoading.show();
                     thanhcong=  await getDataPut(tendangnhap,'EditUser',this.utser.Title,
                        this._dateController.text,
                        this.gioitinh,
                        this.idChucVu,
                        this.utser.Email,
                        this.utser.SDT,
                        this.utser.SDTN,
                        this.utser.DiaChi,
                        this.utser.cbNhanEmail,
                        this.utser.cbNhanSMS,
                      );
                    EasyLoading.dismiss();
                    showAlertDialog(context, messingCN);
                   //showAlertDialog(context, json.decode(thanhcong)['Message']);
                     Navigator.of(context).pop();
                    //  showDialog<String>(
                    //   context: context,
                    //   builder: (BuildContext context) => AlertDialog(
                    //     title: const Text('Thông báo'),
                    //     content: const Text('Bạn cần phải đăng nhập lại!'),
                    //     actions: <Widget>[
                    //       TextButton(
                    //         onPressed: () async {
                    //           logOut(context);
                    //          Navigator.of(context).pop();
                    //         },
                    //         child: const Text('Tiếp tục '),
                    //       ),
                    //       TextButton(
                    //         onPressed: () => Navigator.pop(context),
                    //         child: const Text('Huỷ'),
                    //       ),
                    //     ],
                    //   ),
                    // );
                  // widget.gui();


                  },
                )
            ),
          ],
          //,cbNhanEmail: "",cbNhanSMS: "",Message: "",NgaySinh: "",

        ),
      )



    ),);
  }
  String getTrangThai(int trangthai) {
    switch (trangthai) {
      case 0:
        return "Nữ";
        break;
      case 1:
        return "Nam";
        break;
      default:
        return "Giới tính không xác định";
        break;
    }
  }
}



