import 'dart:async';
import 'dart:convert';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hb_mobile2021/core/services/UserService.dart';
import 'package:hb_mobile2021/core/services/VbdenService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/ui/Login/Login.dart';
import 'package:hb_mobile2021/ui/User/ThongTinUser.dart';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';
import 'package:hb_mobile2021/ui/main/MenuRight.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'package:hb_mobile2021/ui/vbden/BottomNavigator.dart';
import 'package:hb_mobile2021/ui/vbduthao/DuThao.dart';

class themMoiHT extends StatefulWidget {
  String tendangnhap ;
  themMoiHT({Key key, this.tendangnhap}) : super(key: key);

  @override
  _themMoiHTState createState() => _themMoiHTState();
}

class _themMoiHTState extends State<themMoiHT> {

  bool isLoading = false;
  TextEditingController NoiDung =  new TextEditingController();
  TextEditingController email =  new TextEditingController();
  TextEditingController SDT =  new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
   // _initializeTimer();
    super.initState();
  }
  @override
  void dispose(){
    super.dispose();

    NoiDung.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Thêm mới yêu cầu hỗ trợ')),
        body:
        SingleChildScrollView(
          child: Column(
            children: [
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
                      'Nội dung',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),

                  Container(
                    alignment :Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.6,
                    height:MediaQuery.of(context).size.height * 0.2,
                    margin: EdgeInsets.only(right: 10),
                    child: TextFormField(
                      controller: NoiDung,style: TextStyle(fontSize: 14),

                      // onChanged: (newValue) => this.utser.DiaChi =  newValue,
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      maxLines: 100,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors
                              .lightBlue),borderRadius: BorderRadius.circular(10),),
                        contentPadding:
                        EdgeInsets.only(top: 10,left: 10,right: 10),
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
                      'Email',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),

                  Container(
                    alignment :Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.6,
                    height:MediaQuery.of(context).size.height * 0.04,
                    margin: EdgeInsets.only(right: 10),
                    child: TextFormField(
                      controller: TextEditingController
                        (text:EmailHT),style: TextStyle
                      (fontSize: 14),
                      onChanged: (newValue) {
                        EmailHT =  newValue;
                        print("ádas222" +EmailHT);
                      },
                      //onChanged: (newValue) => this.utser.DiaChi =  newValue,
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      maxLines: 100,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors
                              .lightBlue),borderRadius: BorderRadius.circular(10),),
                        contentPadding:
                        EdgeInsets.only(top: 10,left: 10,right: 10),
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
                      'Số điện thoại',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),

                  Container(
                    alignment :Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.6,
                    height:MediaQuery.of(context).size.height * 0.04,
                    margin: EdgeInsets.only(right: 10),
                    child: TextFormField(
                      controller: TextEditingController(text:Telephone),
                      style: TextStyle(fontSize: 14),

                      onChanged: (newValue) {
                        Telephone =  newValue;
                        print("ádas" +Telephone);
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      maxLines: 100,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.lightBlue),borderRadius: BorderRadius.circular(10)),
                        contentPadding:
                        EdgeInsets.only(top: 10,left: 10,right: 10),
                      ),

                    ),
                  ),

                ],
              ),
              SizedBox(height: 5,),
              SizedBox(height: 20,),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Padding(padding: EdgeInsets.only(left: 10,right: 10,top: 0),
                    child:   TextButton.icon (
                        icon: Icon(Icons.send_and_archive),
                        label: Text('Cập nhật',style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () async {
                          var tendangnhap = sharedStorage.getString("username");
                          EasyLoading.show();
                          // var thoiGian = _dateController
                          //     .text.toString();
                          var thanhcong = await
                          postHoTro("ADDYKien",tendangnhap,NoiDung.text,
                              EmailHT,Telephone );

                          EasyLoading.dismiss();
                          Navigator.of(context).pop();
                          showAlertDialog(context, json.decode(thanhcong)['Message']);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue[50]),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        )
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 10,
                      right: 10,top: 0),
                    child:   TextButton.icon (
                      // child: Text("Đóng lại",style: TextStyle(fontWeight: FontWeight.bold),),
                        icon: Icon(Icons.delete_forever),
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
                ],)
            ],

          ),
        )


    );
  }
}
