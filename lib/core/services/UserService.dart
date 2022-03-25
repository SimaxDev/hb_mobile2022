import 'dart:convert';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:flutter/material.dart';
import 'package:hb_mobile2021/core/models/UserJson.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'callApi.dart';

String hoten, chucvu;
UserJson user;
GetInfoUserService(String username) async {
  var url = "/api/Home/GetUser?TenDangNhap=$username&TokenFireBase=$tokenDevice";
  // var parts = [];
  // parts.add('TenDangNhap=' + username);
  // var formData = parts.join('?');
  var response =await responseUser(url);
  if (response.statusCode == 200) {
      var items = json.decode(response.body)['OData'];
      return items;
  }
  else {
    return "";
  }

}
GetInfoUserServicedoNVi(String username,int id) async {
  if(username == "" || username == null){
    username = sharedStorage.getString("username");
  }
  var url = "/api/Home/GetUser?TenDangNhap=$username&ChangeDV=1&donviid=$id&&&TokenFireBase=$tokenDevice";

  var response =await responseUser(url);
  if (response.statusCode == 200) {
      var items = json.decode(response.body)['OData'];
      return items;
  }
  else {
    return "";
  }

}
Future<String> GetDetailUserService(String username) async {
  var url = "/api/Home/GetUser?TenDangNhap=$username&TokenFireBase=$tokenDevice";
  var parts = [];
  parts.add('TenDangNhap=' + username);
  var formData = parts.join('?');
  var response =await responseUser(url);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;

  }
  else {
    return "";
  }

  // var response = await responseData(url);
  // if(response.statusCode == 200) {
  //   var item = response.body;
  //   return item;
  // }
}

// Future<String> GetInfoUserService() async {
//   var url = "/api/Home/GetUser";
//   var parts = [];
//   //parts.add('keyWord=' + text);
//   var formData = parts.join('&');
//   var response = await responseData(url);
//   if(response.statusCode == 200) {
//     var item = response.body;
//     return item;
//   }
// }
// Future<String> getDataByKeyWordVBDen(String text) async {
//   var url = "/vbden/GetAllVBDen";
//   var parts = [];
//   parts.add('keyWord=' + text);
//   var formData = parts.join('&');
//   var response = await responseDataPost(url, formData);

//update
// Future<UserJson> upadteUser(Map<String,dynamic> params) async{
//
//   var url = "/vbdi/GetUserInfo";
//
//   var response = await responsePutData(url);
//   if(response.statusCode == 200)
//     {
//       final responseBody  = await json.decode(response.body);
//       return UserJson.fromJson(responseBody);
//     }
//   else{
//     throw Exception('Failed to delete User');
//   }
// }

Future<UserJson> getDataPut(String tendangnhap, String ActionXL,
    String title,
    String ngaysinh,
    int userGioiTinh,
    int chucvu,
    String email,
    String sdt,
    String sdttn,
    String DiaChi,
    bool cbEmail,
    bool cbSMS
    )
async {
  String url = "/api/ServiceUser/ActionXuLy";
  var parts = [];
  parts.add('tendangnhap=' + tendangnhap.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('Title=' + title);
  parts.add('userNgaySinh=' + ngaysinh);
  parts.add('userGioiTinh=' + userGioiTinh.toString());
  parts.add('userChucVu=' + chucvu.toString());
  parts.add('userEmail=' + email);
  parts.add('userDienThoaiDD=' + sdt);
  parts.add('userDienThoaiNR=' + sdttn);
  parts.add('userDiaChi=' + DiaChi);
  parts.add('userNhanEmail=' + cbEmail.toString());
  parts.add('userNhanSms=' + cbSMS.toString());
  var formData = parts.join('&');
  var response = await responsePostData(url, formData);
  if (response.statusCode == 200) {
    var items = json.decode(response.body);
    messingCN =  items['Message'];
    return UserJson.fromJson(items);

  }
}
Future<UserJson> getDataPutPass(String tendangnhap, String ActionXL,
  String pass
    )
async {
  String url = "/api/ServiceUser/ActionXuLy";
  var parts = [];
  parts.add('tendangnhap=' + tendangnhap.toString());
  parts.add('ActionXL=' + ActionXL);
  //parts.add('Title=' + title);
  var formData = parts.join('&');
  var response = await responsePostData(url, formData);
  if (response.statusCode == 200) {
    var items = json.decode(response.body);
    messingCN =  items['Message'];
    return UserJson.fromJson(items);

  }
}
 getDataChucVu(String username,String ActionXL) async {
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ActionXL=' + ActionXL);
  var formData = parts.join('&');
  String url = "/api/ServiceUser/ActionXuLy";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}
postResset(String username,String passs) async {
  var parts = [];
  parts.add('txtTenDangNhap=' + username.toString());
  parts.add('txtMatKhau=' + passs);
  var formData = parts.join('&');
  String url = "/api/Home/ResetPass";
  var response = await responseMK(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}
postCreate(String username,String passs,String eamil) async {
  var parts = [];
  parts.add('userTenTruyCap=' + username.toString());
  parts.add('ActionXL=CreateUser');
  parts.add('strMatKhau=' + passs);
  parts.add('userEmail=' + eamil);
  var formData = parts.join('&');
  String url = "/api/ServiceUser/ActionXuLy";
  var response = await responseMK(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}
