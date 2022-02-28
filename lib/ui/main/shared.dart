// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';

import 'package:hb_mobile2021/ui/Login/Login.dart';

import '../../core/services/callApi.dart';

int tt2;
int tt4;
int tt6;
int tt8;
bool isLogin;

String tokenfirebase;
// SharedPreferences sharedStorage;
//const String DOMAIN = "http://apimobile2021.ungdungtructuyen.vn";
//const String DOMAIN = "cc";
const String DOMAIN = "http://apimobile.hoabinh.gov.vn";

void logOut(BuildContext context) async {
  sharedStorage = await SharedPreferences.getInstance();
      if(!sharedStorage.getBool("rememberme")) {
        sharedStorage.remove("password");

      }
 else{
    sharedStorage.remove("expires_in");
    sharedStorage.remove("token");
    // FirebaseMessaging.instance.unsubscribeFromTopic("truyenthong_all");
  }
 // Get.off(LoginWidget());
  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
      builder: (BuildContext context) => LoginWidget()), (Route<dynamic> route) => false);
}



lengthDuthao(BuildContext context, String path)async{
  var url = Uri.parse(DOMAIN + path);
  List duthaoList = [];
  sharedStorage = await SharedPreferences.getInstance();
  String token = sharedStorage.getString("token");
  var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer ' + token
      }
  );
  if (response.statusCode == 200) {
    var items = json.decode(response.body)['OData'];
    duthaoList = items;
  } else if(response.statusCode == 401){
    await showAlertDialog(context, "Phiên đăng nhập đã hết hạn \n Vui lòng thử lại");
    logOut(context);
  }
  return duthaoList.length;
}

double autoTextSize(double textSize, double textScaleFactor) {
  return textScaleFactor != 1.0 ? textSize / textScaleFactor : textSize;
}