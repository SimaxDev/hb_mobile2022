import 'dart:convert';
import 'package:intl/intl.dart';




class VanBanDenJson {
  //properties
  int ID;
  String Title;
  String LoaiVanBan;
  String ChucVuNK;
  String SoKyHieu;
  String TrichYeu;
  String SoDen;
  String CoQuanBanHanh;
  String NgayDen;
  String NgayVaoSo;
  String CBXuLy;
  String CBPhoiHop;
  String DoKhan;
  String NguoiKy;
  String MaDinhDanhDonVi;
  String DoMat;
  String XuLyChinh;
  String PhuTrach;
  String NgayBanHanh;
  String MaDinhDanhVB;
  String CBXemDeBiet;
  String VBNhanLT;
  String ThoiGianNhan;
  String CBPhuTrach;
  String strUserPH;
  String CBChuaXuLy;
  String yKienThuHoi;
  bool ThuHoi;
  bool checkThuHoi1;
  String UserChuaXL;
  int vbdTTXuLyVBLT;
  int vbdPT;
  bool vbdIsSentVB;
  bool checkbtnXDB1;
  int vbdSVB;
  int ChucVuNKID;
  int NguoiKyID;
  int vbdTrangThaiXuLyVanBan;
  List UserChuaXLID;
  String LogxulyText;
  String NhanVB;
  String HanXL;
  List pdf1;
  var vanbandenCapNhat;
  int vbdPhongBanPT;
  int vbdNguoiDungPT;
  int vbdUserXuLyC;



 VanBanDenJson(
     {
       this.ID,
       this.Title,
       this.LoaiVanBan,
       this.SoKyHieu,
       this.TrichYeu,
       this.SoDen,
       this.CoQuanBanHanh,
       this.NgayDen,
       this.NgayVaoSo,
       this.CBXuLy,
       this.CBPhoiHop,
       this.DoKhan,
       this.NguoiKy,
       this.NguoiKyID,
       this.vanbandenCapNhat,
       this.MaDinhDanhDonVi,
       this.DoMat,
       this.XuLyChinh,
       this.PhuTrach,
       this.NgayBanHanh,
       this.MaDinhDanhVB,
       this.CBXemDeBiet,
       this.CBChuaXuLy,
       this.CBPhuTrach,
       this.ThoiGianNhan,
       this.VBNhanLT,
       this.ThuHoi,
       this.checkThuHoi1,
       this.UserChuaXL,
       this.vbdTTXuLyVBLT,
       this.vbdPT,
       this.vbdSVB,
       this.vbdIsSentVB,
       this.UserChuaXLID,
       this.LogxulyText,
       this.NhanVB,
       this.checkbtnXDB1,
       this.vbdTrangThaiXuLyVanBan,
       this.HanXL,
       this.yKienThuHoi,
       this.ChucVuNK,
       this.ChucVuNKID,
       this.pdf1,
       this.vbdPhongBanPT,
       this.vbdNguoiDungPT,
       this.vbdUserXuLyC,
       this.strUserPH,

});
 //factory convert json['vanBanDen'] to model
  factory VanBanDenJson.fromJson(Map<String, dynamic> json) {
  return  VanBanDenJson(
        TrichYeu:  json['vanBanDen']['vbdTrichYeu']?? "",
    vanbandenCapNhat:  json['vanBanDen']['vanbandenCapNhat'],
       NguoiKy: json['vanBanDen']['vbdNguoiKyVB']!= null &&json['vanBanDen']['vbdNguoiKyVB'].length > 0 ?
    json['vanBanDen']['vbdNguoiKyVB'][0]['LookupValue']as String: "",
    NguoiKyID: json['vanBanDen']['vbdNguoiKyVB']!= null &&json['vanBanDen']['vbdNguoiKyVB'].length > 0 ?
    json['vanBanDen']['vbdNguoiKyVB'][0]['LookupId']:0,
       CBPhoiHop:  json['vanBanDen']['strUserPH'] != null ?
       json['vanBanDen']['strUserPH']  :"",
       MaDinhDanhDonVi: json['vanBanDen']['strMDDDonVi'] != null ? json['vanBanDen']['strMDDDonVi'] :"",
        MaDinhDanhVB:  json['vanBanDen']['vbdMaDinhDanhVB'] != null ? json['vanBanDen']['vbdMaDinhDanhVB'] :"",
       CoQuanBanHanh: json['vanBanDen']['vbdCoQuanBanHanh']!=
           null&&json['vanBanDen']['vbdCoQuanBanHanh']['LookupValue'] != null
           ?json['vanBanDen']['vbdCoQuanBanHanh']['LookupValue'] :"",
       ID: json['vanBanDen']['ID']!=null?json['vanBanDen']['ID']:0,
        LoaiVanBan: json['vanBanDen']['vbdLoaiVanBan']!=null&&json['vanBanDen']['vbdLoaiVanBan']['LookupV'
            'alue']!= null ?json['vanBanDen']['vbdLoaiVanBan']['LookupV'
            'alue']:"",
        SoKyHieu: json['vanBanDen']['vbdSoKyHieu']!=null?json['vanBanDen']['vbdSoKyHieu'] :"",
         DoKhan: json['vanBanDen']['vbdDoKhan']!=null&&json['vanBanDen']['vbdDoKhan']['LookupValue']!=null ?json['vanBanDen']['vbdDoKhan']['LookupValue']:"",
        DoMat: json['vanBanDen']['vbdDoMat']!=null&&json['vanBanDen']['vbdDoMat']['LookupValue']!=null
            ?json['vanBanDen']['vbdDoMat']['LookupValue']:
            "",
       //  SoDen: json['vanBanDen']['vbdSoVanBan'] ?? "",
        NgayDen:json['vanBanDen']['vbdNgayDen']!=null? DateFormat('dd-MM-yyyy')
        .format
          (DateFormat
          ('yyyy-MM-dd').parse(json['vanBanDen']['vbdNgayDen'])):"",
       NgayVaoSo:json['vanBanDen']['vbdHanXuLy'] != null ? DateFormat('dd-MM-yyyy')
          .format(DateFormat('yyyy-MM-dd').parse(json['vanBanDen']['vbdHanXuLy'])):"",
     NgayBanHanh: json['vanBanDen']['vbdNgayBanHanh']!=null?DateFormat('dd-MM-yyyy')
            .format(DateFormat('yyyy-MM-dd').parse(json['vanBanDen']['vbdNgayBanHanh'])):"",
    XuLyChinh: json['vanBanDen']['vbdNguoiDungPT_x003a_Title']!=null&&json['vanBanDen']
    ['vbdNguoiDungPT_x003a_Title']['LookupValue']!=null?json['vanBanDen']['vbdNguoiDungPT_x003a_Title']['LookupValue'] : "",
      CBXemDeBiet: json['vanBanDen']['userXDB']!=null? json['vanBanDen']['userXDB']: "",
    yKienThuHoi: json['vanBanDen']['yKienThuHoi'] != null ? json['vanBanDen']['yKienThuHoi'] : "",
    ThuHoi: json['vanBanDen']['vbdIsSentVanBan'] != null ? json['vanBanDen']['vbdIsSentVanBan'] : false,
    CBChuaXuLy: json['vanBanDen']['strUserChuaXl'] != null ?
    json['vanBanDen']['strUserChuaXl'] :"",
      CBPhuTrach:json['vanBanDen']['vbdUserXuLyC']!=null&&json['vanBanDen']['vbdUserXuLyC']['LookupValu'
          'e']!=null?json['vanBanDen']['vbdUserXuLyC']['LookupValu'
          'e']:"",
      ThoiGianNhan:json['vanBanDen']['Created']!=null?DateFormat('dd-MM-yyyy')
          .format(DateFormat('yyyy-MM-dd').parse(json['vanBanDen']['Created'])):"",
   UserChuaXL:json['vanBanDen']['vbdUserChuaXuLy']!=null&& json['vanBanDen']['vbdUserChuaXuLy'].length >
       0 ?
   json['vanBanDen']['vbdUserChuaXuLy'][0]['LookupValue'].toString() :"",
    UserChuaXLID: json['vanBanDen']['vbdUserChuaXuLy']!=null?json['vanBanDen']['vbdUserChuaXuLy']:[],
   //      .length > 0 ?
   // json['vanBanDen']['vbdUserChuaXuLy'][0]['LookupId'] :0,
    LogxulyText: json['vanBanDen']['LogxulyText'] == null ? "" : json['vanBanDen']['LogxulyText'],

    VBNhanLT:"",
      NhanVB:json['vanBanDen']['strNoiNhan'] == null ? "" : json['vanBanDen']['strNoiNhan'],
      vbdTTXuLyVBLT: json['vanBanDen']['vbdTTXuLyVanBanLT'] == null ? 0 : json['vanBanDen']["vbdTTXuLyVanBanLT"],
  vbdPT:json['vanBanDen']['vbdPhuongThuc'] ==  null  ? 0 : json['vanBanDen']['vbdPhuongThuc'],
  vbdSVB: json['vanBanDen']['vbdSoVanBan']!= null ?json['vanBanDen']['vbdSoVanBan']:0,
    vbdTrangThaiXuLyVanBan: json['vanBanDen']['vbdTrangThaiXuLyVanBan']!= null ?json['vanBanDen']['vbdTrangThaiXuLyVanBan']:0,
      HanXL:json['vanBanDen']['vbdHanXuLy'] != null ?  DateFormat('dd-MM-yyyy')
      .format(DateFormat('yyyy-MM-dd').parse(json['vanBanDen']['vbdHanXuLy'])):"",
      vbdIsSentVB: json['vanBanDen']['vbdIsSentVanBan'] ==  null ? false: json['vanBanDen']['vbdIsSentVanBan'],
    checkbtnXDB1: json['vanBanDen']['checkbtnXDB'] ==  null ? false: json['vanBanDen']['checkbtnXDB'],
    checkThuHoi1: json['vanBanDen']['checkThuHoi'] ==  null ? false: json['vanBanDen']['checkThuHoi'],
    ChucVuNK: json['vanBanDen']['vbdChucVuNguoiKy'] !=  null && json['vanBanDen']['vbdChucVuNguoiKy']
        .length >0?

    json['vanBanDen']['vbdChucVuNguoiKy'][0]['LookupValue']: "",
    ChucVuNKID: json['vanBanDen']['vbdChucVuNguoiKy'] !=  null && json['vanBanDen']['vbdChucVuNguoiKy']
        .length >0?

    json['vanBanDen']['vbdChucVuNguoiKy'][0]['LookupId']: 0,
    pdf1: json['vanBanDen']['ListFileAttach']==null||json['vanBanDen']['ListFileAttach'].length <=0
        ?[]:
    json['vanBanDen']['ListFileAttach'],
    vbdPhongBanPT: json['vanBanDen']['vbdPhongBanPT']!= null &&
        json['vanBanDen']['vbdPhongBanPT'].length >0 ?
    json['vanBanDen']['vbdPhongBanPT']['LookupId']:0,
    vbdNguoiDungPT: json['vanBanDen']['vbdNguoiDungPT']!= null &&
        json['vanBanDen']['vbdNguoiDungPT'].length >0  ?
    json['vanBanDen']['vbdNguoiDungPT']['LookupId']:0,
    vbdUserXuLyC: json['vbdUserXuLyC']!= null &&json['vanBanDen']['vbdUserXuLyC'].length > 0 ?
    json['vanBanDen']['vbdUserXuLyC']['LookupId']:0,
    strUserPH: json['vanBanDen']['strUserPH']!= null ? json['vanBanDen']['strUserPH']:"",
  // can xem lai chua lay dung
  // can xem lai chua lay dung
  // can xem lai chua lay dung
     );

    }

//Map model to json['vanBanDen']
// Map<String, dynamic> toJson() => {
//   'ID' : ID,
//   'Title' : Title,
//
// };
}
