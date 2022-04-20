import 'dart:async';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/core/services/hoSoCVService.dart';
import 'package:hb_mobile2021/ui/hoSoCV/chiTietHSCV/cacTaiLieuK.dart';
import 'package:hb_mobile2021/ui/hoSoCV/chiTietHSCV/chiTietHSLQ.dart';
import 'package:hb_mobile2021/ui/hoSoCV/chiTietHSCV/vbDenLQ.dart';
import 'package:hb_mobile2021/ui/hoSoCV/chiTietHSCV/vbDiLQ.dart';
import 'package:hb_mobile2021/ui/hoSoCV/duaVaoHS/chiTiet.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'dart:convert';
import 'chiTietHSCV/ThongTinHSCV.dart';

class cayThongTinHSCV extends StatefulWidget {
  int idHS;
  String nam;
  final String title;
  final String idVBDlienQuan;



  cayThongTinHSCV({Key key, this.idHS, this.title,this.nam,this.idVBDlienQuan}) : super(key:
  key);

  @override
  _cayThongTinHSCVState createState() => _cayThongTinHSCVState();
}

class _cayThongTinHSCVState extends State<cayThongTinHSCV> {
  List dataListHSCV = [];
  bool checkedValue = false;
  bool checkedTree = false;
  bool isLoading = false;
  List chitiet = [];
  List chitietLQ = [];
  final TreeController _treeController =
  TreeController(allNodesExpanded: false);
  String ActionXL1 = "ChitietHSCVMenuLeftHSCVcon";
  String ch = "";
  List<String> bientoancuc = new List<String>();
  GlobalKey key =  new GlobalKey();
  var ay;
  double _height;
  int tongso = 0;


  @override
  void initState() {
    // TODO: implement initState
    //  if(getString("username"))
    //_initializeTimer();
    GetDataTreeCayHSCV();
    GetDataTreeHSLQ();
    super.initState();


  }
  void onToggleShowPass() {
    setState(() {
      checkedTree = !checkedTree;
      if(chitiet.length == 0)
      {
        isLoading = false;
      }
      else
        {
          isLoading = true;
        }
    });
  }


  @override
  void dispose(){
    super.dispose();
    strListId;
    strListVanBanLienQuanID;
    strListVanBanDiLienQuan;

  }

  Future GetDataTreeHSLQ() async {
    String detailVBDi1 = await postTreeCayHSCV(widget.idHS ,"GetVBDenLienQuan"
        "",widget.nam,"");

    setState(() {
      tongso = json.decode(detailVBDi1)['TotalCount'];
      checkedValue = false;
    //tongso = chitietLQ
    });
  }
  Future GetDataTreeCayHSCV() async {
    String detailVBDi = await postTreeCayHSCV(widget.idHS ,ActionXL1,"isCongV"
        "iec=false&isHoSocongviec=true",widget.nam);

    if(mounted)
      {
        setState(() {
          chitiet = json.decode(detailVBDi)['OData'];
          checkedValue = false;
          if( chitiet != null){
            for(var az in chitiet){
              ay =  az['Title'];
              bientoancuc.add(ay);

            }
          }

        });
      }

  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    return Scaffold(

      body: new ListView(
        padding: const EdgeInsets.all(0.0),
        children: <Widget>[
          SizedBox(height: 10,),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              "Cây hồ sơ công việc",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width*0.05 ,
                child:  IconButton(
                  onPressed: ()=> onToggleShowPass(),
                  icon: checkedTree== true ?Icon(Icons.arrow_drop_down):Icon
                    (Icons.arrow_right_outlined)
                  ,),
              ),
              Container(
                width: MediaQuery.of(context).size.width*0.5 ,
                child: ListTile(
                  title: Text(
                    widget.title,style: TextStyle(color: Colors.red),
                    maxLines: 2,
                    textAlign: TextAlign.start,
                  ),
                  leading: Image( width: MediaQuery.of(context).size.width*0.1 ,
                      alignment: Alignment.centerLeft,
                      image: AssetImage('assets/logo_vb.png')),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),


          checkedTree == true && isLoading == true? Container(
            margin: EdgeInsets.only(left: 55),
            width: MediaQuery.of(context).size.width ,
            height: _height/5.4,
            child: buildTree(),
          ):SizedBox(),

          Container(
              margin: EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Text(
                    "Các hồ sơ, văn bản liên quan ",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.greenAccent,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute
                        (builder: (context) =>ChiTietHSDuaVao()
                      ));
                    },
                  ),
                ],
              )),
          Stack(children: [
            Container(
                margin: EdgeInsets.only(left: 22),
                width: MediaQuery.of(context).size.width ,
                child:Column( key:key ,
                  children: [
                    strListId.length >0? ListTile(
                      title: Text(
                        "Hồ sơ liên quan",style: TextStyle(color: Colors.red),
                      ),
                      leading: Image(image: AssetImage('assets/logo_vb.png')),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => chiTietHSLQ(
                                id: widget.idHS,nam:widget.nam
                            ),
                          ),
                        );
                      },
                    ):SizedBox(),
                    strListVanBanLienQuanID.length>0 ? ListTile(
                      title: Text(
                        "Các văn bản đến liên quan",style: TextStyle(color: Colors
                          .red),
                      ),
                      leading: Image(image: AssetImage('assets/logo_vb.png')),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => vbDenLQ(
                                id: widget.idHS,nam:widget.nam,
                                idVBDlienQuan:widget.idVBDlienQuan
                            ),
                          ),
                        );
                      },
                    ):SizedBox(),
                    strListVanBanDiLienQuan.length>0? ListTile(
                      title: Text(
                        "Các văn bản đi liên quan",style: TextStyle(color: Colors
                          .red),
                      ),
                      leading: Image(image: AssetImage('assets/logo_vb.png')),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => vbDiLQ(
                                id: widget.idHS,nam:widget.nam
                            ),
                          ),
                        );
                      },
                    ):SizedBox(),
                  ],
                )
            )

          ],),

          InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => cacTaiLieuK(
                      id: widget.idHS,nam:widget.nam
                  ),
                ),
              );

            },
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                "Các tài liệu khác",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,),
              ),
            ) ,),
          InkWell(
            onTap: (){},
            child: Container(
              margin: EdgeInsets.only(left: 10,top:15),
              child: Text(
                "Kết quả công việc",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,),
              ),
            ) ,)

        ],
      ),

    );
  }

  Widget buildTree() {
    if (chitiet== null || chitiet.length < 0 || checkedValue) {
      return Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ));
    } else if (chitiet.length == 0) {

    }
      return ListView.builder(
        itemCount: chitiet == null ? 0 : chitiet.length,
        itemBuilder: (context, index) {
          return getBodyVB(chitiet[index],1);
        },
      );
  }
Widget getBodyVB(item,index) {
  var title = item['Title'] ?? "";
  return   Card(

    child: ListTile(
      title: Text(
        title,style: TextStyle(color: Colors.red),
      ),
      leading: Image(image: AssetImage('assets/logo_vb.png')),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => thongTinHSCV(
                idHS: widget.idHS,nam:widget.nam
            ),
          ),
        );
      },
    ),

  );
}

}
