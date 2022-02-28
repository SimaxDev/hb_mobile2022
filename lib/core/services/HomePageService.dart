import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:http/http.dart' as http;
Future<String> getVBDenHomePage( String Yearvb) async {
  String path = '/api/SVMenu/GetDataMenuVBD';
  //var response = await responseData(path);
  var parts = [];
 // parts.add('TenDangNhap=' + username);
  parts.add('SYear=' + Yearvb);

  var formData = parts.join('&');
  var response =await responseDataPost(path,formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  } else {
    return "";
  }
}
Future<String> getVBDenHome( String Yearvb) async {
  String path = '/api/SVMenu/GetDataMenuVBD';
  //var response = await responseData(path);
  var parts = [];
 // parts.add('TenDangNhap=' + username);
  parts.add('SYear=' + Yearvb);
  parts.add('intchuyen=1' );

  var formData = parts.join('&');
  var response =await responseDataPost(path,formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  } else {
    return "";
  }
}
Future<String> getthongbao( String Yearvb) async {
  String path = '/api/SVMenu/GetDataBanLamViecVBD';
  //var response = await responseData(path);
  var parts = [];
  // parts.add('TenDangNhap=' + username);
  parts.add('SYear=' + Yearvb);
  var formData = parts.join('&');
  var response =await responseDataPost(path,formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  } else {
    return "";
  }
}
Future<String> getthongbaoDT( String Yearvb) async {
  String path = '/api/SVMenu/GetDataBanLamViecVBDT';
  //var response = await responseData(path);
  var parts = [];
  // parts.add('TenDangNhap=' + username);
  parts.add('SYear=' + Yearvb);
  var formData = parts.join('&');
  var response =await responseDataPost(path,formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  } else {
    return "";
  }
}
Future<String> getthongbaoDi( String Yearvb) async {
  String path = '/api/SVMenu/GetDataBanLamViecVBDi';
  //var response = await responseData(path);
  var parts = [];
  // parts.add('TenDangNhap=' + username);
  parts.add('SYear=' + Yearvb);
  var formData = parts.join('&');
  var response =await responseDataPost(path,formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  } else {
    return "";
  }
}

Future<String> getVBDiHomePage( String Yearvb) async {
  String path = '/api/SVMenu/GetDataMenuVBDi';
  //var response = await responseData(path);
  var parts = [];

  parts.add('Yearvb=' + Yearvb);
  var formData = parts.join('&');
  var response =await responseDataPost(path,formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  } else {
    return "";
  }
}Future<String> getVBDiHome( String Yearvb) async {
  String path = '/api/SVMenu/GetDataMenuVBDi';
  //var response = await responseData(path);
  var parts = [];

  parts.add('Yearvb=' + Yearvb);
  parts.add('intchuyen=1' );
  var formData = parts.join('&');
  var response =await responseDataPost(path,formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  } else {
    return "";
  }
}

Future<String> getVBDTHomePage( String Yearvb) async {
  String path = '/api/SVMenu/GetDataMenuVBDT';
  //var response = await responseData(path);
  var parts = [];
  parts.add('Yearvb=' + Yearvb);
  var formData = parts.join('&');
  var response =await responseDataVBDen(path,formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  } else {
    return "";
  }
}
Future<String> getVBDTHome( String Yearvb) async {
  String path = '/api/SVMenu/GetDataMenuVBDT';
  //var response = await responseData(path);
  var parts = [];
  parts.add('Yearvb=' + Yearvb);
  parts.add('intchuyen=1' );
  var formData = parts.join('&');
  var response =await responseDataVBDen(path,formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  } else {
    return "";
  }
}