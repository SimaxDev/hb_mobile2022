import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

UserJson jsonToUserJson(str) => UserJson.fromJson(str);

class UserJson {
  String Title;
  String ChucVu ;
  String NgaySinh ;
  var GioiTinh ;
  String Email;
  String SDT ;
  String SDTN;
  String DiaChi ;
  bool cbNhanEmail;
  bool cbNhanSMS;
  String ThongBao="Đổi mật khẩu lần cuối 21/05/2021 lần tiếp theo nên đổi mật khẩu 20/07/2021";


  UserJson({
    required this.Title,
    required this.NgaySinh,
    required this.GioiTinh,
    required this.ChucVu,
    required this.Email,
    required this.SDT,
    required  this.SDTN,
    required  this.DiaChi,
    required  this.cbNhanEmail,
    required  this.cbNhanSMS,
    required this.ThongBao,});

  factory UserJson.fromJson(Map<String, dynamic> json) => UserJson(
    Title: json['Title'] ??"",
    ChucVu: json['chucvuCurrentTitle'] != null ? json['chucvuCurrentTitle']:"",
      GioiTinh: json['userGioiTinh'] != null ? json['userGioiTinh'] :"",
      NgaySinh: json['userNgaySinh'] != null ? DateFormat('dd-MM-yyyy').format(DateFormat('yyyy-MM-dd').parse
        (json['userNgaySinh'])):"",
      Email: json['userEmail'] != null ? json['userEmail'] : "",
       SDT: json['userDienThoaiDD']!=  null ? json['userDienThoaiDD'].toString() : "",
     SDTN:  json['userDienThoaiNR'] != null  ? json['userDienThoaiNR'].toString() : "",
    DiaChi:  json['userDiaChi'] !=  null  ? json['userDiaChi'] : "",
     cbNhanSMS: json['userNhanSms'] != null  ? json['userNhanSms'] as bool: false ,
    cbNhanEmail: json['userNhanEmail'] != null ? json['userNhanEmail'] as bool :false,
    ThongBao: "Đổi mật khẩu lần cuối 21/05/2021 lần tiếp theo nên đổi mật khẩu 20/07/2021"



    //Message: json['Message'] ? true : false,
  );
}


