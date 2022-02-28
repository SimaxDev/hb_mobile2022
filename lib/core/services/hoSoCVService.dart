


import 'package:date_time_picker/date_time_picker.dart';

import 'callApi.dart';


  Future<String> getDataDetailHSCV(int idHS,String ActionXL)
  async {
    var parts = [];
    parts.add('ItemID=' + idHS.toString());
    parts.add('ActionXL=' + ActionXL);
    var formData = parts.join('&');
    String url = "/api/ServicesHSCV/GetData";
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }

  Future<String> getDataDetailHSCV1(String ActionXL,String query,int idHS)
  async {
    var parts = [];
    parts.add('ItemID=' + idHS.toString());
    parts.add('ActionXL=' + ActionXL);
    parts.add(query);
    var formData = parts.join('&');
    String url = "/api/ServicesHSCV/GetData";
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }
  Future<String> getDataDetailHSCVVBD(String ActionXL,String query,int idHS,
      String id,String nam,String idLVB,String idCQBH)
  async {
    if(nam == null){
    DateTime now = DateTime.now();
    nam =  DateFormat('yyyy').format(now) ;
  };
    if(idLVB == null)
      {
        idLVB="";
      }
    if(idCQBH == null)
      {
        idCQBH="";
      }

    var parts = [];
    parts.add('ItemID=' + idHS.toString());
    parts.add('ActionXL=' + ActionXL);
    parts.add('lstIDVanBans=' + id);
    parts.add('LoaiVanBan=' + idLVB);
    parts.add('CoQuanBanHanh=' + idCQBH);
    parts.add('searchTimNhanh=' +query);
    parts.add('SYear='+nam);
    // cần xem lại chỗ này nếu truyền nam thì sẽ k
    // lấy được danh sách văn bản đến liên quan(con thật). k truyền năm thì k
    // searchTimNhanh được...
    var formData = parts.join('&');
    String url = "/api/ServicesHSCV/GetData";
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }


  Future<String>postHanXuLyHSCV( username,id, ActionXL, String noidungykien)
  async {
    var parts = [];
    parts.add('TenDangNhap=' + username.toString());
    parts.add('ItemID=' + id.toString());
    parts.add('ActionXL=' + ActionXL);
    parts.add('hscvHanXuLy=' + noidungykien);
    var formData = parts.join('&');
    String url = "/api/ServicesHSCV/GetData";
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = response.body;
      return items;
    }
  }

  Future<String>postTreeCayHSCV( id, ActionXL, String noidungykien)
  async {
    var parts = [];
    parts.add('ItemID=' + id.toString());
    parts.add('ActionXL=' + ActionXL);
    parts.add(noidungykien);
    var formData = parts.join('&');
    String url = "/api/ServicesHSCV/GetData";
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = response.body;
      return items;
    }
  }
  Future<String>getDataByKeyTrangThai1(String ActionXL,String
  trangthai,int skip, int pageSize,int skipquey) async {
    if(trangthai == "6"){

      trangthai = "-1";
    }

    var url = "/api/ServicesHSCV/GetData";
    var parts = [];
   parts.add("isHoSocongviec=true");
    parts.add('skip=' + skipquey.toString());
    parts.add('take=20');
    parts.add('page=' + skip.toString());
    parts.add('pagesize=' + pageSize.toString());
    parts.add('ActionXL=' + ActionXL.toString());
    parts.add('hscvTrangThaiXuLy=' + trangthai);
  //  parts.add('SYear=' + nam);
    var formData = parts.join('&');
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }
Future<String>getDataByKeyTrangThai(String ActionXL,String
trangthai) async {


  var url = "/api/ServicesHSCV/GetData";
  var parts = [];
  parts.add("isHoSocongviec=true");
  parts.add('ActionXL=' + ActionXL.toString());
  parts.add('hscvTrangThaiXuLy=' + trangthai);
  //  parts.add('SYear=' + nam);
  var formData = parts.join('&');
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}


  Future<String> getDataHomeHSCV( String ActionXL,
      String query) async {
    String url = "/api/ServicesHSCV/GetData";
    DateTime now = DateTime.now();
    String Yearvb = DateFormat('yyyy').format(now);
    var parts = [];
    parts.add('ActionXL=' + ActionXL.toString());
    parts.add('SYear=' + Yearvb);

    parts.add(query.toString());
    var formData = parts.join('&');
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }

Future<String> getDataHomeHSCV1( String ActionXL,
    String Yearvb) async {
  String url = "/api/ServicesVBD/GetData";
  var parts = [];
  parts.add('ActionXL=' + ActionXL.toString());
  parts.add('SYear=' + Yearvb);
  var formData = parts.join('&');
  var response = await responseDataPost(url, formData);
  if (response.statusCode == 200) {
    var items = (response.body);
    return items;
  }
}

  Future<String> getYkienDataHSCV(int id,String ActionXL) async {
    DateTime now = DateTime.now();
    String Yearvb = DateFormat('yyyy').format(now);
    var parts = [];
    parts.add('ItemID=' + id.toString());
    parts.add('ActionXL=' + ActionXL.toString());
    parts.add('sYear=' + Yearvb.toString());
    var formData = parts.join('&');
    String url = "/api/ServicesHSCV/GetData";
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }

  Future<String> postChuyenHS(int id,String ActionXL,hosoid) async {
    var parts = [];
    parts.add('ItemID=' + id.toString());
    parts.add('hosoid=' + hosoid.toString());
    parts.add('ActionXL=' + ActionXL.toString());
    var formData = parts.join('&');
    String url = "/api/ServicesHSCV/GetData";
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }
  Future<String> deleteHSCV(int id,String ActionXL) async {
    var parts = [];
    parts.add('ItemID=' + id.toString());
    parts.add('ActionXL=' + ActionXL.toString());
    var formData = parts.join('&');
    String url = "/api/ServicesHSCV/GetData";
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }


  Future<String>postThemHSCV(
      String ActionXL,
      String Title,
      String TenDangNhap,
      String SYear,
      String xemTT,
      String SoHoSo,
      String NoiDungXuLy,
      String NgayMoHoSo,
      String HanXuLy,

      String maHoSo,
      String linhVuc,
      String thoiGianBaoQuan,
      String soLuongTo,
      String soLuongTrang,
      String tinhTrangVl,
      String ngonNgu,
      String tuKhoa,
      String PDF,
      String mucDo,
      )
  async {

    var parts = [];
    parts.add('ActionXL=' + ActionXL);
    parts.add('Title=' + Title);
    parts.add('TenDangNhap=' + TenDangNhap);
    parts.add('SYear='+SYear );
    parts.add('hscvIsCongViec=' + xemTT);
    parts.add('SoHoSo=' + SoHoSo);
    parts.add('hscvNoiDungXuLy=' + NoiDungXuLy);
    parts.add('hscvNgayMoHoSo=' + NgayMoHoSo);
    parts.add('hscvHanXuLy=' + HanXuLy);

    parts.add("maHoSo="+maHoSo);
    parts.add('strMucDo=' + mucDo);
    parts.add('hscvLinhVuc2=' + linhVuc);
    parts.add('ThoiHanBaoQuan=' + thoiGianBaoQuan);
    parts.add('Soto=' + soLuongTo);
    parts.add('SoTrang=' + soLuongTrang);
    parts.add('TinhTrangVatLy=' + tinhTrangVl);
    parts.add('NgonNgu=' + ngonNgu);
    parts.add('TuKhoa=' + tuKhoa);
    parts.add('listValueFileAttach=' + PDF);

    var formData = parts.join('&');

    String url = "/api/ServicesHSCV/GetData";
    var response = await responseDataPost(url, formData);

    if (response.statusCode == 200) {
      var items = response.body;
      return items;
    }
  }
  Future postYKienHSCV( username,id, ActionXL,  noidungykien) async {
    DateTime now = DateTime.now();
    String Yearvb = DateFormat('yyyy').format(now);
    var response = null;
    String url = "";
    var parts = [];
    parts.add('TenDangNhap=' + username.toString());
    parts.add('ItemID=' + id.toString());
    parts.add('ActionXL=' + ActionXL);
    parts.add('sYear=' +Yearvb );
    parts.add('hscvNguoiLap=' +currentUserID.toString() );
    parts.add('strNoiDungYKien=' + noidungykien);
    var formData = parts.join('&');
    url = "/api/ServicesHSCV/GetData";

    response = await responseDataPost(url, formData);
    // showLoading();
    if (response.statusCode == 200) {
      var items = response.body;
      return items;
    }


  }

  Future<String> getDataByKeyWordHSCV(String TenDangNhap,String ActionXL,String
  text) async {
    DateTime now = DateTime.now();
    String Yearvb = DateFormat('yyyy').format(now);
    var url = "/api/ServicesHSCV/GetData";
    var parts = [];
    parts.add('TenDangNhap=' + TenDangNhap.toString());
    parts.add('ActionXL=' + ActionXL.toString());
    parts.add('SYear='+ Yearvb);
    parts.add("isHoSocongviec=true");
    parts.add('searchTimNhanh=' + text);
    var formData = parts.join('&');
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }




