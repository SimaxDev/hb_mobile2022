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
  List pdfDK;


  //Constructor
  VanBanDiJson(
      {

      //   this.ID,
      // this.Title,
      this.LoaiVanBan,
      this.SoKyHieu,
      this.TrichYeu,
      this.SoDi,
      this.NguoiKy,
      this.NgayBanHanh,
      this.NguoiSoan,
      this.DonViGui,
      this.NgayKy,
      this.SoBanLuu,
      this.SoTo,
      this.MaDinhDanh,
      this.GhiChu,

      this.DonViNhan,
      this.ChucVu,
      this.PBSoan,
      this.DoKhan,
      this.DoMat,
      this.vbdiIsSentVB,
      this.vbdiCanTDHB1,
        this.checkThuHoi1,
        this.pdf1,
        this.LogxulyText,
        this.name,
        this.pdfDK,
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
