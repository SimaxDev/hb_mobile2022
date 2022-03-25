import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';


Future<String> GetMenuLeft(int page,String year) async {
  var url = getUrl(page);
  var parts = [];
 // parts.add('SYear=' + year );
  if( page ==1 ){
    parts.add('KieuMenu=vbd');
  }

  var formData = parts.join('&');
  var response =await responseDataHOmeVBDen(url,formData);
  if(response.statusCode == 200) {
    var item = response.body;
    return item;
  }
}

Future<String> GetDetailMenuLeft(int page, String query, String year) async {
  String ActionXL;
  if(page == 1){
    ActionXL ="GetListVBDen";
  }
  if(page == 2){
    ActionXL ="GetListVBDi";
  }
  if(page == 3){
    ActionXL ="GetListVBDT";
  }
  var url = getUrlDetail(page);
  var parts = [];
  parts.add('Yearvb=' + year );
  parts.add('ActionXL=' + ActionXL);
  parts.add(query);
  var formData = parts.join('&');
  var response =await responseDataVBDen(url,formData);
  if(response.statusCode == 200) {
    var item = response.body;
    datavb =  item;
    return datavb;

  }
}

String getUrl(int page) {
  switch (page) {
    case 1:
      return "/api/SVMenu/GetDataMenuLeftVBD1";
      break;
    case 2:
      return "/api/SVMenu/GetDataMenuLeftVBDi";
      break;
    case 3:
      return "/api/SVMenu/GetDataMenuLeftVBDT";
      break;
      case 4:
      return "/api/SVMenu/GetDataMenuLeftHSCV";
      break;
  }
}
String getUrlDetail(int page) {
  switch (page) {
    case 1:
      return "/api/ServicesVBD/GetData";
      break;
    case 2:
      return "/api/ServicesVBDi/GetData";
      break;
    case 3:
      return "/api/ServicesVBDT/GetData";
      break;
  }
}
