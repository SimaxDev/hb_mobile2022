import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:hb_mobile2021/core/services/VbdenService.dart';
import 'dart:convert';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';


class GiaoViecCN extends StatefulWidget {
  final int id;
  final int nam;

  GiaoViecCN({required this.id,required this.nam});

  @override
  _GiaoViecCNState createState() => _GiaoViecCNState();
}

class _GiaoViecCNState extends State<GiaoViecCN> {
  final TreeController _treeController = TreeController(allNodesExpanded: false);
  String ActionXL1 = "GetTreeDonViV2";
  List chitiet = [];
  late List<ListData1> listData;
  var existingItem;
  bool checkedValue = false;
  Map<String, String> lstUser = new Map<String, String>();
  Map<String, String> lstUserCBXDB = new Map<String, String>();
  String valueselected = "";
  Map<String, int> valuesRadio = new Map<String, int>();
  Map<String, bool> values = new Map<String, bool>();
  Map<String, bool> valuesPH = new Map<String, bool>();
  Map<String, bool> valuesXDB = new Map<String, bool>();
  String textXLC = "";
  String textPH = "";
  String textXDB = "";
  late String lst;
  late double _height;
  late double _width;
  DateTime selectedDate = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  bool PH = false;
  bool isClick = true;
  bool isClick1 = true;
  bool isClick2 = true;
  bool isLoading = false;
  String lstUserPH  =  "";
  String lstUserXDB  =  "";
  String lstUserXLC = "";
  String cayPH = "";
  String cayXLC = "";
  String cayXDB = "";
  String selcb = "";

  @override
  void initState() {
    super.initState();

    GetDataDetailVBDi();
  }
  @override
  void dispose() {
    super.dispose();
    currentUserID;
    lstUserXLC;
    lstUserXDB ;
    lstUserXLC ;
    lstUserPH ;
    selcb ;
    EasyLoading.dismiss();
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

  Future GetDataDetailVBDi() async {
    String detailVBDi = await getDataCVBD1( ActionXL1);
    if (mounted) { setState(() {
      chitiet = json.decode(detailVBDi)['OData'][0]['children'];
      values = GetTT(chitiet);
      valuesPH = GetTT(chitiet);
      valuesXDB = GetTT(chitiet);

    });}

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
      else
      {
        return Center(
          child: CircularProgressIndicator() ,);
      }

      return TreeView(
        nodes: toTreeNodesRadio(parsedJson),
        treeController: _treeController,
      );
    } on FormatException catch (e) {
      return Text(e.message);
    }
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
          child: CircularProgressIndicator() ,);
      }

      return parsedJson != null
          ? TreeView(
        nodes: toTreeNodesPH(parsedJson),
        treeController: _treeController,
      )
          : CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue));
    } on FormatException catch (e) {
      return Text(e.message);
    }
  }
  Widget buildTreePhuXDB() {
    var parsedJson;
    try {
      if(chitiet.length>0)
      {
        parsedJson = chitiet;
      }
      else{
        return Center(
          child: CircularProgressIndicator() ,);
      }

      return parsedJson != null
          ? TreeView(
        nodes: toTreeNodesXDB(parsedJson),
        treeController: _treeController,
      )
          : CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue));
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
          // mainAxisAlignment: MainAxisAlignment.end,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(

                      margin: EdgeInsets.only(left: 15),
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: Text('Người chủ trì:', style: TextStyle
                        (fontWeight:
                      FontWeight.bold,fontSize: 13)),
                    ),
                    TextButton(
                      onPressed: () {
                        if (mounted) { setState(() {
                          isClick = !isClick;
                        }); }

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
                              child: textXLC == "" ? Text(
                                "Chọn người chủ trì",
                                style: TextStyle(
                                    color: Colors.black45
                                ),


                              ) :
                              Text(textXLC,
                                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
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
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  child: buildTreeCBC(),
                ),

                // Container()
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: Text(
                        'Người theo dõi:',
                        style: TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (mounted) {setState(() {
                          isClick1 = !isClick1;
                        }); }

                      },
                      child: Padding(padding: EdgeInsets.only(left: 3),
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
                                child: textPH == "" ? Text(
                                  "Chọn người theo dõi",
                                  style: TextStyle(
                                      color: Colors.black45
                                  ),


                                ) :
                                Text(textPH,
                                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,

                                )
                            )
                        ),),
                    ),
                  ],
                ),

                isClick1
                    ? SizedBox()
                    : Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  child: buildTreePhu(),
                ),

                // Container()
              ],
            ),


          ],
        ),
      );
    } on FormatException catch (e) {
      return Text(e.message);
    }
  }

   String? tti ;
   String? radioItemHolder;

  List<TreeNode> toTreeNodesPH(dynamic parsedJson) {
    if (parsedJson is Map<String, dynamic>) {
      String title11 = parsedJson['title'];
      return parsedJson.keys
          .map((k) => TreeNode(
          content: Row(
            children: [
              Icon(Icons.check_box_outline_blank),
              SizedBox(
                width: 10,
              ),
              Text(title11)
            ],
          ),
          children: toTreeNodesPH(parsedJson[k])))
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
                  child: element['isUser'] && tti  != element['key']
                      ? Checkbox(
                    value: valuesPH[element['key'].toString() + (element['isUser'] ? "U" : "")],
                    onChanged: ( value) {

                      if (mounted) {  setState(() {
                        valuesPH[element['key'].toString() + (element['isUser'] ? "U" : "")] = value!;
                      }); }

                      if (!(lstUser.length > 0) ||
                          (lstUser.length > 0 && !lstUser.containsKey(element["key"]))) {
                        lstUser.addAll({element["key"]: element["title"]});
                        bool s = !lstUserPH.toString().contains(element["key"] + ";|" + element["title"]);

                        if (lstUserPH != null &&
                            !lstUserPH.toString().contains(element["key"] + ";|" + element["title"]))
                          lstUserPH = lstUserPH + "^" + element["key"] + ";|" + element["title"];
                        else
                          lstUserPH = element["key"] + ";|" + element["title"];

                        textPH = textPH + "," + element["title"];

                        if (textPH.startsWith(","))
                          textPH = textPH.substring(1, textPH.length);
                        var UserList = lstUser.toString();
                        // UserList =  lstUser91;
                      }
                      if (!valuesPH[element['key'].toString() + (element['isUser'] ? "U" : "")]!) {
                        if (lstUserPH != null &&
                            lstUserPH.contains("^" + element["key"] + ";|" + element["title"])) {
                          lstUser.remove(element["key"]);
                          lstUserPH =
                              lstUserPH.replaceAll("^" + element["key"] + ";|" + element["title"], "");
                          cayPH= cayPH.replaceAll(element["key"]+ ",", "");
                          if (textPH.endsWith(","))
                            textPH = textPH.replaceAll(element["title"]+",", "");
                          else{

                            textPH = textPH.replaceAll(","+element["title"], "");
                          }
                         // return textPH = textPH.replaceAll(element["title"], "");
                           textPH = textPH.replaceAll(element["title"], "");
                        } else if (lstUserPH.contains(element["key"] + ";|" + element["title"])) {
                          lstUser.remove(element["key"]);
                          lstUserPH = lstUserPH.replaceAll(element["key"] + ";|" + element["title"], "");
                        }
                      }
                      cayPH += element["key"]+",";
                      idNTD = cayPH;

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
            children: toTreeNodesPH(parsedJson[i]['children'])),
      ))
          .values
          .toList();
    }
    return [TreeNode(content: Text(parsedJson.toString()))];
  }
  List<TreeNode> toTreeNodesXDB(dynamic parsedJson) {
    if (parsedJson is Map<String, dynamic>) {
      String title11 = parsedJson['title'];
      return parsedJson.keys
          .map((k) => TreeNode(
          content: Row(
            children: [
              Icon(Icons.check_box_outline_blank),
              SizedBox(
                width: 10,
              ),
              Text(title11)
            ],
          ),
          children: toTreeNodesXDB(parsedJson[k])))
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
                  child: element['isUser'] && tti != element['key']
                      ? Checkbox(
                    value: valuesXDB[element['key'].toString() + (element['isUser'] ? "U" : "")],
                    onChanged: ( value) {
                      if (mounted) { setState(() {
                        valuesXDB[element['key'].toString() + (element['isUser'] ? "U" : "")] = value!;
                      }); }

                      if (!(lstUserCBXDB.length > 0) ||
                          (lstUserCBXDB.length > 0 && !lstUserCBXDB.containsKey(element["key"]))) {
                        lstUserCBXDB.addAll({element["key"]: element["title"]});
                        bool s = !lstUserXDB.toString().contains(element["key"] + ";|" + element["title"]);

                        if (lstUserXDB != null &&
                            !lstUserXDB.toString().contains(element["key"] + ";|" + element["title"]))
                          lstUserXDB = lstUserXDB + "^" + element["key"] + ";|" + element["title"];
                        else
                          lstUserXDB = element["key"] + ";|" + element["title"];
                        textXDB = textXDB + "," + element["title"];

                        if (textXDB.startsWith(","))
                          textXDB = textXDB.substring(1, textXDB.length);
                        var UserList = lstUserCBXDB.toString();
                        // UserList =  lstUser91;
                      }
                      if (!valuesXDB[element['key'].toString() + (element['isUser'] ? "U" : "")]!) {
                        if (lstUserXDB != null &&
                            lstUserXDB.contains("^" + element["key"] + ";|" + element["title"])) {
                          lstUserCBXDB.remove(element["key"]);
                          lstUserXDB =
                              lstUserXDB.replaceAll("^" + element["key"] + ";|" + element["title"], "");

                          if (textXDB.endsWith(","))
                            textXDB = textXDB.replaceAll(element["title"]+",", "");
                          else{

                            textXDB = textXDB.replaceAll(","+element["title"], "");
                          }
                           textXDB = textXDB.replaceAll(element["title"], "");
                         // return textXDB = textXDB.replaceAll(element["title"], "");
                        } else if (lstUserXDB.contains(element["key"] + ";|" + element["title"])) {
                          lstUserCBXDB.remove(element["key"]);
                          lstUserXDB = lstUserXDB.replaceAll(element["key"] + ";|" + element["title"], "");
                        }
                      }
                      cayXDB += element["key"]+",";
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
            children: toTreeNodesXDB(parsedJson[i]['children'])),
      ))
          .values
          .toList();
    }
    return [TreeNode(content: Text(parsedJson.toString()))];
  }

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
                      ? Radio<String>(
                    groupValue:tti ,
                    value:element['key'],
                    onChanged: ( _value) {
                      if (mounted) {    setState(() {
                        radioItemHolder = element['title'] ;
                        tti = element['key'];
                        textXLC =  radioItemHolder!;
                        lstUserXLC =   element["key"] + ";|" + element["title"];
                        isClick= true;
                      });}


                      idCT = tti!;
                      cayXLC =  tti!;

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

  ListData1({required this.text, required this.ID});
}