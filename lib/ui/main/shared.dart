// import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';

import 'package:hb_mobile2021/ui/Login/Login.dart';

import '../../core/services/callApi.dart';

 int? tt2;
int? tt4;
int? tt6;
int?  tt8;
bool? isLogin;

String? tokenfirebase;
// SharedPreferences sharedStorage!;
//const  DOMAIN = "http://apimobile2021.ungdungtructuyen.vn";
//const  DOMAIN = "cc";
const  DOMAIN = "https://apimobile.hoabinh.gov.vn";
Timer? _timer;
void logOut(BuildContext context) async {
  sharedStorage = await SharedPreferences.getInstance();
      if(sharedStorage!.get("rememberme")== false) {
        sharedStorage!.remove("password");
        sharedStorage!.remove("expires_in");
        sharedStorage!.remove("token");
         tendangnhapAll = "";
         ten;
         datavb = "";
         vanbandenCapNhat = null;
         trangThaiVB =0;
         vbdiTrangThaiVB =0;
         vbdiCurrentNguoiTrinhID =0;
         vbdiNguoiSoan= "";
         lstPhongBanLaVanThuVBDI= [];
         lstPhongBanLaVanThuVBDEN= [];
         userGroups= [];
         lstThongTinGroup= [];
         ThemMoiVanBanDi= false;
         ThemVanBanDen= false;
         checkThuHoi= false;
         ThietLapHoiBao= false;
         vbdiCanTDHB= false;
         isTrinhKy= false;
         trinhDaCoNgDuyet= false;
         trinhLan2= false;
        isThuHoi= false;
         ChuyenVT= false;
         SiteAction= "";
         userTenTruyCap= "";
         vbdiNguoiSoanID= 0;
         hscvNguoiLap= 0;
         hscvNguoiPhuTrach= 0;
         currentUserID= 0;
         CurrentDonViID= 0;
         ThongTinLConfig=[];
         vbdiNguoiKyID= 0;
         chukyso= 0;
         vbdiNguoiTrinhTiep= "";
         vbdiDSNguoiTrinhTiep=[];
         vbdiNguoiKy= 0;
         hoVaTen = "";
         tenPhongBan = "";
         CurrentTenDonVi = "";
         OrganName = "";
         tick = 0;
         EmailHT = "";
         Telephone = "";
         ngayTrinhDT= "";
         butPheVBD = false;
         thuHoiVBD = false;
         isDuyetVaPhatHanh = false;
         kyVaPhatHanh = false;
         checkKetThucHSCV = false;
         checkSoanVBDT = false;
         checkChuyenVaoHS = false;
         isDuyetTruongPhong = false;
         isDuyet = false;
         XemDB = "";
         hanXLVBD = false;
         vbdTTXuLyVanBanLT= 0;
         isnguoiduyet= 0;
         vbdPhuongThuc= 0;
         vbdTrangThaiXuLyVanBan= 0;
         vbdSoVanBan= 0;
         hscvTrangThaiXuLy= 0;
           currentDuThao;
        vbdiXuatPhatTuHSCV;
         lstvbdUserChuaXuLy = [];
         // strId = [];
         // strVanBanLienQuanID = [];
         // strVanBanDiLienQuan = [];
         vbdiCurrentUserReceived = [];
         vbdUserChuaXuLy = false;
         vbdHanXuLy ="";
         vbdiIsSentVanBan = false;
         isTraCuu = false;
         checkbtnXDB = false;
         CapSoVanBanDi = false;
         vbdIsSentVanBan = false;
         clickChon =  false;
        isGuiVanban =  false;
         GuiVanBanDi = false;
         GuiVanBan = false;
         SuaVanBanDen = false;
        vbdiDSNguoiTrinhTiepKy = false;
         isQTNew = false;
         notIsQuanTriNew = false;
         ispGuiXuLyChinh = false;
         ID=0;
         DonViInSiteID=0;
         userHasQuyenKyVB = [];
         groupID = 0;
         //duthaoXoa = [];
//thêm mới dự thảo
         TrichYeuDT = "";
         loaivbDT =  "";
         vbdiSoKyHieu = "";
        vNguoiKy = "";
         vNguoiTrinh= "";
         toTrinh= "";
         ls="";
         ls1="";
         ls2="";
         messingCN = "";
         matKhauHT = "";
        // dataTT = [];
         vanbanDi ;
         vanbanDen = null ;
         vanbanDT = null ;
         userChucVu = "";
         pdf = "";
         pdfDK = "";
       //  pdf = [];
        // pdfDK = [];
        // pdfPT = [];
         namepdf = "";
         pdfPT = "";
         idCT = "";
         idChuTri = "";
         idPhoiHop = "";
         idTheoDoi = "";
         idNTD = "";
         IDTT ;
        OldID2010 = 0;
        IDGroup = 0;
        ThemMoiVanBanDuThao = false;
         chuaPDF = [];
         tenPDFTruyen ="";
         imageCK ="";
        widthKy = 75.0;
        heightKy = 150.0;
      }
 else{
    sharedStorage!.remove("expires_in");
    sharedStorage!.remove("token");


    tendangnhapAll = "";
    ten;
    datavb = "";
    ThemMoiVanBanDuThao = false;
    vanbandenCapNhat = null;
    trangThaiVB =0;
    vbdiTrangThaiVB =0;
    vbdiCurrentNguoiTrinhID =0;
    vbdiNguoiSoan= "";
    lstPhongBanLaVanThuVBDI= [];
    lstPhongBanLaVanThuVBDEN= [];
    userGroups= [];
    lstThongTinGroup= [];
    ThemMoiVanBanDi= false;
    ThemVanBanDen= false;
    checkThuHoi= false;
    ThietLapHoiBao= false;
    vbdiCanTDHB= false;
    isTrinhKy= false;
    trinhDaCoNgDuyet= false;
    trinhLan2= false;
    isThuHoi= false;
    ChuyenVT= false;
    SiteAction= "";
    userTenTruyCap= "";
    vbdiNguoiSoanID= 0;
    hscvNguoiLap= 0;
    hscvNguoiPhuTrach= 0;
    currentUserID= 0;
    CurrentDonViID= 0;
    ThongTinLConfig=[];
    vbdiNguoiKyID= 0;
    chukyso= 0;
    vbdiNguoiTrinhTiep= "";
    vbdiDSNguoiTrinhTiep=[];
    vbdiNguoiKy= 0;
    hoVaTen = "";
    tenPhongBan = "";
    CurrentTenDonVi = "";
    OrganName = "";
    tick = 0;
    EmailHT = "";
    Telephone = "";
    ngayTrinhDT= "";
    butPheVBD = false;
    thuHoiVBD = false;
    isDuyetVaPhatHanh = false;
    kyVaPhatHanh = false;
    checkKetThucHSCV = false;
    isGuiVanban = false;
    checkSoanVBDT = false;
    checkChuyenVaoHS = false;
    isDuyetTruongPhong = false;
    isDuyet = false;
    XemDB = "";
    hanXLVBD = false;
    vbdTTXuLyVanBanLT= 0;
    isnguoiduyet= 0;
    vbdPhuongThuc= 0;
    vbdTrangThaiXuLyVanBan= 0;
    vbdSoVanBan= 0;
    hscvTrangThaiXuLy= 0;
    currentDuThao;
    vbdiXuatPhatTuHSCV;
    lstvbdUserChuaXuLy = [];
    // strId = [];
    // strVanBanLienQuanID = [];
    // strVanBanDiLienQuan = [];
    vbdiCurrentUserReceived = [];
    vbdUserChuaXuLy = false;
    vbdHanXuLy ="";
    vbdiIsSentVanBan = false;
    isTraCuu = false;
    checkbtnXDB = false;
    CapSoVanBanDi = false;
    vbdIsSentVanBan = false;
    clickChon =  false;
    GuiVanBanDi = false;
    GuiVanBan = false;
    SuaVanBanDen = false;
    vbdiDSNguoiTrinhTiepKy = false;
    isQTNew = false;
    notIsQuanTriNew = false;
    ispGuiXuLyChinh = false;
    ID=0;
    DonViInSiteID=0;
    userHasQuyenKyVB = [];
    IDGroup = 0;
    groupID = 0;
    //duthaoXoa = [];
//thêm mới dự thảo
       TrichYeuDT = "";
       loaivbDT =  "";
       vbdiSoKyHieu = "";
        vNguoiKy= "";
       vNguoiTrinh= "";
       toTrinh= "";
       ls="";
       ls1="";
       ls2="";
       messingCN = "";
       matKhauHT = "";
       // dataTT = [];
       vanbanDi ;
       vanbanDen = null ;
       vanbanDT = null ;
       userChucVu = "";
       pdf = "";
       pdfDK = "";
       //  pdf = [];
       // pdfDK = [];
       // pdfPT = [];
       namepdf = "";
       pdfPT = "";
       idCT = "";
       idChuTri = "";
       idPhoiHop = "";
       idTheoDoi = "";
       idNTD = "";
        OldID2010 = 0;
       IDTT ;
       chuaPDF = [];
       tenPDFTruyen ="";
        imageCK ="";
        widthKy = 75.0;
        heightKy = 150.0;
    // FirebaseMessaging.instance.unsubscribeFromTopic("truyenthong_all");
  }
 // Get.off(LoginWidget());

  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
      builder: (BuildContext context) => LoginWidget()), (Route<dynamic> route) => false);

}



lengthDuthao(BuildContext context,  path)async{
  var url = Uri.parse(DOMAIN + path);
  List duthao = [];
  sharedStorage = await SharedPreferences.getInstance();
  String? token = sharedStorage!.get("token") as String?;
 var  response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer ' + token!
      }
  );
  if (response.statusCode == 200) {
    var items = json.decode(response.body)['OData'];
       duthao = items;
  } else if(response.statusCode == 401){
    await showAlertDialog(context, "Phiên đăng nhập đã hết hạn \n Vui lòng thử lại");
    logOut(context);
  }
  return duthao.length;
}

double autoTextSize(double textSize, double textScaleFactor) {
  return textScaleFactor != 1.0 ? textSize / textScaleFactor : textSize;
}