import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
String lstUserCVBi="";
String lstvbdiNoiNhan="";

List<String> bientoancuc = new List<String>();
var TreViewVBDi ;



Future<String> GetMenuLeft() async {
  var url = "/vbdi/GetMenuLeft";
  var response = await responseData(url);
  if(response.statusCode == 200) {
    var item = response.body;
    return item;
  }
}
Future<String> getDataVBDi(int skip, int pageSize,  String ActionXL) async {
  String url = "/api/ServicesVBDi/GetData";
  var parts = [];
  parts.add('ActionXL=' + ActionXL.toString());
  parts.add('skip=' + skip.toString());
  parts.add('pagesize=' + pageSize.toString());
  var formData = parts.join('&');
  var response = await responseDataPost(url, formData);

  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}
Future<String> getTT( String ActionXL,text,String nam) async {
  String url = "/api/ServicesVBDi/GetData" ;
  var parts = [];
  // parts.add('ActionXL=' + ActionXL.toString());
  parts.add('Yearvb=' + nam);
  parts.add('ActionXL=' + ActionXL.toString());
  parts.add('searchTimNhanh=' + text);
  var formData = parts.join('&');
  var response = await responseDataPost(url, formData);

  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}
Future<String> getDataHomeVBDi1( String ActionXL,String nam) async {
  String url = "/api/ServicesVBDi/GetData?ActionXL=" + ActionXL;
  var parts = [];
 // parts.add('ActionXL=' + ActionXL.toString());
  parts.add('Yearvb=' + nam);
  var formData = parts.join('&');
  var response = await responseDataPost(url, formData);

  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}
Future<String> getDataHomeVBDi(int skip, int pageSize,  String ActionXL,
    String query, nam,int skippage) async {
  String url = "/api/ServicesVBDi/GetData";
  var parts = [];
  parts.add('ActionXL=' + ActionXL.toString());
  if(query != null)
    {
      parts.add( query.toString());
    }

  parts.add('skip=' + skippage.toString());
  parts.add('page=' + skip.toString());
  parts.add('take=20' );
  parts.add('pagesize=' + pageSize.toString());
  parts.add('Yearvb=' + nam.toString());
  parts.add('GriSort=[{ field: "vbdiNgayBanHanh", dir: "false" }, { field: "vbdiSoCongVan", dir: "false" }, { field: "vbdiYear", dir: "false" }]' );
  var formData = parts.join('&');
  var response = await responseDataPost(url, formData);

  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}
Future<String> getDataHomeVBDiThayThe(int skip, int pageSize,  String ActionXL,
     nam,int skippage) async {
  String url = "/api/ServicesVBDi/GetData";
  var parts = [];
  parts.add('ActionXL=' + ActionXL.toString());
  parts.add('skip=' + skippage.toString());
  parts.add('page=' + skip.toString());
  parts.add('take=20' );
  parts.add('pagesize=' + pageSize.toString());
  parts.add('Yearvb=' + nam.toString());
  parts.add('GriSort=[{ field: "vbdiNgayBanHanh", dir: "false" }, { field: "vbdiSoCongVan", dir: "false" }, { field: "vbdiYear", dir: "false" }]' );
  var formData = parts.join('&');
  var response = await responseDataPost(url, formData);

  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}

Future<String> getDataByKeyWordVBDi(String TenDangNhap,String ActionXL,String
text,String year,query) async {
  var url= "/api/ServicesVBDi/GetData";
  var parts = [];
  parts.add('TenDangNhap=' + TenDangNhap.toString());
  parts.add('ActionXL=' + ActionXL.toString());
  parts.add('searchTimNhanh=' + text);

  if(query != null)
  {
    parts.add( query.toString());
  }
  parts.add('Yearvb=' + year);
  var formData = parts.join('&');
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}

Future<String> getDataByKeyWordVBDiTT(String TenDangNhap,String ActionXL,String
text,String year) async {
  var url= "/api/ServicesVBDi/GetData";
  var parts = [];
  parts.add('TenDangNhap=' + TenDangNhap.toString());
  parts.add('ActionXL=' + ActionXL.toString());
  parts.add('searchTimNhanh=' + text);
  parts.add('Yearvb=' + year);
  var formData = parts.join('&');
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}

Future<String>getDataByKeyYearVBDi(String TenDangNhap,String ActionXL,String
year,query,int skip,int pageSize) async {
  var url = "/api/ServicesVBDi/GetData";
  var parts = [];
  parts.add('TenDangNhap=' + TenDangNhap.toString());
  parts.add('ActionXL=' + ActionXL.toString());
  parts.add('Yearvb=' + year);
  if(query != null)
  {
    parts.add( query.toString());
  }
  parts.add('skip=' + skip.toString());
  parts.add('pagesize=' + pageSize.toString());
  var formData = parts.join('&');
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}

Future<String> getDataByCreatedVBDi(String created) async {
  var url = "/vbdi/GetAllVBDi";
  var parts = [];
  parts.add(created);
  var formData = parts.join('&');
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}

Future<String> getYkienDataVBDi(int id,String ActionXL,int
nam) async {
  var parts = [];
  // parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL.toString());
  parts.add('SYear=' + nam.toString());
  var formData = parts.join('&');
  String url = "/api/ServicesVBDi/GetData";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}

Future<String>posChuyenLienThong( username,id, ActionXL,String  noidungykien,
    nam) async {
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('SYear=' + nam.toString());
  parts.add('vbdiDSDonViNhanVB=' + noidungykien);
  var formData = parts.join('&');
  String url = "/api/ServicesVBDi/XuLyVBDi";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
  else{
    return "";
  }
}

Future<String>posTraVeVBDi( username,id, ActionXL,String  noidungykien,SYear) async {
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('SYear=' + SYear.toString());
  parts.add('YKienTraVe=' + noidungykien);
  var formData = parts.join('&');
  String url = "/api/ServicesVBDi/XuLyVBDi";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
  else{
    return "";
  }
}

Future<String> getButPheDataVBDi(int id) async {
  var parts = [];
  parts.add('id=' + id.toString());
  var formData = parts.join('&');
  String url = "/vbdi/GetYKien";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}

Future<String> getDataDetailVBDi(int id,String ActionXL,
    String MaDonVi) async {
  var parts = [];
  // parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('SitesColection=' + MaDonVi);
  var formData = parts.join('&');
  String url = "/api/ServicesVBDi/GetData";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}

Future<String> GetHomeThuHoiVBDi(String ActionXL,int nam,int id) async {
  var parts = [];
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('SYear=' + nam.toString());
  var formData = parts.join('&');
  String url = "/api/ServicesVBDi/GetData";
  var response = await responseDataPostVBDen(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}


Future<String>postYKienVBDi( username,id, ActionXL,  noidungykien,nam) async {
  var parts = [];
  if(nam == null){
    DateTime now = DateTime.now();
    nam =  int.parse(DateFormat('yyyy').format(now)) ;
  };
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('SYear=' + nam.toString());
  parts.add('vNoiDungBP=' + noidungykien);
  var formData = parts.join('&');
  String url = "/api/ServicesVBDi/XuLyVBDi";
  var response = await responseDataPost(url, formData);

  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}
Future<String>getDataCVBDi(String username,String ActionXL,nam) async {
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('sYear='+ nam.toString() );
  var formData = parts.join('&');
  String url = "/api/ServicesVBDi/GetData";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}
Future<String>getDataCVB(String username,String ActionXL) async {
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ActionXL=' + ActionXL);
  var formData = parts.join('&');
  String url = "/api/ServicesVBDi/GetData";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}
Future<String>postChuyenVBDi( username,id, ActionXL,  noidungykien, idngnhan,nam
    ) async {
  var parts = [];
  DateTime now = DateTime.now();
  String Yearvb = DateFormat('yyyy').format(now);
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('SYear=' + nam.toString());
  parts.add('userChoosen=' + noidungykien);
 //parts.add('vbdiNoiNhan=' + idngnhan.toString());
  var formData = parts.join('&');
  String url = "/api/ServicesVBDi/XuLyVBDi";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}

Future<String>postChuyenVBDiNgoai( username,id, ActionXL,  noidungykien,
    idngnhan,int nam) async {
  // DateTime now = DateTime.now();
  // String Yearvb = DateFormat('yyyy').format(now);
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('SYear=' + nam.toString());
  parts.add('vbdiNoiNhan=' + noidungykien);
 //parts.add('vbdNguoiTao=' + idngnhan.toString());
  var formData = parts.join('&');
  String url = "/api/ServicesVBDi/XuLyVBDi";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}
Future<String>postHoiBaoVBDi( username,id, ActionXL,thoigian,nguoitheodoi,nam)
async {
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('vbdiThoiHanTraLoi=' + thoigian.toString());
  parts.add('SYear=' + nam.toString());
  parts.add('vbdiNguoiTheoDoiHB=' + nguoitheodoi.toString());
  parts.add('ActionXL=' + ActionXL.toString());

  var formData = parts.join('&');
  String url = "/api/ServicesVBDi/XuLyVBDi";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}
Future<String>postThayTheVB( username,id, ActionXL,nam,noidung,IDThayThe)
async {
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('noiDungYKien=' + noidung.toString());
  parts.add('SYear=' + nam.toString());
  parts.add('vbthaythe=' + IDThayThe.toString());
  parts.add('ActionXL=' + ActionXL.toString());

  var formData = parts.join('&');
  String url = "/api/ServicesVBDi/XuLyVBDi";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}


Future<String>postDaChuyenVB( username,id, ActionXL,vbdiIsSentVanBan)
async {
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('vbdiIsSentVanBan=' + vbdiIsSentVanBan.toString());
  parts.add('ActionXL=' + ActionXL.toString());

  var formData = parts.join('&');
  String url = "/api/ServicesVBDi/XuLyVBDi";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}
Future<String>postCapNhatVB( username,id, ActionXL,vbdiIsSentVanBan)
async {
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('SYear=' + vbdiIsSentVanBan.toString());
  parts.add('ActionXL=' + ActionXL.toString());

  var formData = parts.join('&');
  String url = "/api/ServicesVBDi/XuLyVBDi";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}
