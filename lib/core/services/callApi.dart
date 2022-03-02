import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

//const String DOMAIN = "http://AppMobile.ungdungtructuyen.vn";
const String DOMAIN = "http://apimobile.hoabinh.gov.vn";
 Timer _timer;
 String tokenDevice="";
SharedPreferences sharedStorage;
String tendangnhapAll = "";
String ten;
var datavb = "";
var vanbandenCapNhat = null;
int trangThaiVB =0;
int vbdiTrangThaiVB =0;
int vbdiCurrentNguoiTrinhID =0;
String vbdiNguoiSoan= "";
List lstPhongBanLaVanThuVBDI= [];
List lstPhongBanLaVanThuVBDEN= [];
List userGroups= [];
List lstThongTinGroup= [];
bool ThemMoiVanBanDi= false;
bool ThemVanBanDen= false;
bool checkThuHoi= false;
bool ThietLapHoiBao= false;
bool vbdiCanTDHB= false;
bool isTrinhKy= false;
bool trinhDaCoNgDuyet= false;
bool trinhLan2= false;
bool ChuyenVT= false;
String SiteAction= "";
String userTenTruyCap= "";
int vbdiNguoiSoanID= 0;
int hscvNguoiLap= 0;
int hscvNguoiPhuTrach= 0;
int currentUserID= 0;
int CurrentDonViID= 0;
int vbdiNguoiKyID= 0;
int chukyso= 0;
String vbdiNguoiTrinhTiep= "";
List vbdiDSNguoiTrinhTiep=[];
String vbdiNguoiKy= "";
String hoVaTen = "";
String tenPhongBan = "";
String CurrentTenDonVi = "";
String OrganName = "";
var tick = 0;
String EmailHT = "";
String Telephone = "";
String ngayTrinhDT= "";
bool butPheVBD = false;
bool thuHoiVBD = false;
bool isDuyetVaPhatHanh = false;
bool kyVaPhatHanh = false;
bool checkKetThucHSCV = false;
bool checkSoanVBDT = false;
bool checkChuyenVaoHS = false;
bool isDuyetTruongPhong = false;
bool isDuyet = false;
String XemDB = "";
bool hanXLVBD = false;
int vbdTTXuLyVanBanLT= 0;
int isnguoiduyet= 0;
int vbdPhuongThuc= 0;
int vbdTrangThaiXuLyVanBan= 0;
int vbdSoVanBan= 0;
int hscvTrangThaiXuLy= 0;
var   currentDuThao;
List lstvbdUserChuaXuLy = [];
List strListId = [];
List strListVanBanLienQuanID = [];
List strListVanBanDiLienQuan = [];
List vbdiCurrentUserReceived = [];
bool vbdUserChuaXuLy = false;
String vbdHanXuLy ="";
bool vbdiIsSentVanBan = false;
bool checkbtnXDB = false;
bool CapSoVanBanDi = false;
bool vbdIsSentVanBan = false;
bool clickChon =  false;
bool GuiVanBanDi = false;
bool GuiVanBan = false;
bool SuaVanBanDen = false;
bool isQTNew = false;
bool notIsQuanTriNew = false;
int ID=0;
int DonViInSiteID=0;
List<dynamic> userHasQuyenKyVB = [];
int groupID = 0;
List duthaoListXoa = [];
//thêm mới dự thảo
String TrichYeuDT = "";
String loaivbDT =  "";
String vbdiSoKyHieu = "";
String vNguoiKy = "";
String vNguoiTrinh= "";
String toTrinh= "";
String ls="";
String ls1="";
String ls2="";
String messingCN = "";
String matKhauHT = "";
List dataListTT = [];
var vanbanDi ;
var vanbanDen = null ;
var vanbanDT = null ;
String userChucVu = "";
String pdf = "";
List Listpdf = [];
List ListpdfPT = [];
String namepdf = "";
String pdfPT = "";
String idCT = "";
String idChuTri = "";
String idPhoiHop = "";
String idTheoDoi = "";
String idNTD = "";
int IDTT ;




Future responseDataPost(String path,String formdata) async {
  var url = Uri.parse(DOMAIN + path);
  var response;
  sharedStorage = await SharedPreferences.getInstance();
  if( sharedStorage == null){
    return CircularProgressIndicator();
  }
  else{
  String token = sharedStorage.getString("token");
   // response = await post(Uri.parse(url),
   //    headers: {
   //    "Accept": "application/json",
   //    "Content-Type": "application/x-www-form-urlencoded",
   //   'Authorization': 'Bearer ' + token
   //    },
   //   body: formdata
   // );
  response = await http.post(
    url,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer ' + token
    },
    body: formdata,
  );

  return response;}
}
responseDataPost1(String path, final formdata) async {
  var url = Uri.parse(DOMAIN + path);
  var response =  null ;
  sharedStorage = await SharedPreferences.getInstance();
  if( sharedStorage == null){
    return CircularProgressIndicator();
  }
  else{
  String token = sharedStorage.getString("token");
  response = await http.post(
    url,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer ' + token
    },
    body: json.encode(formdata),
  );

  return response;}
}
Future<http.Response> responseDataPost2(String path, var formdata) async {
   var url = Uri.parse(DOMAIN + path);
    String token = sharedStorage.getString("token");
  return await http.post(
   url,
      body: json.encode(formdata),
      headers: { 'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": 'Bearer ' + token,}
    );

}
//lay chi tiet vbden
responseDataPostVBDen(String path,String formdata) async {
   var url = Uri.parse(DOMAIN + path);
  sharedStorage = await SharedPreferences.getInstance();
  String token = sharedStorage.getString("token");
  var response = await http.post(
    url,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer ' + token
    },
    body: formdata,
  );
  return response;
}


responseData(String path) async {
   var url = Uri.parse(DOMAIN + path);
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
  return response;
}
// get home văn bản đến
responseDataHOmeVBDen(String path, String formdata) async {
   var url = Uri.parse(DOMAIN + path);
  sharedStorage = await SharedPreferences.getInstance();
  String token = sharedStorage.getString("token");
  var response = await http.post(
    url,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer ' + token
    },
    body: formdata,
  );
  return response;
}
responseMK(String path, String formdata) async {
   var url = Uri.parse(DOMAIN + path);
  var response = await http.post(
    url,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: formdata,
  );
  return response;
}
responseDataVBDen(String path, String formdata) async {
   var url = Uri.parse(DOMAIN + path);
  sharedStorage = await SharedPreferences.getInstance();
  String token = sharedStorage.getString("token");
  var response = await http.post(
    url,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer ' + token
    },
    body: formdata,
  );
  return response;
}

//getusser apimoi
responseUser(String path) async {
   var url = Uri.parse(DOMAIN + path);
  var response = await http.get(url);
  return response;
}
responsePostData(String path, String formdata) async {
   var url = Uri.parse(DOMAIN + path);
  sharedStorage = await SharedPreferences.getInstance();
  String token = sharedStorage.getString("token");
  var response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer ' + token
      },
      body: formdata

  );
  return response;
}