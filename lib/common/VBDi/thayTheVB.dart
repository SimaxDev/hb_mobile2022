import 'package:data_table_2/data_table_2.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hb_mobile2021/common/VBDi/TableUserTT.dart';
import 'package:hb_mobile2021/core/services/VBDiService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/core/services/VBDuThaoService.dart';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';
import 'dart:convert';

import 'package:json_table/json_table.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';



class JsonDataGrid extends StatefulWidget {
  final int id;
  final String nam;

  JsonDataGrid({this.id,this.nam});
  @override
  _JsonDataGridState createState() => _JsonDataGridState();
}

class _JsonDataGridState extends State<JsonDataGrid> {
  _JsonDataGridSource jsonDataGridSource;
  _JsonDataGridSource jsonDataGridSource1;
  List<_Product> productlist11 = [];
  List<_Product> productlist22 = [];
  final _sigInFormKey = GlobalKey<FormState>();
  final int _rowsPerPage = 5;
  double _height;
  double _width;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _titleController1 = TextEditingController();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  String vbdi = "";
  var refreshKeyDS = GlobalKey<RefreshIndicatorState>();
  var jsonSample ;
  int ID = 0;
  bool showD = true;
  List<String> Year = ["2022","2021", "2020", "2019", "2018", "2017"];
  String dropdownValue ="2022";
  String testthuhomerxoa;
  String ActionXL = "GetListVBDi";
  String text1 = "";
  RxList productlist1 = [].obs;
  bool showLoadingIndicator = true;


  @override
  void initState() {
    super.initState();
    var ddd = generateProductList(text1);
    //dropdownValue =   widget.nam;
    setState(() {
    });
  }
  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();


  }
  generateProductList(String text) async {
    if(mounted){
      setState(() {
        showD = false;
      });
    }

    //vbdi = await getTT(ActionXL,text, dropdownValue);
    vbdi =  await getDataByKeyWordVBDT("huongvt.ubnd", "GetListVBDT",
        text,dropdownValue,"");

    jsonSample = jsonDecode(vbdi)['OData'];
      var list = jsonSample.cast<Map<String, dynamic>>();
      productlist1.value =
          await list.map<_Product>((json) => _Product.fromJson(json)).toList();
      // if(mounted){
      //   setState(() {
      //     jsonDataGridSource = _JsonDataGridSource(productlist);
      //   });
      // }


    jsonDataGridSource = _JsonDataGridSource(productlist1.value);

    return productlist1;

  }

   GetDataByKeyWordVBDi(String text) async {

    setState(() {
      showD = false;
    });

    var tendangnhap = sharedStorage.getString("username");
   // EasyLoading.show();
    vbdi = await await getDataByKeyWordVBDT(tendangnhap, "GetListVBDT",
        text,dropdownValue,"");
      jsonSample = jsonDecode(vbdi)['OData'];

    var list = jsonSample.cast<Map<String, dynamic>>();
    productlist1.value =
    await list.map<_Product>((json) => _Product.fromJson(json)).toList();
    jsonDataGridSource = _JsonDataGridSource(productlist1.value);
    //productlist = productlist;
    return productlist1;
  }



  List<GridColumn> getColumns() {
    List<GridColumn> columns;
    columns = ([
      GridColumn(
        columnName: 'orderID',
        width: 100,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            'Số KH',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'employeeID',
        //width: 200,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            'Trích yếu',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),

      GridColumn(
        columnName: 'ID',visible: false,
        width: 0,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(''),
        ),
      ),
    ]);
    return columns;
  }

  Future<Null> onRefresh() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    //jsonDataGridSource;
    jsonDataGridSource;

    return null;
  }


  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    final DataGridController _dataGridController = DataGridController();
    return Scaffold(
        key: _sigInFormKey,
        appBar: AppBar(title: Text("Thay thế văn bản"), automaticallyImplyLeading: false),
        body: RefreshIndicator(
          child: SingleChildScrollView(child:Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Theme(
                  data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                  child: TextField(
                    autofocus: false,
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black),
                    controller: _titleController1,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.add, color: Colors.black26, size: 22.0),
                      filled: true,
                      fillColor: Color(0x162e91),
                      hintText: 'Nhập ý kiến ',
                      contentPadding: EdgeInsets.only(left: 10.0, top: 15.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black26),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black26),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onChanged: null,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  "Chọn văn bản thay thế",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,

                children: [
                  Row(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.06,
                          margin: EdgeInsets.all(10),
                          // padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black26, // Set border color
                            ), // Set border width
                            borderRadius: BorderRadius.all(Radius.circular(10.0)), // Set rounded corner radius
                            // Make rounded corner of border
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.48,
                                padding: const EdgeInsets.all(5.0),
                                child: TextField(
                                  //autofocus: true,
                                  cursorColor: Colors.black26,
                                  style: TextStyle(color: Colors.black26 ),
                                  controller: _titleController,

                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 17),
                                    hintText: 'Tìm kiếm',
                                    prefixIcon: Icon(Icons.search, color: Colors.black26, size: 20.0),
                                    suffixIcon:      !showD
                                        ? InkWell(
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        width: MediaQuery.of(context).size.width * 0.07,

                                        child: Text(
                                          "X",
                                          textAlign: TextAlign.end,
                                          style: TextStyle( fontSize: 18, color: Colors.black, fontWeight:
                                          FontWeight.bold),
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _titleController.text = "";
                                          testthuhomerxoa = "";

                                          showD = true;
                                        });
                                      },
                                    )
                                        : SizedBox(),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(left: 0.0, top: 5.0,),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      testthuhomerxoa = val;
                                     // testthuhomerxoa = text1;

                                    generateProductList(testthuhomerxoa);
                                    setState(() {
                                     });

                                  });
                                  },
                                ),
                              ),

                            ],
                          )),
                      Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black26, // Set border color
                            ), // Set border width
                            borderRadius: BorderRadius.all(Radius.circular(10.0)), // Set rounded corner radius
                            // Make rounded corner of border
                          ),

                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.06,
                          margin: EdgeInsets.only(right: 5),
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            // icon: const Icon(Icons.arrow_downward),
                            // iconSize: 24,
                            //elevation: 16,
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                            underline: Container(
                              height: 1,
                              color: Colors.white70,
                            ),
                            onChanged: (String newValue) {
                              if(mounted){
                                setState(() {
                                  dropdownValue = newValue;
                                  // GetDataByKeyYearVBDi(dropdownValue);
                                });
                              }

                            },
                            items: Year.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                  value: value,
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: Text(value),
                                  ));
                            }).toList(),
                          ))
                    ],
                  ),
                ],
              ),
            Container(
                child:
                getbody(),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, right: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.lightBlue[50], width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: TextButton.icon(
                          icon: Icon(Icons.delete_forever_outlined),
                          label: Text(
                            "Đóng",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.lightBlue[50], width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: TextButton.icon(
                          icon: Icon(Icons.send_outlined),
                          label: Text(
                            "Thay thế",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () async {
                            var thanhcong = null;
                            var tendangnhap = sharedStorage.getString("username");
                            EasyLoading.show();
                            thanhcong =  await postThayTheVB(tendangnhap,
                                widget.id, "ThayTheVB",widget.nam,
                                _titleController1.text.toString(),ID);
                            EasyLoading.dismiss();
                            Navigator.of(context).pop();

                            showAlertDialog(context, json.decode(thanhcong)['Message']);

                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue[50]),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ) ,),
          onRefresh: onRefresh,
        )


    );
  }

  Widget getbody(){

    return FutureBuilder(
        future: generateProductList(text1),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.hasData == true
              ? Column(children: [
            SizedBox(
             height: MediaQuery.of(context).size.height* 0.4,
             child:  SfDataGrid(
               source: jsonDataGridSource,
               columns: getColumns(),
               highlightRowOnHover: false ,
               columnWidthMode: ColumnWidthMode.fill,
               selectionMode:SelectionMode.single ,
               onCellTap: (DataGridCellTapDetails details) {

                 if (details.rowColumnIndex.rowIndex == 0) return;



               },
               onSelectionChanged: (addedRows, removedRows)  {

                 ID = int.parse(addedRows[0].getCells()[2].value) ;

               },


               // onRowSelect: (index, map) {
               //   // print(index);
               //   //print(map);
               //   // print(map['ID']);
               //
               // },

             ),),

            SizedBox(),
           Obx(()=>SfDataPager
             (
             pageCount: productlist1.length >0?productlist1.length /
                 _rowsPerPage:1,
             // direction: Axis.horizontal,
             //pageCount:1,
             // delegate: jsonDataGridSource,
             delegate: jsonDataGridSource,
           ),
           ),


          ],)
              : Center(
            child: CircularProgressIndicator(
              strokeWidth: 1,
            ),
          );
        });
  }


}

class _Product {
  factory _Product.fromJson(Map<String, dynamic> json) {
    return _Product(
      orderID: json['vbdiSoKyHieu'],
      employeeID: json['vbdiTrichYeu'],
      ID: json['ID'].toString(),
    );
  }

  _Product({this.orderID,
    this.employeeID,
    this.ID,
  });

  String orderID;

  String employeeID;

  String ID;
}

class _JsonDataGridSource extends DataGridSource {
  _JsonDataGridSource(this.productlist) {
    buildDataGridRow();
  }

  List<DataGridRow> dataGridRows = [];
 List<_Product> productlist = [];

  void buildDataGridRow() {
    dataGridRows = productlist.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'orderID', value: dataGridRow.orderID),

        DataGridCell<String>(
            columnName: 'employeeID', value: dataGridRow.employeeID),

        DataGridCell<String>(columnName: 'ID', value: dataGridRow.ID),

      ]);
    }).toList(growable: false);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return row == 0?Container():   DataGridRowAdapter
      (cells: [
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[0].value != null? row.getCells()[0].value
              .toString():"",
          style: TextStyle(fontSize: 13),
          //  overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[1].value,
          style: TextStyle(fontSize: 13),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[2].value.toString(),
          style: TextStyle(fontSize: 13),
          //overflow: TextOverflow.ellipsis,
        ),
      ),

    ]);
  }
  String formatDOB(value){
    return DateFormat('dd-MM-yy')
        .format(DateFormat('yy-MM-dd').parse(value));
    // var parsedDate = DateTime.parse(strDt);
    // return ("${parsedDate.day}/${parsedDate.month}/${parsedDate.year}");
  }
}
