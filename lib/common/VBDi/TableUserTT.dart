import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'dart:convert';
import 'package:hb_mobile2021/core/services/VBDiService.dart';
import 'package:hb_mobile2021/core/services/hoSoCVService.dart';

import 'package:json_table/json_table.dart';
class SimpleTable extends StatefulWidget {
  final int id;

  SimpleTable({this.id});

  @override
  _SimpleTableState createState() => _SimpleTableState();
}

class _SimpleTableState extends State<SimpleTable> {
  bool toggle = true;
  List dataListThayThe = [];
  int skip = 0;
  int pageSize = 10;
  String ActionXL = "GetListVBDi";
  String vbdi1 = "";
  String vanbanDia = "";
  List<dynamic> json = [];


  var columns = [
    JsonTableColumn(
        "vbdiNgayKy",
        label: "Ngày mở hồ sơ", valueBuilder: formatDOB
    ),
    JsonTableColumn("vbdiTrichYeu", label: "Người lập"),
    JsonTableColumn("vbdiSoKyHieu", label: "Tên hồ sơ công việc"),
    JsonTableColumn("vbdiTrichYeu", label: "Tên hồ sơ công việc"),
    JsonTableColumn("Title", label: "Tên hồ sơ công việc"),
    // JsonTableColumn(
    //     "hscvTrangThaiXuLy", label: "Trạng thái", valueBuilder: ttHoSo),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetDataHSCV1();

    // s = json.decode(vbdi)['OData'];
  }
  @override
  void dispose() {
    // TODO: implement initState
    super.dispose();
    EasyLoading.dismiss();

    // s = json.decode(vbdi)['OData'];
  }

  GetDataHSCV1() async {
    String vbdi = "";
    DateTime now = DateTime.now();
   String nam1 =  DateFormat('yyyy').format(now) ;
    vbdi = await getTT(ActionXL,"", nam1);

    //jsonSample = jsonDecode(vbdi)['OData'];
    setState(() {
      json = jsonDecode(vbdi)['OData'];
      EasyLoading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    //var json = jsonDecode(jsonSample);
    return
      //Decode your json string
      Container(
        //height: MediaQuery.of(context).size.height *1,
          padding: EdgeInsets.all(16.0),
          child:Column(
            children: [
              //Decode your json string

//                                     JsonTable(
//                                       json,
//                                       columns: columns,
//                                       allowRowHighlight: true,
//                                       rowHighlightColor: Colors.yellow[500].withOpacity(0.7),
//                                       paginationRowCount: 8,
//                                     ),
              JsonTable(
                json,
                columns: columns,
                paginationRowCount: 10,
                tableHeaderBuilder: (String header) {
                  return Container(
                    width: 100,
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(border: Border.all(width: 0.5),
                        color: Colors.grey[300]),
                    child: Text(
                      header,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      // style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.w700, fontSize: 14.0,color: Colors.black87),
                    ),
                  );
                },
                tableCellBuilder: (value) {

                  return Container(
                    width: 100,
                    decoration: BoxDecoration(border: Border.all(
                        width: 0.5, color: Colors.grey.withOpacity(0.5))),
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline4
                          .copyWith(fontSize: 14.0, color: Colors.grey[900]),
                    ),
                  );
                },
              )


            ],
          )

      );
//Simply pass this column list to JsonTable

  }
//
//   String getPrettyJSONString(jsonObject) {
//     JsonEncoder encoder = new JsonEncoder.withIndent('  ');
//     String jsonString = encoder.convert(json.decode(jsonObject));
//     return jsonString;
//   }
// }
}
String formatDOB(value){
  return DateFormat('dd-MM-yy')
      .format(DateFormat('yy-MM-dd').parse(value));
  // var parsedDate = DateTime.parse(strDt);
  // return ("${parsedDate.day}/${parsedDate.month}/${parsedDate.year}");
}
String ttHoSo(id) {
  String tt;
  switch (id) {
    case 0:
      tt = "Đang xử lý";
      break;
    case 1:
      tt = "Đã hoàn thành";
      break;
    case 2:
      tt = "Đã quá hạn";
      break;
    case 3:
      tt = "Đang dự thảo VB";
      break;
    case 4:
      tt = "Đã được duyệt";
      break;
    case 5:
      tt = "Đã trả về ";
      break;

  }
  return tt;
}