import 'package:intl/intl.dart';


// VanBanDiJson vanBanDiJson(String str) =>
//     VanBanDiJson.fromJson(json.decode(str));
// String vanBanToJson(VanBanDiJson data) => json.encode(data.toJson());

//model VanBanDiJson
class VanBanDiJson {
  //properties
  // final int ID;
  // final String Title;
  final String LoaiVanBan;
  final String SoKyHieu;
  final String TrichYeu;
  final String SoDi;
  final String NguoiKy;
  final String NgayBanHanh;
  final String NguoiSoan;
  final String DonViGui;
  final String NgayKy;
  final String SoBanLuu;
  final String SoTo;
  final String MaDinhDanh;
  final String GhiChu;
  final List DonViNhan;
  final String ChucVu;
  final String PBSoan;
  final String DoMat;
  final String DoKhan;
  final bool vbdiIsSentVB;
  final bool checkThuHoi1 ;
  final bool vbdiCanTDHB1;
  final List pdf1;
  final String LogxulyText;
  final String name;
  final int vbdiPBLookup;
  List pdfDK;


  //Constructor
  VanBanDiJson(
      {

      //   this.ID,
      // this.Title,
        required this.LoaiVanBan,
        required this.SoKyHieu,
        required this.TrichYeu,
        required this.SoDi,
        required this.NguoiKy,
        required this.NgayBanHanh,
        required   this.NguoiSoan,
        required  this.DonViGui,
        required   this.NgayKy,
        required  this.SoBanLuu,
        required   this.SoTo,
        required   this.MaDinhDanh,
        required  this.GhiChu,

        required  this.DonViNhan,
        required this.ChucVu,
        required  this.PBSoan,
        required  this.DoKhan,
        required  this.DoMat,
        required  this.vbdiIsSentVB,
        required   this.vbdiCanTDHB1,
        required this.checkThuHoi1,
        required    this.pdf1,
        required    this.LogxulyText,
        required   this.name,
        required  this.pdfDK,
        required   this.vbdiPBLookup,
      });
//factory convert json to model
  factory VanBanDiJson.fromJson(Map<String, dynamic> json) {
    return  VanBanDiJson(
        LoaiVanBan: json['vbdiLoaiVanBan']!= null || json['vbdiLoaiVanBan']['LookupValue']  != null ?
        json['vbdiLoaiVanBan']['LookupValue']  : "",
        SoKyHieu: json['vbdiSoKyHieu'] != null ? json['vbdiSoKyHieu']  : "",
         TrichYeu: json["vbdiTrichYeu"] == null  ? "" : json["vbdiTrichYeu"] ,
        SoDi: json['vbdiSoCongVan'] != null ? json['vbdiSoCongVan'].toString() :"",
         NguoiKy: json['vbdiNguoiKy'] != null || json['vbdiNguoiKy']['LookupValue'] != null ?
    json['vbdiNguoiKy']['LookupValue'] : "" ,
        NgayBanHanh: json['vbdiNgayBanHanh'] != null ?DateFormat('dd-MM-yyyy')
            .format(DateFormat('yyyy-MM-dd').parse(json['vbdiNgayBanHanh'])) : "",
        NguoiSoan:   json['vbdiNguoiSoan_x003a_Title'] == null ||json['vbdiNguoiSoan_x003a_Title']['LookupValue'] ==  null  ? "":json['vbdiNguoiSoan_x003a_Title']['LookupValue'] ,
      DonViGui: json['vbdiDonViSoanThao'] != null ||json['vbdiDonViSoanThao']['LookupValue'] != null ?
    json['vbdiDonViSoanThao']['LookupValue']  : "",
      vbdiPBLookup: json['vbdiPBLookup'] != null ||json['vbdiPBLookup']['LookupId'] != null ?
    json['vbdiPBLookup']['LookupId']  : 0,
      NgayKy:json['vbdiNgayKy'] != null  ?DateFormat('dd-MM-yyyy')
          .format(DateFormat('yyyy-MM-dd').parse(json['vbdiNgayKy'])) : "",
    DonViNhan: json['vbdiDSDonViNhanVB'].length > 0 &&
        json['vbdiDSDonViNhanVB'] != null ?
        json['vbdiDSDonViNhanVB']:[],
      SoBanLuu: json['vbdiSoBanLuu'] != null ? json['vbdiSoBanLuu'].toString()  :"",
     SoTo: json['vbdiSoTo'] == null ?"": json['vbdiSoTo'].toString(),
       MaDinhDanh: json['vbdiMaDinhDanhVB']!= null ? json['vbdiMaDinhDanhVB'].toString()  : "",
      GhiChu: json['vbdiGhiChu']== null ? "":json['vbdiGhiChu'].toString()  ,
        checkThuHoi1: json['checkThuHoi']!= null ? json['checkThuHoi'] :
         false,
        vbdiCanTDHB1: json['vbdiCanTDHB']== null ? false:json['vbdiCanTDHB'],
      LogxulyText: json['LogxulyText']== null ? "":json['LogxulyText'],
      ChucVu: json['strChucVu'] != null ? json['strChucVu']:"" ,
      DoMat: json['vbdiDoMat']== null || json['vbdiDoMat']['LookupValue'] == null  ? "":json['vbdiDoMat']['LookupValue']
           ,
      DoKhan: json['vbdiDoKhan']== null || json['vbdiDoKhan']['LookupValue'] == null  ? "":json['vbdiDoKhan']['Lookup'
          'Value'],
      PBSoan: json['vbdiPBSoanThao']== null || json['vbdiPBSoanThao']['LookupValue'] == null  ? "":json['vbdiPBSoanTh'
          'ao']['LookupValue']
          .toString()  ,
       vbdiIsSentVB: json['vbdiIsSentVanBan'].toString() == null  ||
           json['vbdiIsSentVanBan'] == null  ? false :
       json['vbdiIsSentVanBan'],
      pdf1: json['ListFileAttach'].length <0||json['ListFileAttach'].length ==0
          ? []:
      json['ListFileAttach'],
      name: json['ListFileAttach'].length <0||json['ListFileAttach'].length ==0
          ? "":
      json['ListFileAttach'][0]['Name'],
        pdfDK: json['lstFileTaiLieuDinhKemvbdi']==null||json['lstFileTaiLieuDinhKemvbdi'].length <=0
            ?[]:json['lstFileTaiLieuDinhKemvbdi'],






    );

  }
}
