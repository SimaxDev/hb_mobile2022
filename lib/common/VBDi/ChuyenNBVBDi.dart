import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:hb_mobile2021/common/VBDi/TreeFromJson.dart';
import 'package:hb_mobile2021/core/models/VanBanDenJson.dart';
import 'package:hb_mobile2021/core/services/VBDiService.dart';
import 'package:hb_mobile2021/core/services/VbdenService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'dart:convert';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';

class ChuyenNBVBDi extends StatefulWidget {
  final int id;
  final int nam;

  ChuyenNBVBDi({ this.id,this.nam});

  @override
  _ChuyenNBVBDiState createState() => _ChuyenNBVBDiState();
}

class _ChuyenNBVBDiState extends State<ChuyenNBVBDi> {
  final TreeController _treeController = TreeController(allNodesExpanded: false);
  String ActionXL1 = "GetTreeDonViV2";
  List chitiet = [];
  List<ListData1> listData;
  var existingItem;
  bool checkedValue = false;
  Map<String, String> lstUser = new Map<String, String>();
  String valueselected = "";
  bool isLoading = false;
  Map<String, bool> values = new Map<String, bool>();
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
  String textND = "";
  String lstUserCVBD="";


  @override
  void initState() {
    super.initState();
    var tendangnhap = sharedStorage.getString("username");
    GetDataDetailVBDi(tendangnhap);
  }

  @override
  void dispose(){
    super.dispose();
    lstUserCVBD;
    currentUserID;
    EasyLoading.dismiss();
  }
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(DateTime
            .now()
            .year - 5),
        lastDate: DateTime(DateTime
            .now()
            .year + 5));
    if (picked != null)
      if(mounted){
        setState(() {
          selectedDate = picked;
          _dateController.text = DateFormat.yMd().format(selectedDate);
        });
      }

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
    if(mounted){
      setState(() {
        chitiet = json.decode(detailVBDi)['OData'][0]['children'];
        values = GetTT(chitiet);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[buildTree()]);
  }


  Widget buildTreePhu() {
    var parsedJson;
    try {

        if(chitiet.length>0)
        {
          parsedJson = chitiet;
        }
        else{
          return Center(
            child: CircularProgressIndicator(),
          );

        }
        return parsedJson != null ? TreeView(
        nodes: toTreeNodes(parsedJson),
        treeController: _treeController,
      ) : Center(
        child:CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors
            .blue)) ,
      )
      ;
    } on FormatException catch (e) {
      return Text(e.message);
    }
  }

  /// Builds tree or error message out of the entered content.
  Widget buildTree() {
    _height = MediaQuery
        .of(context)
        .size
        .height;
    _width = MediaQuery
        .of(context)
        .size
        .width;
    try {
      var parsedJson = chitiet;
      return SingleChildScrollView(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Column(
              children: [
                Row(children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.16,
                    child: Text('Nhân sự:', style: TextStyle(fontWeight:
                    FontWeight
                        .bold),),
                  ),
                  FlatButton(
                    onPressed: () {
                      if(mounted){
                        setState(() {
                          if (parsedJson == null) {
                            return Center(
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                                ));
                          }
                          isClick1 = !isClick1;
                        });
                      }

                    },
                    child: Padding(padding: EdgeInsets.only(left: 3), child: Container(
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
                            child: textND == "" ? Text(
                              "Danh sách nhân sự",
                              style: TextStyle(
                                  color: Colors.black45
                              ),


                            ) :
                            Text(textND,
                              style: TextStyle(
                                  color: Colors.black45
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,

                            )
                        )
                    ),),
                  ),

                ],),


                isClick1
                    ? SizedBox()
                    : Container(
                  child: buildTreePhu(),
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
                        .width * 0.3,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.06,
                    child:TextButton.icon (
                        icon: Icon(Icons.send),
                        label: Text("Chuyển",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),textAlign:
                        TextAlign.center,),
                        onPressed: () async {
                          var tendangnhap = sharedStorage.getString("username");
                          String userList = lstUserCVBD;
                          EasyLoading.show();
                          var thanhcong = await postChuyenVBDi(tendangnhap,
                            widget.id, "SendVBDiNoiBo", userList,
                            currentUserID,widget.nam);
                          Navigator.of(context).pop();
                          userList = "";
                          currentUserID =0;
                          EasyLoading.dismiss();
                          showAlertDialog(context, json.decode(thanhcong)['Message']);
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
                        label: Text("Đóng",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),textAlign:
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

  int tti = 0;

  List<TreeNode> toTreeNodes(dynamic parsedJson) {
    if (parsedJson is Map<String, dynamic>) {
      String title11 = parsedJson['title'];
      return parsedJson.keys
          .map((k) =>
          TreeNode(
              content: Row(
                children: [
                  Icon(Icons.check_box_outline_blank),
                  SizedBox(
                    width: 10,
                  ),
                  Text(title11)
                ],
              ),
              children: toTreeNodes(parsedJson[k])))
          .toList();
    }
    if (parsedJson is List<dynamic>) {
      return parsedJson
          .asMap()
          .map((i, element) =>
          MapEntry(
            i,
            TreeNode(
                content: Row(
                  children: [
                    Center(
                      child: element['isUser']
                          ? Checkbox(
                        value: values[element['key'].toString() + (element['isUser'] ? "U" : "")],
                        onChanged: (bool value) {
                          if(mounted){
                            setState(() {
                              values[element['key'].toString() + (element['isUser'] ? "U" : "")] = value;
                            });
                          }

                          if (!(lstUser.length > 0) ||
                              (lstUser.length > 0 && !lstUser.containsKey(element["key"]))) {
                            lstUser.addAll({element["key"]: element["title"]});
                            bool s = !lstUserCVBD.toString().contains(element["key"] + ";|" + element["title"]);
                            print(s);
                            if (lstUserCVBD != null &&
                                !lstUserCVBD.toString().contains(element["key"] + ";|" + element["title"]))
                              lstUserCVBD = lstUserCVBD + element["key"] + ";|" + element["title"];
                            else
                              lstUserCVBD = element["key"] + ";|" + element["title"];

                            textND = textND + "," + element["title"];

                            if (textND.startsWith(","))
                              textND = textND.substring(1, textND.length);
                            var UserList = lstUser.toString();
                            // UserList =  lstUser91;
                          }
                          if (!values[element['key'].toString() + (element['isUser'] ? "U" : "")]) {
                            if (lstUserCVBD != null &&
                                lstUserCVBD.contains( element["key"] + ";|" + element["title"])) {
                              lstUser.remove(element["key"]);
                              lstUserCVBD =
                                  lstUserCVBD.replaceAll( element["key"] + ";|" + element["title"], "");
                              print(element["title"]);
                              if (textND.endsWith(","))
                                textND = textND.replaceAll(element["title"]+",", "");
                              else{

                                textND = textND.replaceAll(","+element["title"], "");
                              }
                              return textND = textND.replaceAll(element["title"], "");
                            } else if (lstUserCVBD.contains(element["key"] + ";|" + element["title"])) {
                              lstUser.remove(element["key"]);
                              lstUserCVBD = lstUserCVBD.replaceAll(element["key"] + ";|" + element["title"], "");
                            }
                          }

                          print(lstUserCVBD);
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
                children: toTreeNodes(parsedJson[i]['children'])),
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
