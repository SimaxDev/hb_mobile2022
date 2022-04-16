import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hb_mobile2021/core/models/UserJson.dart';
import 'package:hb_mobile2021/core/services/UserService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/ui/main/btnavigator_widget.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';

import 'Login.dart';


class SplashWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashState();
  }
}

class SplashState extends State<SplashWidget> {
  SharedPreferences sharedStorage;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;
  bool isLoading = false;
  bool _showPass = true;
  var user;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) =>  LoginWidget() ,));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,

      body: Container(
          decoration: new BoxDecoration(

              image: new DecorationImage(
                image: AssetImage("assets/hbq-logo.jpg"),
                fit: BoxFit.fitHeight,
              )
          ),
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("assets/hb-logo.jpg"),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: SafeArea(
            child: Padding(
                padding: EdgeInsets.all(30),
                child: isLoading
                    ? Center(
                    child: CircularProgressIndicator(
                      valueColor:
                      new AlwaysStoppedAnimation<Color>(Colors.white),
                    ))
                    : ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 0,
                    ),

                    Container(

                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: Image(
                        image: AssetImage('assets/logo_thb.png'),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "TỈNH HOÀ BÌNH",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.white,
                                offset: Offset(5.0, 5.0),
                              )
                            ]),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "HỆ THỐNG QUẢN LÝ VĂN BẢN VÀ ĐIỀU HÀNH TÁC NGHIỆP",
                        style: TextStyle(
                            color: Color(0xFFFDD835),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(height: 150,),
                    Column(children: [
                      Row(
                        children: [
                          Icon(Icons.phone_bluetooth_speaker,color: Colors.white,),
                          Text(" Số ĐT hỗ trợ kỹ thuật:"
                            ,style: TextStyle(color: Colors.white,fontSize:
                            14),),
                          Text("0218 3897 506"
                            ,style: TextStyle(color: Colors.white,fontSize:
                            18, shadows: [
                              Shadow(
                                blurRadius: 12.0,
                                color: Colors.white,
                                offset: Offset(5.0, 5.0),
                              )
                            ] ),
                          )
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          Icon(Icons.phone_android_outlined,color: Colors.white),
                          Text(" Cài đặt VBDH Hòa Bình \n"
                              " trên thiết bị di động(Android, IOS)"
                            ,style: TextStyle(color: Colors.white,fontSize:
                                14),
                          )
                        ],
                      ),

                    ],),




                  ],
                )),
          )),
    );

  }


}
