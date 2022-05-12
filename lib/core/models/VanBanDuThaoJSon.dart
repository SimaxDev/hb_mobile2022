import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:intl/intl.dart';


// VanBanDiJson vanBanDiJson(String str) :>
//     VanBanDiJson.fromJson(json.decode(str)),
// String vanBanToJson(VanBanDiJson data) :> json.encode(data.toJson()),

//model VanBanDiJson
class VanBanDuThaoJson {
  //properties

  final String TrangThaiVB;
    final String trichYeu ;
    final String ldKyVB ;
    final bool checkThuHoi1;
    final String ngaytrinhky ;
    final String nguoiSoanThao ;
    final String lanhDao2 ;
    final String lanhDao4;
  final int trangThaiLD;
    final String trangThai  ;
    final String donviSoanthao  ;
    final String loaiVanban;
    final List vbdiCurrentDSXuly_x003a_Title;
    final List vbdiCurrentUserReceivedDT;
  final  bool trinhDaCoNgDuyetDT;
  final bool trinhLan2DT;
  final int vbdiNguoiSoanIDDT;
  final int chukysoDT;
  final List vbdiDSNguoiTrinhTiepDT;
  final   bool isDuyetVaPhatHanhDT;
  final   bool isTrinhTiep;
  final bool isDuyetDT;
  final bool kyVaPhatHanhDT;
  final  int isnguoiduyetDT;
  final  bool isDuyetTruongPhongDT;
  final  bool isThuHoi;
  final  bool isTrinhKy;
  final  int vbdiNguoiKyIDDT;
  final int vbdiCurrentNguoiTrinhIDDT;
  final int OldID2010;
    final List pdfDT;
  List pdfDK;
  //Constructor
  VanBanDuThaoJson(
      {
        this.TrangThaiVB,
        this.isTrinhTiep,
        this.trichYeu,
        this.ldKyVB,
        this.checkThuHoi1,
        this.ngaytrinhky,
        this.nguoiSoanThao,
        this.lanhDao2,
        this.lanhDao4,
        this.trangThaiLD,
        this.trangThai,
        this.donviSoanthao,
        this.loaiVanban,
        this.vbdiCurrentDSXuly_x003a_Title,
        this.vbdiCurrentUserReceivedDT,
        this.trinhDaCoNgDuyetDT,
        this.trinhLan2DT,
        this.vbdiNguoiSoanIDDT,
        this.chukysoDT,
        this.vbdiDSNguoiTrinhTiepDT,
        this.isDuyetVaPhatHanhDT,
        this.isDuyetDT,
        this.kyVaPhatHanhDT,
        this.isnguoiduyetDT,
        this.isDuyetTruongPhongDT,
        this.vbdiNguoiKyIDDT,
        this.vbdiCurrentNguoiTrinhIDDT,
        this.pdfDT,
        this.pdfDK,
        this.isThuHoi,
        this.OldID2010,
        this.isTrinhKy,


      });

  //factory convert json to model
  factory VanBanDuThaoJson.fromJson(Map<String, dynamic> json) {
    return  VanBanDuThaoJson(
        trichYeu :  json["vbdiTrichYeu"] != null?json["vbdiTrichYeu"]:"",
        ldKyVB :  json["ldKyVB"] ?? "",
    vbdiCurrentUserReceivedDT : json["vbdiCurrentUserReceived"]!=
        null?json["vbdiCurrentUserReceived"]:[],

    checkThuHoi1 :  json["checkThuHoi"] != null ?json["checkThuHoi"] :false ,
      isTrinhKy :  json["isTrinhKy"] != null ?json["isTrinhKy"] :false ,
      isThuHoi :  json["isThuHoi"] != null ?json["isThuHoi"] :false ,
    trinhDaCoNgDuyetDT :  json["trinhDaCoNgDuyet"] != null?
    json["trinhDaCoNgDuyet"] : false ,
    trinhLan2DT : json["trinhLan2"]!= null?json["trinhLan2"] : false,
    ngaytrinhky : json['vdiNgayTrinhKy']!= null? DateFormat('dd-MM-yyyy')
        .format(DateFormat('yyyy-MM-dd').parse(json['vdiNgayTrinhKy'])):"",
    nguoiSoanThao :  json['vbdiNguoiSoan_x003a_Title'] != null
        ? json['vbdiNguoiSoan_x003a_Title']['LookupValue']
        : "",
    vbdiNguoiSoanIDDT :  json['vbdiNguoiSoan_x003a_Title'].length > 0
        ? json['vbdiNguoiSoan_x003a_Title']['LookupId']
        : 0,
    chukysoDT :  json['chukyso'] != null
        ? json['chukyso']
        : 0,
    lanhDao2 :
    json['vbdiDSNguoiTrinhTiep'].length > 0 &&json['vbdiDSNguoiTrinhTiep'] !=
        null
        ? json['vbdiDSNguoiTrinhTiep'][0]['LookupValue']
        : "",
    vbdiDSNguoiTrinhTiepDT :
    json['vbdiDSNguoiTrinhTiep'] != null
        ? json['vbdiDSNguoiTrinhTiep']
        : [],
    isDuyetVaPhatHanhDT :
    json['isDuyetVaPhatHanh'] != null
        ? json['isDuyetVaPhatHanh']
        : false,
    isDuyetDT :
    json['isDuyet'] != null
        ? json['isDuyet']
        : false,
      isTrinhTiep :
    json['isTrinhTiep'] != null
        ? json['isTrinhTiep']
        : false,
    kyVaPhatHanhDT :
    json['kyVaPhatHanh'] != null
        ? json['kyVaPhatHanh']
        : false,
    isnguoiduyetDT :
    json['isnguoiduyet'] != null
        ? json['isnguoiduyet']
        : 0,
    isDuyetTruongPhongDT :
    json['isDuyetTruongPhong'] != null
        ? json['isDuyetTruongPhong']
        : false,
    lanhDao4 :  json['vbdiNguoiKy'] != null
        ? json['vbdiNguoiKy']['LookupValue']
        : "",
    vbdiNguoiKyIDDT :  json['vbdiNguoiKy'] != null
        ? json['vbdiNguoiKy']['LookupId']
        : 0,
    vbdiCurrentNguoiTrinhIDDT : json['vbdiCurrentNguoiTrinh'] != null
        ? json['vbdiCurrentNguoiTrinh']['LookupId']
        : 0,
    trangThaiLD  :  json['vbdiTrangThaiVB'] != null
        ? json['vbdiTrangThaiVB']
        : 0,
    trangThai :  json['vbdiTrangThaiVBText'] != null
        ? json['vbdiTrangThaiVBText']
        : "",
      OldID2010 :  json['OldID2010'] != null
        ? json['OldID2010']
        :0,
    donviSoanthao :  json['vbdiDonViSoanThao'] != null
        ? json['vbdiDonViSoanThao']['LookupValue']
        : "",
    loaiVanban :  json['vbdiLoaiVanBan'] != null
        ? json['vbdiLoaiVanBan']['LookupValue']
        : "",
       pdfDT: json['ListFileAttach'].length
            <=0||json['ListFileAttach'] == null
            ?[]:
       json['ListFileAttach'],
      pdfDK: json['lstFileTaiLieuDinhKemvbdi']==null||json['lstFileTaiLieuDinhKemvbdi'].length <=0
          ?[]:
      json['lstFileTaiLieuDinhKemvbdi'],
      vbdiCurrentDSXuly_x003a_Title: json['vbdiCurrentDSXuly_x003a_Title']==null||json['vbdiCurrentDSXuly_x003a_Title'].length <=0
          ?[]:
      json['vbdiCurrentDSXuly_x003a_Title'],

      //TrangThaiVB: json['vbdiTrangThaiVB'] !=  null ? json['vbdiTrangThaiVB'] : "",
    );

  }
}
