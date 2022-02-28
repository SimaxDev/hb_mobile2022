import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hb_mobile2021/core/models/UserJson.dart';
import 'package:hb_mobile2021/core/services/UserService.dart';
import 'package:hb_mobile2021/ui/User/Edit_user.dart';


class ThongtinUser extends StatefulWidget {

  final String username;
   ThongtinUser({Key key, this.username}) : super(key: key);

  @override
  _ThongtinUserState createState() => _ThongtinUserState();
}


class _ThongtinUserState extends State<ThongtinUser> {
  bool valueEmail = false;
  bool valueSMS = false;
  bool isLoading = false;
  String testthuhomerxoa;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var users = null;
  var tendangnhap = "";
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


  void initState() {
    _initializeTimer();
    super.initState();
    refreshList();
    GetDataDetailUser();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      refreshList();
    });
  }
  //lấy thông tin user
 Future<UserJson> GetDataDetailUser() async {
   tendangnhap =widget.username;

    if(tendangnhap == null || tendangnhap == "")
    {
      tendangnhap =sharedStorage.getString("username");
    }




    String detailUser =  await GetDetailUserService(tendangnhap);
    setState(() {
      var data =  json.decode(detailUser)['OData'];
      users = UserJson.fromJson(data);
    });
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      GetDataDetailUser();
    }
    );

    return null;
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleUserInteraction,
      onPanDown: _handleUserInteraction,
      onScaleStart: _handleUserInteraction,
      child:RefreshIndicator(child: Scaffold(
      appBar: AppBar(title: Text('Thông tin cá nhân'),),
      body:users == null ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors
          .blue))) :
      SingleChildScrollView(

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
                      .width * 0.6,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.04,
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: Text(  users.Title
                    ,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    //textAlign: TextAlign.justify,

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
                    'Ngày sinh',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
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
                      .width * 0.6,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.04,
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: Text(
                    users.NgaySinh,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
            SizedBox(height:5,),
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
                      .width * 0.6,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.04,
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: Text(
                    getTrangThai(users.GioiTinh),
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    textAlign: TextAlign.justify,
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
                    'Chức vụ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
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
                      .width * 0.6,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.04,
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: Text(
                    users.ChucVu != null ?  users.ChucVu : "",
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    textAlign: TextAlign.justify,
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
                    'Địa chỉ Email*',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
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
                      .width * 0.6,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.04,
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: Text(
                    users.Email,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    textAlign: TextAlign.justify,
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
                    'Điện thoại DĐ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
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
                      .width * 0.6,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.04,
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: Text(
                    users.SDT,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ), SizedBox(height:5,),
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
                      .width * 0.6,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.04,
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: Text(
                    users.SDTN,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    textAlign: TextAlign.justify,
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
                    "Địa chỉ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(

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
                      .width * 0.6,

                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),


                     child:  Text(
                       users.DiaChi,

                       style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                       textAlign: TextAlign.justify,
                       maxLines: 100,


                     ),

                )
              ],
            ),
            SizedBox(height: 0,),
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
                    value: users.cbNhanEmail,
                    // onChanged: (bool value) {
                    //   setState(() {
                    //     this.valueEmail = value;
                    //   });
                    //},
                  ),
                )

              ],
            ),
            SizedBox(height:0,),
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

                    value: users.cbNhanSMS,
                    // onChanged: (bool value) {
                    //   setState(() {
                    //     this.valueSMS = value;
                    //   });
                    // },
                  ),
                )

              ],
            ),
            SizedBox(height: 0,),
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
                    'Thông báo',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Container(
                  // decoration: BoxDecoration(
                  //     border: Border.all(color: Colors.black12)
                  // ),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.6,
                  padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                  margin: EdgeInsets.only(right: 10),
                  child: Text(
                    users.ThongBao,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
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
                  child: Text('Sửa thông tin',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      )),
                  onPressed: () {
                    setState(() {
                      UserJson utser = new UserJson(Title: users.Title,ThongBao: users.ThongBao,ChucVu: users.ChucVu,
                        DiaChi: users.DiaChi,Email: users.Email,GioiTinh: users.GioiTinh,NgaySinh: users.NgaySinh,
                        SDT: users.SDT,SDTN: users.SDTN,cbNhanEmail:  users.cbNhanEmail, cbNhanSMS:  users
                            .cbNhanSMS,);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditUser(utser:utser,gui : refreshList()),
                          ));
                      isLoading = true;
                    });
                    // login(usernameController.text.trim(),
                    //     passwordController.text);
                  },
                )
            ),
          ],
          //,cbNhanEmail: "",cbNhanSMS: "",Message: "",NgaySinh: "",

        ),


      ),




    ), onRefresh: refreshList),);

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
