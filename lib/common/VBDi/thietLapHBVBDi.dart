import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:hb_mobile2021/core/services/VBDiService.dart';
import 'package:hb_mobile2021/core/services/VbdenService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'dart:convert';

import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';

class thietLapHBVBDi extends StatefulWidget {
  final int id;
  final int nam;

  thietLapHBVBDi({this.id,this.nam});

  @override
  _thietLapHBVBDiState createState() => _thietLapHBVBDiState();
}

class _thietLapHBVBDiState extends State<thietLapHBVBDi> {
  final TreeController _treeController = TreeController(allNodesExpanded: false);
  String ActionXL1 = "GetTreeDonViV2";
  List chitiet = [];
  List<ListData1> listData;
  var existingItem;
  bool checkedValue = false;
  Map<String, String> lstUser = new Map<String, String>();
  Map<String, String> lstUserCBXDB = new Map<String, String>();
  String valueselected = "";
  Map<String, int> valuesRadio = new Map<String, int>();
  Map<String, bool> values = new Map<String, bool>();
  String textXLC = "";
  String lst;
  double _height;
  double _width;
  DateTime _dateTime;
  DateTime selectedDate = DateTime.now();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  String _setDate;
  String _setDate1;
  bool PH = false;
  bool isClick = true;
  bool isClick1 = true;
  bool isClick2 = true;
  bool isLoading = false;
  String lstUserXLC = "";
  String cayPH = "";
  String cayXLC = "";



  @override
  void initState() {
    super.initState();
    var tendangnhap = sharedStorage.getString("username");
    GetDataDetailVBDi(tendangnhap);
  }

  @override
  void dispose()
  {
    super.dispose();
    _dateController;
    _dateController.text;
    EasyLoading.dismiss();
  }
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
  }

  int tong = 0;

  Map<String, bool> GetTT(List TT) {
    Map<String, bool> vls = new Map<String, bool>();
    for (int i = 0; i < TT.length; i++) {
      String vl = "";
      if (TT[i]["isUser"]) {
        vl = TT[i]['key'].toString() + "U";
      } else
        vl = TT[i]['key'].toString();
      tong++;
      vls.putIfAbsent(vl, () => false);
      if (TT[i]["children"].length > 0) {
        vls.addAll(GetTT(TT[i]["children"]));
      }
    }
    return vls;
  }

  Future GetDataDetailVBDi(String tendangnhap) async {
    String detailVBDi = await getDataCVBD(tendangnhap, ActionXL1);
    setState(() {
      chitiet = json.decode(detailVBDi)['OData'][0]['children'];
      values = GetTT(chitiet);

    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[buildTree()]);
  }

  Widget buildTreeCBC() {
    var parsedJson;
    try {
      if(chitiet.length>0)
      {
        parsedJson = chitiet;
      }
      else{
        return CircularProgressIndicator();
      }

      return TreeView(
        nodes: toTreeNodesRadio(parsedJson),
        treeController: _treeController,
      );
    } on FormatException catch (e) {
      return Text(e.message);
    }
  }


  /// Builds tree or error message out of the entered content.
  Widget buildTree() {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    try {
      var parsedJson = chitiet;
      return SingleChildScrollView(
        child: Column(

          children: [
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
               Row(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Text("Hạn hồi báo"),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: InkWell(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: Container(
                            width: _width /1.7,
                            height: _height / 20,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: TextFormField(
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                              enabled: false,
                              keyboardType: TextInputType.text,
                              controller: _dateController == null ? selectedDate : _dateController,
                              // onSaved: (val) {
                              //   _setDate1 = val;
                              // },
                              decoration: InputDecoration(
                                  disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                  // labelText: 'Time',
                                  contentPadding: EdgeInsets.only(bottom: 15.0)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                SizedBox(height: 10,),
                Row(
                  children: [

                    Container(

                      margin: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 0.18,
                      child: Text('Người theo dõi:',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          isClick = !isClick;
                        });
                      },
                      child: Padding(padding: EdgeInsets.only(left: 15),
                        child: Container(

                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.6,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.05,
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Align(
                              child: textXLC == "" ? Text(
                                "Chọn người theo dõi",
                                style: TextStyle(
                                    color: Colors.black45
                                ),


                              ) :
                              Text(textXLC,
                                style: TextStyle(
                                    color: Colors.black45
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,

                              )
                          )
                      ),),
                    ),
                  ],
                ),
                isClick
                    ? SizedBox()
                    : Container(
                  child: buildTreeCBC(),
                ),

                // Container()
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.only(top: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue[50], width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.4,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.06,
                    child:TextButton.icon (
                        icon: Icon(Icons.send_outlined),
                        label: Text("Thiết lập",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
                          textAlign:
                          TextAlign.center,),
                        onPressed: () async {
                          if(tti == null || tti == ""){
                            showAlertDialog(context,"Chọn người theo dõi");
                          }
                          else
                          {
                            var tendangnhap = sharedStorage.getString("username");
                            EasyLoading.show();
                            var thanhcong =  await postHoiBaoVBDi
                              (tendangnhap, widget.id, "ThietLapHoiBao",
                                _dateController.text.toString(),tti,widget.nam);
                            EasyLoading.dismiss();
                           Navigator.of(context).pop();
                            showAlertDialog(context, json.decode(thanhcong)['Message']);
                          }

                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue[50]),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        )
                    ),),
                ),
                Padding(padding: EdgeInsets.only(top: 10,left: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue[50], width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.25,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.06,
                    child:TextButton.icon (
                        icon: Icon(Icons.delete_forever_outlined),
                        label: Text("Huỷ",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),textAlign:
                        TextAlign.center,),
                        onPressed: ()  {
                         Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        )
                    ),),
                ),

              ],),

          ],
        ),
      );
    } on FormatException catch (e) {
      return Text(e.message);
    }
  }

  String tti ;
  String radioItemHolder;


  List<TreeNode> toTreeNodesRadio(dynamic parsedJson) {
    if (parsedJson is Map<String, dynamic>) {
      String title11 = parsedJson['title'];
      return parsedJson.keys
          .map((k) => TreeNode(
          content: Row(
            children: [
              Icon(Icons.radio_button_checked),
              SizedBox(
                width: 10,
              ),
              Text(title11)
            ],
          ),
          children: toTreeNodesRadio(parsedJson[k])))
          .toList();
    }
    if (parsedJson is List<dynamic>) {
      return parsedJson
          .asMap()
          .map((i, element) => MapEntry(
        i,
        TreeNode(
            content: Row(
              children: [
                Center(
                  child: element['isUser']
                      ? Radio(
                    groupValue:tti ,
                    value:element['key'],
                    onChanged: ( _value)  {

                      setState(() {
                        radioItemHolder = element['title'] ;
                        tti = element['key'];
                        textXLC =  radioItemHolder;
                        lstUserXLC =   element["key"] + ";|" + element["title"];
                      });
                      print(radioItemHolder);
                      print("tit" + tti);
                      cayXLC =  tti;
                      print("Xử lý chính" + lstUserXLC);
                      isClick = true;
                    },
                  )
                      : SizedBox(),
                ),
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.45,
                  child: Text(parsedJson[i]['title']),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            children: toTreeNodesRadio(parsedJson[i]['children'])
        ),
      ))
          .values
          .toList();
    }
    return [TreeNode(content: Text(parsedJson.toString()))];
  }
}

class ListData1 {
  String text;
  String ID;

  ListData1({@required this.text, @required this.ID});

  factory ListData1.fromJson(Map<String, dynamic> json) {
    return ListData1(ID: (json['key']), text: json['title']);
  }
}
