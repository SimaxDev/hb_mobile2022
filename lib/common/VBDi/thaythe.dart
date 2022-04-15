import 'dart:async';

import 'package:data_table_2/data_table_2.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hb_mobile2021/common/VBDi/TableUserTT.dart';
import 'package:hb_mobile2021/core/services/VBDiService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';
import 'dart:convert';

import 'package:json_table/json_table.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';



class ThayThe extends StatefulWidget {
  final int id;
  final String nam;

  ThayThe({this.id,this.nam});
  @override
  _ThayTheState createState() => _ThayTheState();
}

class _ThayTheState extends State<ThayThe> {
  final _sigInFormKey = GlobalKey<FormState>();
  final int _rowsPerPage = 5;
  double _height;
  double _width;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _titleController1 = TextEditingController();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  ScrollController _scrollerController = new ScrollController();
  String vbdi = "";
  var refreshKeyDS = GlobalKey<RefreshIndicatorState>();
  var jsonSample ;
  int skip = 1;
  int pageSize = 10;
  int skippage = 0;
  int ID = 0;
  bool showD = true;
  bool isLoading = true;
  List<String> Year = ["2022","2021", "2020", "2019", "2018", "2017"];
  String dropdownValue ="2022";
  String testthuhomerxoa;
  String ActionXL = "GetListVBDi";
  String  text1 = "";
  RxList productlist1 = [].obs;
  bool showLoadingIndicator = true;
  Timer _timer;
  List dataList = [];
  int selectedRadioTile;
  var tongso;
  bool chckSwitch = false;
  @override
  void initState() {
    super.initState();
    selectedRadioTile = 0;
    // if(_timer != null ){
    //   _timer.cancel();
    // }
    generateProductList();
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
  generateProductList() async {
    if(tongso != null)
      if ((tongso-(skip)*pageSize< 0)) {
        pageSize = tongso-(skip-1)*pageSize ;
      chckSwitch =true;
       return _buildProgressIndicator();

      } else {
        pageSize =10;}

    String vbtimkiem = await getDataHomeVBDiThayThe(skip, pageSize, ActionXL,dropdownValue,skippage);

    if(mounted){
      setState(() {
        // showD = false;
        dataList.addAll(json.decode(vbtimkiem)['OData']);
        skip++;
        skippage += 10;

        tongso = json.decode(vbtimkiem)['TotalCount'];
        isLoading = false;


        _scrollerController.addListener(() {
          if(chckSwitch != true){
            if (_scrollerController.position.pixels == _scrollerController.position.maxScrollExtent) {
              generateProductList();
              // GetDataByKeyYearVBDen(dropdownValue);
              dataList;
            }
          }

        });
      });
    }



  }
  GetDataByKeyWordVBDi(String text) async {
    var tendangnhap = sharedStorage.getString("username");
    String vbtimkiem = await getDataByKeyWordVBDi(tendangnhap, ActionXL,
      text,dropdownValue,"");
    setState(() {
      dataList = json.decode(vbtimkiem)['OData'];
      tongso = json.decode(vbtimkiem)['TotalCount'];
    });
  }

  GetDataByKeyYearVBDi(String year) async {
    var tendangnhap = sharedStorage.getString("username");
    String yeartimkiem = await getDataByKeyYearVBDi(tendangnhap, ActionXL,
        year,"",skip,pageSize);
    setState(() {
      dataList = json.decode(yeartimkiem)['OData'];
      skip++;
      isLoading == false;
      tongso = json.decode(yeartimkiem)['TotalCount'];

    });
  }


  Future<Null> onRefresh() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    return null;
  }


  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    final DataGridController _dataGridController = DataGridController();
    return Scaffold(
      //  key: _sigInFormKey,
        appBar: AppBar(title: Text("Thay thế văn bản"), automaticallyImplyLeading: false),
        body:  Container(color:Colors.white,
            child:Column(
            children: [
              Expanded(
                flex: 2,
                child: Column(
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
                      height: 5,
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
                      height: 5,
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
                                        style: TextStyle(color: Colors.black ),
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
                                                generateProductList();
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
                                            showD = false;
                                            // testthuhomerxoa = text1;
                                            // GetDataByKeyWordVBDi(testthuhomerxoa);
                                            GetDataByKeyWordVBDi
                                              (testthuhomerxoa);
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
                                        GetDataByKeyYearVBDi(dropdownValue);
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
                  ],
                ),
              ),
            Expanded(
              flex: 6,
            child:Container(
              child:
              UiGetData(),
            ) ,),
              Expanded(
              flex: 1,
            child:   Align(
                alignment: Alignment.bottomCenter,
                child:
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
                                  _titleController1.text.toString(),selectedRadioTile);
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
                )
            ),)







            ],
          ) ,)




    );
  }
  Widget UiGetData() {
    if (dataList== null || dataList.length < 0 || isLoading) {
      return Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ));
    } else if (dataList.length == 0) {
      return Center(
        child: Text("Không có bản ghi"),
      );
    }
    return RefreshIndicator( child:ListView.builder(
      itemCount: dataList == null ? 0 : dataList.length ,
      physics:
      ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if(index == tongso){
          _buildProgressIndicator();
        }else{
          return getBody(dataList[index]);
        }

      },
      controller: _scrollerController,
    ),onRefresh: refreshList,);
  }
  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    // setState(() {
    //   UiGetData();
    // });

    return null;
  }
  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget getBody(item) {
    var trichyeu = item['vbdiTrichYeu'] != null ?item['vbdiTrichYeu'] : "";
    var soKyHieu = item['vbdiSoKyHieu'] != null ?item['vbdiSoKyHieu']:"";
    //  var temp = DateFormat('yyyy-MM-dd').parse(item['vbdiNgayBanHanh']) ?? "";
    var ngayky  =item['vbdiNgayBanHanh'] != null ?DateFormat('dd-MM-yyyy')
        .format(DateFormat('yyyy-MM-dd').parse(item['vbdiNgayBanHanh'])):"";
    //= DateFormat('dd-MM-yyyy').format(temp);
    int id = item['ID'] != null?item['ID'] :0;
    int IDG =0;
    var MaDonVi = item['MaDonVi'] != null ? item['MaDonVi'] :"";

    //VanBanDiJson vbdi = vanBanDiJson(item.toString());
    return item['vbdiSoKyHieu'] == null || item['vbdiSoKyHieu'] == false || item['vbdiIsSentVanBan']  == false
        ?  RadioListTile(
      value: id,
    groupValue: selectedRadioTile,
      title:  Text(
        soKyHieu,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        trichyeu,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.blue,
          fontSize: 14,
        ),
      ),
      onChanged: (ID) {
        setState(() {
          selectedRadioTile = ID;
        });

      },
     // selected: selectedUser == id,
      activeColor: Colors.black87,
    ):
    RadioListTile(
      value: id,
      groupValue: selectedRadioTile,
      title:  Text(
        soKyHieu,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight:
        FontWeight.w600),
      ),
      subtitle: Text(
        trichyeu,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
      ),
      onChanged: (ID) {
        setState(() {
          selectedRadioTile = ID;
        });

      },
      // selected: selectedUser == id,
      activeColor: Colors.black,
    );
  }



}


