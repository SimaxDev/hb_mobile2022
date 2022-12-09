

import 'package:intl/intl.dart';

class hoSoCVJson{
  final String tenHoSo;
  final String maHoSo;
  final String thoiGianBD;
  final String soHoSo;
  final String thoiGianKT;
  final String thoiGianBH;
  final String ngonNgu;
  final String cheDoSD;
  final String linhVuc;
  final int mucDo;
  final int tongSoVB;
  final int soLuongTo;
  final int soLuongTrang;
  final int hscvNguoiLap;
  final int hscvTrangThaiXuLy;
  final int hscvNguoiPhuTrach;
  final String kyHieuTT;
  final String tinhTrangVL;
  final String tuKhoa;
  final String nguoiLap;
  final String noiDung;
  final bool ChuyenVT;
  final bool checkChuyenVaoHS;
  final bool checkKetThucHSCV;
  final bool checkSoanVBDT;
  final bool isInHoSo;
  final String hscvCongViecLienQuanText;
  final List hscvCongViecLienQuan;
  final List hscvVanBanDenLienQuan;
  final List hscvVanBanDiLienQuan;
   var hscvParentID;



  hoSoCVJson(
  {required this.tenHoSo,
    required this.maHoSo,
    required this.thoiGianBD,
    required this.soHoSo,
    required this.thoiGianKT,
    required this.thoiGianBH,
    required this.ngonNgu,
    required  this.cheDoSD,
    required this.linhVuc,
    required this.mucDo,
    required this.checkKetThucHSCV,
    required  this.tongSoVB,
    required  this.soLuongTo,
    required  this.soLuongTrang,
    required  this.kyHieuTT,
    required  this.tinhTrangVL,
    required   this.tuKhoa,
    required   this.nguoiLap,
    required   this.checkChuyenVaoHS,
    required   this.noiDung,
    required  this.hscvCongViecLienQuan,
    required  this.hscvCongViecLienQuanText,
    required this.hscvNguoiPhuTrach,
    required this.hscvNguoiLap,
    required this.ChuyenVT,
    required this.hscvTrangThaiXuLy,
    required this.checkSoanVBDT,
    required  this.hscvVanBanDenLienQuan,
    required  this.hscvVanBanDiLienQuan,
    required  this.isInHoSo,
    required  this.hscvParentID,
  }
     );

  factory hoSoCVJson.fromJson(Map<String, dynamic> json) {
    return  hoSoCVJson(
      tenHoSo: json['Title'] != null ? json['Title']  : "",
      soHoSo: json['SoHoSo'] != null ? json['SoHoSo']  :"",
      hscvParentID: json['hscvParentID'] != null ? json['hscvParentID']  :"",
      ngonNgu: json['NgonNgu'] != null ? json['NgonNgu']  : "",
      kyHieuTT: json['KyHieuThongTin'] != null ? json['KyHieuThongTin']  : "",
      noiDung: json['hscvNoiDungXuLy'] != null ? json['hscvNoiDungXuLy']  : "",
      nguoiLap: json['hscvNguoiLap'] != null &&
          json['hscvNguoiLap']['LookupValue']  != null?
    json['hscvNguoiLap']['LookupValue']  : "",
      hscvNguoiPhuTrach: json['hscvNguoiPhuTrach'].length>0 &&
          json['hscvNguoiPhuTrach']['LookupId']  != null?
      json['hscvNguoiPhuTrach']['LookupId']  : 0,
      hscvNguoiLap: json['hscvNguoiLap'] != null &&
          json['hscvNguoiLap']['LookupId']  != null?
      json['hscvNguoiLap']['LookupId']  : 0,
      tinhTrangVL: json['TinhTrangVatLy'] != null ? json['TinhTrangVatLy']  : "",
      tuKhoa: json['TuKhoa'] != null ? json['TuKhoa']  : "",
      ChuyenVT: json['ChuyenVT'] != null ? json['ChuyenVT']  : false,
      checkKetThucHSCV: json['checkKetThucHSCV'] != null ? json['checkKetThucHSCV']  : false,
      checkChuyenVaoHS: json['checkChuyenVaoHS'] != null ? json['checkChuyenVaoHS']  : false,
      isInHoSo: json['isInHoSo'] != null ? json['isInHoSo']  : false,
      checkSoanVBDT: json['checkSoanVBDT'] != null ? json['checkSoanVBDT']  : false,
      soLuongTo: json['SoTo'] != null ? json['SoTo']  :0,
      hscvTrangThaiXuLy: json['hscvTrangThaiXuLy'] != null ? json['hscvTrangThaiXuLy']  :0,
      mucDo: json['hscvMucDo'] != null ? json['hscvMucDo']  : 0,
      soLuongTrang: json['SoTrang'] != null ? json['SoTrang']  : 0,
      tongSoVB: json['hscvVanBanDenLienQuan'] != null ?
      json['hscvVanBanDenLienQuan'].length  : 0,
      cheDoSD: json['CheDoSuDung'] != null ? json['CheDoSuDung']  : "",
      linhVuc: json['hscvLinhVuc'] != null && json['hscvLinhVuc'].length >0? json['hscvLinhVuc'][0]['LookupValue'] : "",
      maHoSo: json['hscvMaHoSo'] != null ? json['hscvMaHoSo']  : "",
      thoiGianBD: json['hscvNgayMoHoSo'] != null ?DateFormat('dd-MM-yyyy')
          .format(DateFormat('yyyy-MM-dd').parse(json['hscvNgayMoHoSo'])) : "",
      thoiGianKT: json['hscvHanXuLy'] != null ?DateFormat('dd-MM-yyyy')
          .format(DateFormat('yyyy-MM-dd').parse(json['hscvHanXuLy'])) : "",
      thoiGianBH: json['ThoiHanBaoQuan'] != null ? json['ThoiHanBaoQuan']: "",
      hscvCongViecLienQuanText: json['hscvCongViecLienQuan'] != null &&
          json['hscvCongViecLienQuan'].length >0? json['hscvCongViecLienQuan'][0]['LookupValue'] : "",
      hscvCongViecLienQuan: json['hscvCongViecLienQuan'] != null &&
          json['hscvCongViecLienQuan'].length >0?
      json['hscvCongViecLienQuan'] : [],
      hscvVanBanDenLienQuan: json['hscvVanBanDenLienQuan'] != null &&
          json['hscvVanBanDenLienQuan'].length >0?
      json['hscvVanBanDenLienQuan'] : [],
      hscvVanBanDiLienQuan: json['hscvVanBanDiLienQuan'] != null &&
          json['hscvVanBanDiLienQuan'].length >0?
      json['hscvVanBanDiLienQuan'] : [],
      // thoiGianBH: json['ThoiHanBaoQuan'] != null ?DateFormat('dd-MM-yyyy')
      //     .format(DateFormat('yyyy-MM-dd').parse(json['ThoiHanBaoQuan'])) : "",
    );}
}