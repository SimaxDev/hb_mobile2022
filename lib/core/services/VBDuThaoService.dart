import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';

String mesDT = "";

Future<String> getDataVBDT(int skip, int pageSize, String ActionXL,String year) async {
  String url = "/api/ServicesVBDT/GetData";
  var parts = [];
  parts.add('ActionXL=' + ActionXL.toString());
  parts.add('skip=' + skip.toString());
  parts.add('pagesize=' + pageSize.toString());
  parts.add('Yearvb=' + year.toString());
  var formData = parts.join('&');
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);

    return items;
  }
}
Future<String> getDataHomeVBDT(int skip, int pageSize, String ActionXL,String
query,String nam,int skippage) async {
  String url = "/api/ServicesVBDT/GetData";
  var parts = [];
  parts.add('ActionXL=' + ActionXL.toString());
  parts.add(query.toString());
 parts.add('skip=' + skippage.toString());
 parts.add('page=' + skip.toString());
 parts.add('take=10');
 parts.add('pagesize=' + pageSize.toString());
  parts.add('Yearvb=' + nam.toString());
  var formData = parts.join('&');
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}


Future<String>postThemDT(   noidungykien,vbdiLoaiVB,cbKy,cbDyet,cbHoaToc,vbdiNguoiKy,
    vbdiNguoiTrinhTiep,totrinhNguoiDuyet2,userChoosen,tenPDF,base64,tenPDF1,
    base641,nam)
async {
  String SYear = "2022";
  if (nam == null) {
    DateTime now = DateTime.now();
    String  nam1 =  DateFormat('yyyy').format(now) ;
    SYear = nam1;
  }
 //  var parts = [];
 //
 //  //parts.add('ActionXL=' + ActionXL);
 //  parts.add('vbdiTrichYeu=' + noidungykien);
 //  parts.add('vbdiLoaiVanBan=' + vbdiLoaiVB.toString());
 // // parts.add('listValueFileAttach=' + pdf.toString());
 //  parts.add('cbKy=' + cbKy);
 //  parts.add('cbDuyet=' + cbDyet);
 //  parts.add('cbHoaToc=' + cbHoaToc);
 //  parts.add('vbdiNguoiKy=' + vbdiNguoiKy);
 //  parts.add('vbdiDSNguoiTrinhTiep=' + vbdiNguoiTrinhTiep);
 //  parts.add('totrinhCurrentNguoiDuyet2=' + totrinhNguoiDuyet2);
 //  parts.add('listValueFileAttach10=' + pdf1.toString());
 //  parts.add('userChoosenTrinhDuthao=' + userChoosen);
 //  var formData = parts.join(',');
  var formData;
  if(vbdiNguoiKy != null  && vbdiNguoiKy !="" ){
    formData = {
      "ActionXL":"DUTHAOUPDATE",
      "vbdiTrangThaiVB":"4",
      "vbdiTrichYeu": "$noidungykien",
      "vbdiLoaiVanBan":vbdiLoaiVB,
      "cbKy":cbKy ,
      "cbDuyet":cbDyet ,
      "cbHoaToc": cbHoaToc,
      "vbdiNguoiKy": vbdiNguoiKy,
      "vbdiDSNguoiTrinhTiep": vbdiNguoiTrinhTiep,
      "totrinhCurrentNguoiDuyet2": totrinhNguoiDuyet2,
      "listValueFileAttach10Name": "$tenPDF1",
      "listValueFileAttach10DataFile": "$base641",
      "listValueFileAttachName": "$tenPDF",
      "listValueFileAttachDataFile": "$base64",
      "userChoosenTrinhDuthao":"$userChoosen" ,
      "SYear":"$SYear" ,

    };
  }
  else{
     formData = {
      "ActionXL":"DUTHAOUPDATE",
       "vbdiTrangThaiVB":"2",
      "vbdiTrichYeu": "$noidungykien",
      "vbdiLoaiVanBan":vbdiLoaiVB,
      "cbKy":cbKy ,
      "cbDuyet":cbDyet ,
      "cbHoaToc": cbHoaToc,
      "vbdiNguoiKy": vbdiNguoiKy,
      "vbdiDSNguoiTrinhTiep": vbdiNguoiTrinhTiep,
      "totrinhCurrentNguoiDuyet2": totrinhNguoiDuyet2,
       "listValueFileAttach10Name": "$tenPDF1",
       "listValueFileAttach10DataFile": "$base641",
       "listValueFileAttachName": "$tenPDF",
       "listValueFileAttachDataFile": "$base64",
      "userChoosenTrinhDuthao":"$userChoosen" ,
       "SYear":"$SYear" ,
    };
  }






  String url = "/api/ServicesVBDT/XuLyDuThaoTM";
  var response = await responseDataPost1(url, formData);

  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}


Future<String> getDataByKeyWordVBDT(String ActionXL,String
text,String year,query) async {
  var url = "/api/ServicesVBDT/GetData";
  var parts = [];
  // parts.add('TenDangNhap=' + TenDangNhap.toString());
  parts.add('ActionXL=' + ActionXL.toString());
  parts.add('searchTimNhanh=' + text);
  parts.add('Yearvb=' + year);
  if(query != null)
  {
    parts.add( query.toString());
  }
  var formData = parts.join('&');
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}

Future<String>getDataByKeyYearVBDuThao(String TenDangNhap,String query,String
ActionXL,String year,int skip, int pageS) async {
  var url = "/api/ServicesVBDT/GetData";
  var parts = [];
  parts.add('TenDangNhap=' + TenDangNhap.toString());
  parts.add('ActionXL=' + ActionXL.toString());
  if(query != null) {
    parts.add(query.toString());
  }
  parts.add('skip=' + skip.toString());
  parts.add('pagesize=' + pageS.toString());
  parts.add('Yearvb=' + year);
  var formData = parts.join('&');
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}

// Future<String> getDataByCreatedVBDT(String created) async {
//   var url = "/vbdt/GetAllvbdt";
//   var parts = [];
//   parts.add(created);
//   var formData = parts.join('&');
//   var response = await responseDataPost(url, formData);
//   if (response.statusCode == 200) {
//     var items = (response.body);
//     return items;
//   }
// }

Future<String> getDataDetailVBDT(int idDuThao,String
ActionXL,nam,MaDonVi) async {
  var parts = [];
  if(nam == null){
    DateTime now = DateTime.now();
    nam = DateFormat('yyyy').format(now);
  }
  parts.add('ItemID=' + idDuThao.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('SYear=' + nam);
  parts.add('SitesColection=' + MaDonVi.toString());
  var formData = parts.join('&');
  String url = "/api/ServicesVBDT/GetData";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}
getDataLoaiVB(String username,String ActionXL) async {
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ActionXL=' + ActionXL);
  var formData = parts.join('&');
  String url = "/api/ServicesVBDT/GetData";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}
Future<String>posYKienVBDT( username,id, ActionXL,String  noidungykien,
    nam) async {
  if(nam == null){
    DateTime now = DateTime.now();
    nam = DateFormat('yyyy').format(now);
  }
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('noiDungYKien=' + noidungykien);
  parts.add('SYear=' + nam.toString());
  var formData = parts.join('&');
  String url = "/api/ServicesVBDT/XuLyDuThao";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
  else{
    return "";
  }
}

Future<String>posDuyetVBDT( username,id, ActionXL,String  noidungykien,DaDuyet) async {
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('Title=' + noidungykien);
  parts.add('DaDuyet=' + DaDuyet.toString());
  var formData = parts.join('&');
  String url = "/api/ServicesVBDT/XuLyDuThao";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
  else{
    return "";
  }
}
Future<String>posTrinhlaiVBDT( username,id, ActionXL,String  noidungykien,nam)
async {
  if (nam == null) {
    DateTime now = DateTime.now();
    nam = DateFormat('yyyy').format(now);
  }
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('ykienbosung=' + noidungykien);
  parts.add('SYear=' + nam);
  var formData = parts.join('&');
  String url = "/api/ServicesVBDT/XuLyDuThao";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
  else {
    return "";
  }
}
Future<String>posTraVeVBDT( username,id, ActionXL,String  noidungykien,nam,
    pdfString,base64)
async {
  if(nam == null){
    DateTime now = DateTime.now();
    nam = DateFormat('yyyy').format(now);
  }
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('vNoiDungBP=' + noidungykien);
  parts.add('lstFileAtt=[{"FileName":$pdfString,"Data":$base64}]' );
  parts.add('SYear=' + nam);
  var formData = parts.join('&');
  String url = "/api/ServicesVBDT/XuLyDuThao";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
  else{
    return "";
  }
}
Future<String>postChuyenPhatHanh( username,id, ActionXL,String  noidungykien,
    nam,pdfDuyet,bass)
async {
  if(nam == null){
    DateTime now = DateTime.now();
    nam = DateFormat('yyyy').format(now);
  }
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('YKienCP=' + noidungykien);
  parts.add('lstFileAtt=[{"FileName":$pdfDuyet,"Data":$bass}]' );
  parts.add('SYear=' + nam);
  var formData = parts.join('&');
  String url = "/api/ServicesVBDT/XuLyDuThao";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
  else{
    return "";
  }
}
Future<String>posTrinhKyVBDT( username,id, ActionXL,String  noidungykien,nam)
async {
  if(nam == null){
    DateTime now = DateTime.now();
    nam = DateFormat('yyyy').format(now);
  }
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('vNoiDungBP=' + noidungykien);

  parts.add('SYear=' + nam);
  var formData = parts.join('&');
  String url = "/api/ServicesVBDT/XuLyDuThao";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
  else{
    return "";
  }
}
Future<String>posThuHoiVBDT( username,id, ActionXL,nam) async {
  var parts = [];
  if(nam == null){
    DateTime now = DateTime.now();
    nam = DateFormat('yyyy').format(now);
  }
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('SYear=' + nam.toString());
  var formData = parts.join('&');
  String url = "/api/ServicesVBDT/XuLyDuThao";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
  else{
    return "";
  }
}
Future<String>posTrinhLaiVBDT( username,id, ActionXL,String  noidungykien,) async {
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('Title=' + noidungykien);
  var formData = parts.join('&');
  String url = "/api/ServicesVBDT/XuLyDuThao";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
  else{
    return "";
  }
}
Future<String>posBanHanhVBDT( username,id, ActionXL,String  noidungykien,) async {
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('YKienCP=' + noidungykien);
  var formData = parts.join('&');
  String url = "/api/ServicesVBDT/XuLyDuThao";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
  else{
    return "";
  }
}
Future<String>posTrinhTiepVBDT( username,id, ActionXL,String  noidungykien,) async {
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('ykienbosung=' + noidungykien);
  var formData = parts.join('&');
  String url = "/api/ServicesVBDT/XuLyDuThao";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
  else{
    return "";
  }
}

Future<String> getYkienDataVBDT(int id,String ActionXL,String
nam) async {
  var parts = [];

  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL.toString());
  parts.add('sYear=' + nam.toString());
  var formData = parts.join('&');
  String url = "/api/ServicesVBDT/GetData";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}

Future<String> getButPheDataVBDT(int id) async {
  var parts = [];
  parts.add('id=' + id.toString());
  var formData = parts.join('&');
  String url = "/vbdt/GetYKien";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}

/////Phiêu trình
Future<String> getDataDetailVBPT(int idPhieuTrinh,String ActionXL,nam) async {

  if(nam == null){
    DateTime now = DateTime.now();
    nam = DateFormat('yyyy').format(now);
  }

  var parts = [];
  parts.add('sYear=' + nam.toString());
  parts.add('ItemID=' + idPhieuTrinh.toString());
  parts.add('ActionXL=' + ActionXL);
  var formData = parts.join('&');
  String url = "/api/ServicesVBDT/GetData";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}


Future<String> getYkienDataVBPT(String username,int idPhieuTrinh,String ActionXL) async {
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + idPhieuTrinh.toString());
  parts.add('ActionXL=' + ActionXL);
  var formData = parts.join('&');
  String url = "/api/ServicesVBDT/GetData";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}
Future<String> getDataCVB(String username,String ActionXL) async {
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ActionXL=' + ActionXL);
  var formData = parts.join('&');
  String url = "/api/ServicesVBDT/GetData";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}
Future<String> postTrinhTiepDT( username,id, ActionXL,CBChon,cayPD,cayPD2,cayNK,
    YKien,nam)
async {
  if(nam == null){
    DateTime now = DateTime.now();
    nam = DateFormat('yyyy').format(now);
  }
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL.toString());
  parts.add('vbdiTrangThaiVB=4');
  parts.add('userChoosenTrinhDuthao=' + CBChon.toString());
  parts.add('vbdiDSNguoiTrinhTiep=' + cayPD.toString());
  parts.add('totrinhCurrentNguoiDuyet2=' + cayPD2.toString());
  parts.add('vbdiNguoiKy=' + cayNK.toString());
  parts.add('ykienbosung=' + YKien.toString());
  parts.add('SYear=' + nam.toString());
  var formData = parts.join('&');
  String url = "/api/ServicesVBDT/XuLyDuThao";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}

