

import 'package:date_time_picker/date_time_picker.dart';

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
  final String hscvCongViecLienQuanText;
  final List hscvCongViecLienQuan;
  final List hscvVanBanDenLienQuan;
  final List hscvVanBanDiLienQuan;



  hoSoCVJson(
  { this.tenHoSo,
    this.maHoSo,
    this.thoiGianBD,
    this.soHoSo,
    this.thoiGianKT,
    this.thoiGianBH,
    this.ngonNgu,
    this.cheDoSD,
    this.linhVuc,
    this.mucDo,
    this.checkKetThucHSCV,
    this.tongSoVB,
    this.soLuongTo,
    this.soLuongTrang,
    this.kyHieuTT,
    this.tinhTrangVL,
    this.tuKhoa,
    this.nguoiLap,
    this.checkChuyenVaoHS,
    this.noiDung,
    this.hscvCongViecLienQuan,
    this.hscvCongViecLienQuanText,
    this.hscvNguoiPhuTrach,
    this.hscvNguoiLap,
    this.ChuyenVT,
    this.hscvTrangThaiXuLy,
    this.checkSoanVBDT,
    this.hscvVanBanDenLienQuan,
    this.hscvVanBanDiLienQuan,
  }
     );

  factory hoSoCVJson.fromJson(Map<String, dynamic> json) {
    return  hoSoCVJson(
      tenHoSo: json['Title'] != null ? json['Title']  : "",
      soHoSo: json['SoHoSo'] != null ? json['SoHoSo']  :"",
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