import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:hb_mobile2021/core/services/VBDiService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'dart:convert';




class TreeFromJson extends StatefulWidget {


  TreeFromJson({lstUserCVBi});


  @override
  _TreeFromJsonState createState() => _TreeFromJsonState();
}

class _TreeFromJsonState extends State<TreeFromJson> {
  final TreeController _treeController =
  TreeController(allNodesExpanded: false);
  String ActionXL1 = "GetTreeDonViLTKhacUBND";
  List chitiet = [];
  late List<ListData1> listData;
  var existingItem;
  bool checkedValue = false;
  Map<String, String> lstUser = new Map<String, String>();
  Map<String, bool> valueselected = new Map<String, bool>();
  Map<String, bool> values = new Map<String, bool>();
  var ax;
  String ch = "";


late String  lst;


  @override
  void initState() {

    super.initState();
    checkedValue = true;
    setState(() {
      var tendangnhap = sharedStorage!.getString("username");
      GetDataDetailVBDi(tendangnhap!);

    });


  }
  @override
  void dispose() {
    super.dispose();
    currentUserID;
    lstvbdiNoiNhan ="";

  }

  Future GetDataDetailVBDi(String tendangnhap) async {
    String detailVBDi = await getDataCVB(tendangnhap, ActionXL1);

    setState(() {
      chitiet = json.decode(detailVBDi)['OData'][0]['children'];
      for(var az in chitiet){
       ax =  az['children'];
       for( var ab in az['children'] )
         {
         String ay =  ab['groupParent'];
         bientoancuc.add(ay);
         }

      }

      values = GetTT(chitiet);
      valueselected =  GetTTCheckbox(chitiet);
      checkedValue = false;
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
  Map<String, bool> GetTTCheckbox(List TT) {
    Map<String, bool> vls = new Map<String, bool>();
    for (int i = 0; i < TT.length; i++) {
      String vl = "";
      if (TT[i]["isUser"]) {
        vl = TT[i]['groupParent'].toString();
      } else
        vl = TT[i]['groupParent'].toString();
      tong++;
      vls.putIfAbsent(vl, () => false);
      if (TT[i]["children"].length > 0) {
        vls.addAll(GetTT(TT[i]["children"]));
      }
    }
    return vls;
  }

  @override
  Widget build(BuildContext context) {
    Size size =  MediaQuery.of(context).size;
    return
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
Container(
  width: MediaQuery.of(context).size.width ,
  child: buildTree(),
)


        ]
        ,
      );


  }

  Widget buildTree() {
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

      if (parsedJson == null || parsedJson.length < 0 || checkedValue) {
        return Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ));
      } else if (parsedJson.length == 0) {
        return
          Container(
            child: Center(child: Text("Không có bản ghi"),)
          );


      }
      return  TreeView(
        nodes: toTreeNodes(parsedJson),
        treeController: _treeController,

      );
    } on FormatException catch (e) {
      return Text(e.message);
    }
  }


  List<TreeNode> toTreeNodes(dynamic parsedJson) {

    if (parsedJson is Map<String, dynamic>) {
      String title11 = parsedJson['title'];
      return parsedJson.keys
          .map((k) =>
          TreeNode(
              content: Row(children: [
                Icon(Icons.check_box_outline_blank),
                SizedBox(width: 10,),
                Text(title11)
              ],),
              children: toTreeNodes(parsedJson[k])
          )).toList();
    }

    for( String chx in bientoancuc){
      ch = chx;
      if (parsedJson is List<dynamic>) {

        return
          parsedJson
              .asMap()
              .map((i, element) =>
              MapEntry(i,
                  TreeNode(content:
                  Row(
                    children: [
                      Checkbox(
                        value: values[element['key'].toString()]  ,
                        onChanged: ( value) {
                          setState(() {

                             values[element['key'].toString()] = value!;
                          });



                          if (!(lstUser.length > 0) || (lstUser.length > 0 && !lstUser.containsKey(element["key"]))) {
                            lstUser.addAll({element["key"]: element["title"]});
                            bool s =!lstUserCVBi.toString().contains(element["key"]+";|" + element["title"]);

                            if(lstUserCVBi != null && !lstUserCVBi.toString().contains(element["key"]+";|"+
                                element["title"]))
                              {
                                lstUserCVBi = lstUserCVBi + "^"+element["key"]+";|"+ element["title"];
                                lstvbdiNoiNhan = lstvbdiNoiNhan + "," +element["key"];
                              }
                            else
                              {
                                lstUserCVBi = element["key"]+";|"+ element["title"];
                                lstvbdiNoiNhan = element["key"];
                              }


                            var UserList = lstUser.toString();
                            // UserList =  lstUser1;
                          }
                          if(!values[element['key'].toString()]!){
                            if(lstUserCVBi!=null && lstUserCVBi.contains("^"+element["key"]+";|"+element["title"])){
                              lstUser.remove(element["key"]);
                              lstUserCVBi = lstUserCVBi.replaceAll("^"+element["key"]+";|"+ element["title"], "");

                            }
                            else if(lstUserCVBi.contains(element["key"]+";|"+element["title"])){
                              lstUser.remove(element["key"]);
                              lstUserCVBi = lstUserCVBi.replaceAll(element["key"]+";|"+ element["title"], "");


                            }
                          }

                        },

                      ) ,
                      // ),
                      Container(
                        width: 200,
                        // width:  MediaQuery.of(context).size.width * 0.45,
                        child:   Text(
                          parsedJson[i]['title'],
                          style: TextStyle(fontSize: 13),
                          maxLines:3,
                        ),),
                      SizedBox(width: 0,),
                    ],),
                    children:toTreeNodes(parsedJson[i]['children']),

                  )
              ))
              .values
              .toList();
      }
    }

    return [TreeNode(content: Text(parsedJson.toString(),style:TextStyle(fontWeight: FontWeight.bold),),)];
  }
}

class ListData1 {
  String text;
  String ID;

  ListData1({required this.text, required this.ID});

  factory ListData1.fromJson(Map<String, dynamic> json) {
    return ListData1(ID: (json['key']), text: json['title']);
  }
}

