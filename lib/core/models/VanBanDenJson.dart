import 'dart:convert';
import 'package:intl/intl.dart';




class VanBanDenJson {
  //properties

  int ID;
  String soCongVan;
  int soCongVanID;
  String LoaiVanBan;
  int LoaiVanBanID;
  String ChucVuNK;
  String SoKyHieu;
  String TrichYeu;
  int SoDen;
  String CoQuanBanHanh;
  int CoQuanBanHanhID;
  String NgayDen;
  String NgayVaoSo;
  String CBPhoiHop;
  String DoKhan;
  String NguoiKy;
  String MaDinhDanhDonVi;
  String DoMat;
  String XuLyChinh;
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
  bool isTraCuu;
  int vbdSVB;
  int ChucVuNKID;
  int NguoiKyID;
  int vbdTrangThaiXuLyVanBan;
  List UserChuaXLID;
  String LogxulyText;
  String NhanVB;
  String HanXL;
  List pdf1;
  List pdfDK;
  var vanbandenCapNhat;
  int vbdPhongBanPT;
  int vbdNguoiDungPT;
  int vbdUserXuLyC;
  int vbdiXuatPhatTuVBDuTHao;




  VanBanDenJson(
      {
        required this.ID,

        required this.LoaiVanBan,
        required  this.LoaiVanBanID,
        required  this.SoKyHieu,

        required  this.TrichYeu,
        required  this.SoDen,
        required  this.CoQuanBanHanh,
        required  this.CoQuanBanHanhID,
        required   this.NgayDen,
        required  this.NgayVaoSo,
        required  this.CBPhoiHop,
        required  this.DoKhan,
        required   this.NguoiKy,
        required  this.NguoiKyID,
        required  this.vanbandenCapNhat,
        required  this.MaDinhDanhDonVi,
        required  this.DoMat,
        required  this.XuLyChinh,
        required  this.NgayBanHanh,
        required  this.MaDinhDanhVB,
        required  this.CBXemDeBiet,
        required  this.CBChuaXuLy,
        required  this.CBPhuTrach,
        required  this.ThoiGianNhan,
        required this.VBNhanLT,
        required this.ThuHoi,
        required  this.checkThuHoi1,
        required this.UserChuaXL,
        required this.vbdTTXuLyVBLT,
        required  this.vbdPT,
        required this.vbdSVB,
        required  this.vbdIsSentVB,
        required  this.UserChuaXLID,
        required  this.LogxulyText,
        required  this.NhanVB,
        required  this.checkbtnXDB1,
        required  this.vbdTrangThaiXuLyVanBan,
        required  this.HanXL,
        required this.yKienThuHoi,
        required this.ChucVuNK,
        required  this.ChucVuNKID,
        required  this.pdf1,
        required this.pdfDK,
        required this.vbdPhongBanPT,
        required  this.vbdNguoiDungPT,
        required this.vbdUserXuLyC,
        required  this.strUserPH,
        required  this.soCongVan,
        required  this.soCongVanID,
        required  this.isTraCuu,

        required  this.vbdiXuatPhatTuVBDuTHao,

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
      CoQuanBanHanhID: json['vanBanDen']['vbdCoQuanBanHanh']!=
          null&&json['vanBanDen']['vbdCoQuanBanHanh']['LookupId'] != null
          ?json['vanBanDen']['vbdCoQuanBanHanh']['LookupId'] :0,
      ID: json['vanBanDen']['ID']!=null?json['vanBanDen']['ID']:0,
      LoaiVanBan: json['vanBanDen']['vbdLoaiVanBan']!=null&&json['vanBanDen']['vbdLoaiVanBan']['LookupV'
          'alue']!= null ?json['vanBanDen']['vbdLoaiVanBan']['LookupV'
          'alue']:"",
      LoaiVanBanID: json['vanBanDen']['vbdLoaiVanBan']!=null ? json['vanBanDen']['vbdLoaiVanBan']['LookupId']:"",
      soCongVan: json['vanBanDen']['vbdSoCongVanLookup']!=null&&json['vanBanDen']['vbdSoCongVanLookup']['LookupV'
          'alue']!= null ?json['vanBanDen']['vbdLoaiVanBan']['LookupV'
          'alue']:"",
      soCongVanID: json['vanBanDen']['vbdSoCongVanLookup']!=null ? json['vanBanDen']['vbdSoCongVanLookup']['LookupId']:"",

      SoKyHieu: json['vanBanDen']['vbdSoKyHieu']!=null?json['vanBanDen']['vbdSoKyHieu'] :"",
      DoKhan: json['vanBanDen']['vbdDoKhan']!=null&&json['vanBanDen']['vbdDoKhan']['LookupValue']!=null ?json['vanBanDen']['vbdDoKhan']['LookupValue']:"",
      DoMat: json['vanBanDen']['vbdDoMat']!=null&&json['vanBanDen']['vbdDoMat']['LookupValue']!=null
          ?json['vanBanDen']['vbdDoMat']['LookupValue']:
      "",
      SoDen: json['vanBanDen']['vbdSoVanBan'] !=null ? json['vanBanDen']['vbdSoVanBan']: "",
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
      isTraCuu: json['oLVanBanDenQuery'] != null  &&json['oLVanBanDenQuery']['isTraCuu'] != null ?
    json['oLVanBanDenQuery']['isTraCuu'] : false,
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
      pdfDK: json['vanBanDen']['lstFileTaiLieuDinhKem']==null||json['vanBanDen']['lstFileTaiLieuDinhKem'].length <=0
          ?[]:
      json['vanBanDen']['lstFileTaiLieuDinhKem'],
      vbdPhongBanPT: json['vanBanDen']['vbdPhongBanPT']!= null &&
          json['vanBanDen']['vbdPhongBanPT'].length >0 ?
      json['vanBanDen']['vbdPhongBanPT']['LookupId']:0,
      vbdNguoiDungPT: json['vanBanDen']['vbdNguoiDungPT']!= null &&
          json['vanBanDen']['vbdNguoiDungPT'].length >0  ?
      json['vanBanDen']['vbdNguoiDungPT']['LookupId']:0,
      vbdiXuatPhatTuVBDuTHao: json['VanBanDi']['vbdiXuatPhatTuVBDuTHao']!= null &&
          json['VanBanDi']['vbdiXuatPhatTuVBDuTHao'].length >0  ?
      json['VanBanDi']['vbdiXuatPhatTuVBDuTHao']['LookupId']:0,
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
