

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'dart:convert';

import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';

Map<int, String> lstUsers = new Map<int, String>();
String str="" ;
List<int>strID =new List<int>();


Future<String> getDataByKeyWordVBDen(String TenDangNhap,String ActionXL,
    String text, String year,query) async {
  var url = "/api/ServicesVBD/GetData";
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
Future<String> getDataByKeyYearVBDen(String TenDangNhap,String ActionXL,
    String year,query,int skip, int pageSize, ) async {
  var url = "/api/ServicesVBD/GetData";
  var parts = [];
  parts.add('TenDangNhap=' + TenDangNhap.toString());
  parts.add('ActionXL=' + ActionXL.toString());
  parts.add('skip=' + skip.toString());
  parts.add('pagesize=' + pageSize.toString());
  parts.add('Yearvb=' + year);
    parts.add( query.toString());
  var formData = parts.join('&');
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}

Future<String> getDataByCreatedVBDen(String created) async {
  var url = "/api/ServicesVBDss/GetData";
  var parts = [];
  parts.add(created);
  var formData = parts.join('&');
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}
Future<String> getDataVBDen(int skip, int pageSize, String ActionXL, String year) async {
  //String url = "/vbden/GetAllVBDen";
  String url = "/api/ServicesVBD/GetData";
  var parts = [];
  parts.add('ActionXL=' + ActionXL.toString());
  parts.add('skip=' + skip.toString());
  parts.add('pagesize=' + pageSize.toString());
  parts.add('Yearvb=' + year);
  var formData = parts.join('&');
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}
// Future<String> getDataHomeVBDen( String ActionXL,String query, String year) async {
//   //String url = "/vbden/GetAllVBDen";
//   String url = "/api/ServicesVBD/GetData";
//   var parts = [];
//   //parts.add('TenDangNhap=' + name.toString());
//   parts.add('ActionXL=' + ActionXL.toString());
//   parts.add(query);
//   parts.add('Yearvb=' + year);
//   var formData = parts.join('&');
//   var response = await responseDataPost(url, formData);
//   if (response.statusCode == 200) {
//     var items = response.body;
//     return items;
//   }
// }
Future<String> getDataLeftVBDen(int skip, int pageSize, String ActionXL,
    String query,String nam,int skipquey) async {
  String url = "/api/ServicesVBD/GetData";
  var parts = [];
  parts.add('ActionXL=' + ActionXL.toString());
  parts.add('skip=' + skipquey.toString());
  parts.add('take=20');
  parts.add('page=' + skip.toString());
  parts.add('pagesize=' + pageSize.toString());
  parts.add('Yearvb=' + nam);
  parts.add('GriSort=[{ field: "vbdNgayDen", dir: "false" }, { field: "vbdSoVanBan", dir: "false" }, { field: "vbdYear", dir: "false" }]');
  parts.add(query);
  var formData = parts.join('&');
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}
Future<String> getDataHomeVBDen(int skip, int pageSize, String ActionXL,String query) async {
  String url = "/api/ServicesVBD/GetData";
  var parts = [];
  parts.add('ActionXL=' + ActionXL.toString());
  parts.add('skip=' + skip.toString());
  parts.add('pagesize=' + pageSize.toString());
  parts.add(query);
  var formData = parts.join('&');
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}
Future<String> getDataCVBD(String username,String ActionXL) async {
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ActionXL=' + ActionXL);
  var formData = parts.join('&');
  String url = "/api/ServicesVBD/GetData";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}
Future<String> getDataCVBDen(String username,String ActionXL,int parentID,
    int nam)
async {
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('SYear=' + nam.toString());
  parts.add('parentID=' + parentID.toString());
  var formData = parts.join('&');
  String url = "/api/ServicesVBD/GetData";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}

Future<String> getDataCVBD1(String ActionXL) async {
  var parts = [];
  parts.add('ActionXL=' + ActionXL);
  var formData = parts.join('&');
  String url = "/api/ServicesVBD/GetData";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}
Future<String> TuChoiDongy(int id,String ActionXL,int year,String ykthuhoi,String hanhdong) async {
  var parts = [];
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('SYear=' + year.toString());
  parts.add('noiDungYKien=' + ykthuhoi);
  parts.add('hanhdong=' + hanhdong);
  var formData = parts.join('&');
  String url = "/api/ServicesVBD/XuLyVBDen";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}
Future<String> getLich(String ActionXL,nam,week,IDLD) async {
  var parts = [];
  parts.add('ActionXL=' + ActionXL);
  parts.add('p_year=' + nam);
  parts.add('p_week=' + week);
  parts.add('LanhDaoID=' + IDLD);
  var formData = parts.join('&');
  String url = "/api/ServicesVBD/GetData";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    print(" list danh sách :"+ items);
    return items;

  }
}
Future<String> getDataTreeDT(String username,String ActionXL,String group) async {
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('groupID=' + group);
  var formData = parts.join('&');
  String url = "/api/ServicesVBD/GetData";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}

Future<String> getDataHoTro(String ActionXL,String username,int id,namVB)
async {

  if(namVB == null){
    DateTime now = DateTime.now();
    namVB =  DateFormat('yyyy').format(now) ;
  }


  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('isYKienHoTro=true' );
  parts.add('sYear=' + namVB );
  parts.add('IdUser=' + id.toString());
  var formData = parts.join('&');
  String url = "/api/ServicesVBD/GetData";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}
Future<String> getDataCB(String username,String ActionXL,ItemID, daidien) async {
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('ItemID=' + ItemID.toString());
  parts.add('daidien=' + daidien);
  var formData = parts.join('&');
  String url = "/api/ServiceUser/ActionXuLy";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}

Future<String> postChuyenTT(int id,String ActionXL,int nam) async {
  var parts = [];
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('SYear=' + nam.toString());
  var formData = parts.join('&');
  String url = "/api/ServicesVBD/GetData";
  var response = await responseDataPostVBDen(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}
Future<String> GetHomeThuHoi(String ActionXL,int nam,int id) async {
  var parts = [];
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('SYear=' + nam.toString());
  var formData = parts.join('&');
  String url = "/api/ServicesVBD/GetData";
  var response = await responseDataPostVBDen(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}

Future<String> postKySimDi(int id,String ActionXL,String nam,toaDoX,toDoY,
    linkpdf,
    page,namefile)
async {
  if(nam == null){
    DateTime now = DateTime.now();
    nam =  DateFormat('yyyy').format(now) ;
  };

  var parts = [];
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('relX=' + toaDoX.toString());
  parts.add('relY=' + toDoY.toString());
  parts.add('pdfpage=' + page.toString());
  parts.add('urlfile=' + linkpdf.toString());
  parts.add('SYear=' + nam.toString());
  parts.add('namefile=' + namefile.toString());
  var formData = parts.join('&');
  String url ="/api/ServicesVBDi/XuLyVBDi";
  var response = await responseDataPostVBDen(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}

Future<String> postKySimOKDi(int id,String ActionXL,String nam,namefile,nameMoi,
    linkpdf)
async {
  if(nam == null){
    DateTime now = DateTime.now();
    nam =  DateFormat('yyyy').format(now) ;
  };
  var parts = [];
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('SYear=' + nam.toString());
  parts.add('lstFileSign=[{"NameRemove": "$namefile","Name":"$nameMoi","Url":"$linkpdf"}]');
  var formData = parts.join('&');
  String url = "/api/ServicesVBDi/XuLyVBDi";
  var response = await responseDataPostVBDen(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}

 postKySim(int id,String ActionXL,String nam,String _x, String _y,String
witdh, String height,
     linkpdf,
   int page,namefile)

async {

  if(nam == null){
    DateTime now = DateTime.now();
    nam =  DateFormat('yyyy').format(now) ;
  };
var pagesize =  page +1;

  var parts = [];
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('relX=' + _x.toString());
  parts.add('relY=' + _y.toString());
  parts.add('width=' + witdh.toString());
  if(pagesize>1){
    parts.add('height=' + (height+"30").toString());
  }
  else{
    parts.add('height=' + height.toString());
  }

  parts.add('pdfpage=' + pagesize.toString());
  parts.add('urlfile=' + linkpdf.toString());
  parts.add('SYear=' + nam.toString());
  parts.add('namefile=' + namefile.toString());
  var formData = parts.join('&');
  String url = "/api/ServicesVBDT/XuLyDuThao";
  var response = await responseDataPostVBDen(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
  else{

    Get.defaultDialog(

            title:"Thông báo",
        middleText:"Xác thực không thành công!"
    );
    EasyLoading.dismiss();
  }
}

postKySimkky(int id,String ActionXL,nam,String tenPdf
)

async {

  if(nam == null){
    DateTime now = DateTime.now();
    nam =  DateFormat('yyyy').format(now) ;
  };


  var parts = [];
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('SYear=' + nam.toString());
  parts.add('fileTrinhKy=' + tenPdf.toString());
  var formData = parts.join('&');
  // final formData = {
  //   "ItemID":'$id',
  //   "ActionXL":'$ActionXL',
  //   "SYear":'$nam',
  //   "fileTrinhKy":'$tenPdf',
  // };
  String url = "/api/ServicesVBDT/XuLyDuThao";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}

Future<String> postKySimOK(int id,String ActionXL,String nam,namefile,nameMoi,
    linkpdf)
async {
  if(nam == null){
    DateTime now = DateTime.now();
    nam =  DateFormat('yyyy').format(now) ;
  };
  var parts = [];
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('SYear=' + nam.toString());
  parts.add('lstFileSign=[{"NameRemove": "$namefile","Name":"$nameMoi","Url":"$linkpdf"}]');
  var formData = parts.join('&');
  String url = "/api/ServicesVBDT/XuLyDuThao";
  var response = await responseDataPostVBDen(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}
Future<String> postKySimOKKy(int id,String ActionXL,String nam,namefile)
async {
  if(nam == null){
    DateTime now = DateTime.now();
    nam =  DateFormat('yyyy').format(now) ;
  };
  var parts = [];
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('SYear=' + nam.toString());
  parts.add('urlFile=' + namefile.toString());
  var formData = parts.join('&');
  String url = "/api/ServicesVBDT/XuLyDuThao";
  var response = await responseDataPostVBDen(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}
Future<String> getDataSoCV(String ActionXL, String DonVi,int  Yearvb) async {
  if(Yearvb == null){
    DateTime now = DateTime.now();
    Yearvb =   int. parse(DateFormat('yyyy').format(now));
  };
  var parts = [];
  parts.add('socvLoaiVanBan=1&LoaiSo=Văn bản đến&pageSize=40');
  parts.add('ActionXL=' + ActionXL);
  parts.add('SYear=' + Yearvb.toString());
  //parts.add('ListName=' + ListName);
  parts.add('DonViLookup=' + DonVi);
  var formData = parts.join('&');
  String url = "/api/ServicesVBD/GetData";
  var response = await responseDataPostVBDen(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}
Future<String> GetSoHoSo(String ActionXL, int  Yearvb,) async {
  if(Yearvb == null||Yearvb ==0){
    DateTime now = DateTime.now();
    Yearvb =   int. parse(DateFormat('yyyy').format(now));
  };
  var parts = [];
  parts.add('ActionXL=' + ActionXL);
  parts.add('SYear=' + Yearvb.toString());
 parts.add('page=0&pageSize=1&FieldSort=SoHoSo&FieldOption=false');

  var formData = parts.join('&');
  String url = "/api/ServicesHSCV/GetData";
  var response = await responseDataPostVBDen(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}
Future<String> GetNuma(String ActionXL, String id,int  Yearvb) async {
  if(Yearvb == null){
    DateTime now = DateTime.now();
    Yearvb =   int. parse(DateFormat('yyyy').format(now));
  };
  var parts = [];
  parts.add('ActionXL=' + ActionXL);
  parts.add('SYear=' + Yearvb.toString());
  //parts.add('ListName=' + ListName);
  parts.add('SoCongVan=' + id);
  var formData = parts.join('&');
  String url = "/api/ServicesVBD/GetData";
  var response = await responseDataPostVBDen(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}
Future<String> LVB(String ActionXL, String DonVi,int  Yearvb) async {
  if(Yearvb == null){
    DateTime now = DateTime.now();
    Yearvb =   int. parse(DateFormat('yyyy').format(now));
  };
  var parts = [];
  parts.add('LoaiVB=vbden');
  //parts.add('LoaiVB=vbden&pageSize=40');
  parts.add('ActionXL=' + ActionXL);
  parts.add('SYear=' + Yearvb.toString());
  //parts.add('ListName=' + ListName);
  parts.add('DonViLookup=' + DonVi);
  var formData = parts.join('&');
  String url = "/api/ServicesVBD/GetData";
  var response = await responseDataPostVBDen(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}
Future<String> APIDoMat(String ActionXL, String DonVi,int  Yearvb) async {
  if(Yearvb == null){
    DateTime now = DateTime.now();
    Yearvb =   int. parse(DateFormat('yyyy').format(now));
  };
  var parts = [];
  parts.add('tinhchatLoaiTinhChatVB=Văn bản mật&pageSize=40');
  parts.add('ActionXL=' + ActionXL);
  parts.add('SYear=' + Yearvb.toString());
  //parts.add('ListName=' + ListName);
  parts.add('DonViLookup=' + DonVi);
  var formData = parts.join('&');
  String url = "/api/ServicesVBD/GetData";
  var response = await responseDataPostVBDen(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}
Future<String> APICQBH(String ActionXL, int  Yearvb, String key) async {
  if(Yearvb == null){
    DateTime now = DateTime.now();
    Yearvb =   int. parse(DateFormat('yyyy').format(now));
  };
  var parts = [];
  parts.add('ActionXL=' + ActionXL);
  parts.add('SYear=' + Yearvb.toString());
 // parts.add('pageSize=50');
  parts.add('Keyword=' + key);

  var formData = parts.join('&');
  String url = "/api/ServicesVBD/GetData";
  var response = await responseDataPostVBDen(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}
Future<String> APIDoKhan(String ActionXL, String DonVi,int  Yearvb) async {
  if(Yearvb == null){
    DateTime now = DateTime.now();
    Yearvb =   int. parse(DateFormat('yyyy').format(now));
  };
  var parts = [];
  parts.add('tinhchatLoaiTinhChatVB=Văn bản khẩn');
  parts.add('ActionXL=' + ActionXL);
  parts.add('pageSiz=40');
  parts.add('SYear=' + Yearvb.toString());
  //parts.add('ListName=' + ListName);
  parts.add('DonViLookup=' + DonVi);
  var formData = parts.join('&');
  String url = "/api/ServicesVBD/GetData";
  var response = await responseDataPostVBDen(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}


Future<String> getDataDetailVBDen(int id,String ActionXL,String ListName, int
Yearvb) async {
  if(Yearvb == null){
    DateTime now = DateTime.now();
    Yearvb =   int. parse(DateFormat('yyyy').format(now));
  };
  var parts = [];
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('SYear=' + Yearvb.toString());
  //parts.add('ListName=' + ListName);
  parts.add('SitesColection=' + ListName);
  var formData = parts.join('&');
  String url = "/api/ServicesVBD/GetData";
  var response = await responseDataPostVBDen(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}
Future<String>postGiaoViecVBD(
    String ActionXL,
    String TenDangNhap,
    int SYear,
        String   tenCV,
String soDen,
    String chuGiai,String dateControllerBD
    , dateController,
thoiHanBaoQuan,ngonNgu,
idCDSD,idLV
,idMD,tongSoVB,soLuongTo,
soLuongTrang,
kyHieuThongTin,
tinhTrangVL,tuKhoa,
idCT,idNTD,idChuTri,idPhoiHop,
idTheoDoi,hscvXuatPhatTuVanBan
    )
async {



  if(SYear == null){
    DateTime now = DateTime.now();
    SYear =   int. parse(DateFormat('yyyy').format(now));
  };
  var parts = [];
  parts.add('ActionXL=' + ActionXL);
  parts.add('hscvIsCongViec=true');
  parts.add('TenDangNhap=' + TenDangNhap);
  parts.add('Title=' + tenCV);
  parts.add('SoHoSo=' + soDen);
  parts.add('SYear=' + SYear.toString());
  parts.add('hscvNoiDungXuLy=' + chuGiai.toString());
  parts.add('hscvNgayMoHoSo=' + dateControllerBD.toString());
  parts.add('hscvHanXuLy=' + dateController.toString());
  parts.add('ThoiHanBaoQuan=' + thoiHanBaoQuan.toString());
  parts.add('NgonNgu=' + ngonNgu.toString());
  parts.add('hscvLinhVuc=' + idLV.toString());
  parts.add('CheDoSuDung=' + idCDSD.toString());
  parts.add('strMucDo=' + idMD.toString());
  parts.add('TongVB=' + tongSoVB.toString());
  parts.add('SoTo=' + soLuongTo.toString());
  parts.add('SoTrang=' + soLuongTrang.toString());
  parts.add('KyHieuThongTin=' + kyHieuThongTin.toString());
  parts.add('TinhTrangVatLy=' + tinhTrangVL.toString());
  parts.add('TuKhoa=' + tuKhoa.toString());
  //parts.add('listValueFileAttach: [{"FileServer": "89ac65dd-00df-4268-ba02-c'
  //'cc44a1d6b1e.pdf","FileName": "Binder1.pdf"}]');
  parts.add('userPT=' + idCT.toString());
  parts.add('userTD=' + idNTD.toString());
  parts.add('pbPT=' + idChuTri.toString());
  parts.add('pbPH=' + idPhoiHop.toString());
  parts.add('pbTD=' + idTheoDoi.toString());
  parts.add('hscvXuatPhatTuVanBan=' + hscvXuatPhatTuVanBan.toString());


  var formData = parts.join('&');

  String url ="/api/ServicesHSCV/GetData";
  var response = await responseDataPost(url, formData);

  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}

Future<String>postSuaVBD(
    String ActionXL,
    String id,
    String TenDangNhap,
    int SYear,
    String vbdSoCongVanLookup,
    String vbdSoVanBan,
    String vbdLoaiVanBan,
    String vbdNgayDen,
    String vbdSoKyHieu,
    String vbdNgayBanHanh,
    String vbdTrichYeu,
    String vbdCoQuanBanHanh,
    String vbdGhiChu,
    String vbdDoKhan,
    String vbdDoMat,
    int IDNK,
    int ChucVuNKID,
    String vbdMaDinhDanhVB
    )
async {
  if(vbdSoVanBan == null)
    {
      vbdSoVanBan="";
    }

  if(vbdNgayDen == null){
    vbdNgayDen="";
  }

  if(vbdSoKyHieu == null){
    vbdSoKyHieu="";
  }

  if(vbdNgayBanHanh == null){
    vbdNgayBanHanh="";
  }

  if(vbdTrichYeu == null){
    vbdTrichYeu="";
  }

  if(vbdGhiChu == null){
    vbdGhiChu="";
  }

if(IDNK == null){
  IDNK=0;
}

if(ChucVuNKID == null){
  ChucVuNKID=0;
}

if(vbdMaDinhDanhVB == null){
  vbdMaDinhDanhVB="";
}




if(vbdSoVanBan == null){
  vbdSoVanBan="";
}

if(vbdSoCongVanLookup == null){
  vbdSoCongVanLookup="";
}

if(vbdLoaiVanBan == null){
  vbdLoaiVanBan="";
}

if(vbdCoQuanBanHanh == null){
  vbdCoQuanBanHanh="";
}

if(vbdDoKhan == null){
  vbdDoKhan="";
}

if(vbdDoMat == null){
  vbdDoMat="";
}

  if(SYear == null){
    DateTime now = DateTime.now();
    SYear =   int. parse(DateFormat('yyyy').format(now));
  };
  var parts = [];
  parts.add('ActionXL=' + ActionXL);
  parts.add('ItemID=' + id);
  parts.add('TenDangNhap=' + TenDangNhap);
  parts.add('SYear=' + SYear.toString());
  parts.add('vbdSoCongVanLookup=' + vbdSoCongVanLookup);
  parts.add('vbdSoVanBan=' + vbdSoVanBan);
  parts.add('vbdLoaiVanBan=' + vbdLoaiVanBan);
  parts.add('vbdNgayDen=' + vbdNgayDen);
  parts.add('vbdTrichYeu=' + vbdTrichYeu);
  parts.add('vbdSoKyHieu=' + vbdSoKyHieu);
  parts.add('vbdCoQuanBanHanh=' + vbdCoQuanBanHanh);
  parts.add('vbdNgayBanHanh=' + vbdNgayBanHanh);
  parts.add('vbdChucVuNguoiKy=' + ChucVuNKID.toString());
  parts.add('vbdGhiChu=' + vbdGhiChu);
  parts.add('vbdDoKhan=' + vbdDoKhan);
  parts.add('vbdDoMat=' + vbdDoMat);
  parts.add('vbdNguoiKyVB=' + IDNK.toString());
  parts.add('vbdMaDinhDanhVB=' + vbdMaDinhDanhVB.toString());

  var formData = parts.join('&');

  String url = "/api/ServicesVBD/GetData";
  var response = await responseDataPost(url, formData);

  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}

Future postXuLyXongVBD( username,id, ActionXL,  noidungykien ,nam) async {
  if(nam == "null")
    {
      DateTime now = DateTime.now();
      nam = DateFormat('yyyy').format(now);
    }

  var response = null;
  String url = "";
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('postData=$id|$nam');
  parts.add('ActionXL=' + ActionXL);
  //parts.add('SYear=' + nam.toString());
  parts.add('noiDungYKien=' + noidungykien);
  var formData = parts.join('&');
  url = "/api/ServicesVBD/GetData";

  response = await responseDataPost(url, formData);
  // showLoading();
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }


}
Future postHoTro(String ActionXL,String username,String NoiDung,String Email,
    String
    SDT)
async {
  int nam =2021;
  DateTime now = DateTime.now();
  nam =  int.parse(DateFormat('yyyy').format(now)) ;
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ActionXL=' + ActionXL.toString());
  parts.add('SYear=' + nam.toString());
  parts.add('noiDungYKien=' + NoiDung.toString());
  parts.add('isYKienHoTro=true');
  parts.add('mailNguoiDungTXT=' + Email.toString());
  parts.add('sdtNguoiDungTXT=' + SDT.toString());
  var formData = parts.join('&');
  String url = "/api/ServicesVBD/XuLyVBDen";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}
Future postTuCHoiVBD( username,id, ActionXL,  noidungykien,int nam) async {
  // DateTime now = DateTime.now();
  // String Yearvb = DateFormat('yyyy').format(now);
  var response = null;
  String url = "";
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('SYear=' + nam.toString());
  parts.add('YKienTuChoi=' + noidungykien);
  var formData = parts.join('&');
  url = "/api/ServicesVBD/GetData";

  response = await responseDataPost(url, formData);
  // showLoading();
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }


}
Future postYKienVBD( username,id, ActionXL,  noidungykien,nam) async {
  if(nam == "null")
  {
    DateTime now = DateTime.now();
    nam = DateFormat('yyyy').format(now);
  }
  var response = null;
  String url = "";
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('SYear=' + nam.toString());
  parts.add('noiDungYKien=' + noidungykien);
  var formData = parts.join('&');
  url = "/api/ServicesVBD/GetData";

  response = await responseDataPost(url, formData);
    // showLoading();
    if (response.statusCode == 200) {
      var items = response.body;
      return items;
    }


}
Future<String>postHanXuLyVBD( username,id, ActionXL, String noidungykien,int
nam) async {
  // DateTime now = DateTime.now();
  // String Yearvb = DateFormat('yyyy').format(now);
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL);
  parts.add('vbdHanXuLyMB=' + noidungykien);
  parts.add('SYear=' + nam.toString());
  var formData = parts.join('&');
  String url = "/api/ServicesVBD/GetData";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}

Future<String> getButPheDataVBDen(String username,int id,String ActionXL) async {
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL.toString());
  var formData = parts.join('&');
  String url = "/api/ServicesVBD/GetData";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}

Future<String> getYkienDataVBDen(int id,String ActionXL,
    int nam)
async {

  if(nam == null){
    DateTime now = DateTime.now();
    nam =  int. parse(DateFormat('yyyy').format(now)) ;
  };
  var parts = [];
  // parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL.toString());
  parts.add('SYear=' + nam.toString());
  var formData = parts.join('&');
  String url = "/api/ServicesVBD/GetData";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}
Future<String>postChuyenVBD( username,id, ActionXL,CBChon,UserXDB,XuLyChinh,PH,selectChechbox,
YKien,int nam,lstUserPT)
async {
  var parts = [];
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL.toString());
  parts.add('userChoosen=' + CBChon.toString());
  parts.add('userXemDB=' + UserXDB.toString());
  parts.add('userRadioPT=' + lstUserPT.toString());
  parts.add('userRadioXLC=' + XuLyChinh.toString());
  // parts.add('selectRadioXLVB=' + PH.toString());
  // parts.add('selectCheckbox=' + selectChechbox.toString());
  parts.add('YKienNguoiChuyen=' + YKien.toString());
  parts.add('SYear=' + nam.toString());
  var formData = parts.join('&');
  String url = "/api/ServicesVBD/XuLyVBDen";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}
Future<String>postChuyenNhanhVBD( username,id, ActionXL,CBChon,tti,
    ttPH,ttXDB
,int nam)
async {
  var parts = [];
   if(CBChon != null){

   }
  parts.add('TenDangNhap=' + username.toString());
  parts.add('ItemID=' + id.toString());
  parts.add('ActionXL=' + ActionXL.toString());
  if(CBChon != null) {
    parts.add('userChoosen=' + CBChon.toString());
  }
  if(tti != null) {
    parts.add('selectRadioPT=' + tti.toString());
  }
  if(ttPH != null) {  parts.add('selectRadioPH=' + ttPH.toString());}
  if(ttXDB != null) {  parts.add('selectRadioXDB=' + ttXDB.toString());}
  parts.add('SYear=' + nam.toString());
  parts.add('dv=2');
  var formData = parts.join('&');
  String url = "/api/ServicesVBD/XuLyVBDen";
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = response.body;
    return items;
  }
}
