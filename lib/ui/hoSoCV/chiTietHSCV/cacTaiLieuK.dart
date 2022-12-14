import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hb_mobile2021/common/HoSoCV/coQuanBH.dart';
import 'package:hb_mobile2021/common/HoSoCV/loaiVB.dart';
import 'package:hb_mobile2021/core/services/hoSoCVService.dart';
import 'package:hb_mobile2021/ui/hoSoCV/chiTietHSCV/ThongTinHSCV.dart';
import 'dart:convert';


class cacTaiLieuK extends StatefulWidget {
  final int id;
  final String  nam;

  cacTaiLieuK({required this.id, required this.nam});

  @override
  _cacTaiLieuKState createState() => _cacTaiLieuKState();
}

class _cacTaiLieuKState extends State<cacTaiLieuK> {

  TextEditingController _titleController = TextEditingController();
  bool isClick = true;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  bool toggle = true;
  List dataListThayThe = [];
  String hscv = "";
  bool isLoading = true;
  var jsonSample = "";
  List<ListData> vanbanList = [];
  List<ListDataCQ> vanbanListCQ = [];
  var idLoaiVB;
  bool showD = true;
  late int hosoid;
  late String testthuhomerxoa;
  String ActionXL = "DanhSachCacTaiLieuKhac";
  late Timer _timer;



  Future<Null> onRefresh() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    if (mounted) { setState(() {
      hscv;
    });
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {  setState(() {

      GetDataHSCV1();
    });}


  }

  GetDataHSCV1() async {
    hscv = await getDataDetailHSCV1(ActionXL,"",widget.id,widget.nam,"");

    setState(() {
      dataListThayThe = jsonDecode(hscv)['OData'];
      isLoading = false;
    });
  }

  @override
  void dispose(){
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    double  _height = MediaQuery.of(context).size.height;
    Size  size = MediaQuery.of(context).size;
    double  _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text("Thông tin chi tiết hồ sơ công việc"),
        //automaticallyImplyLeading: false
      ),
      body:Container( padding: EdgeInsets.all(20),
        child: Column(
          children: [

            Row(children: [
              Container(width: _width*0.3,
                alignment: Alignment.center,
                height:_height*0.05,
                child: Text("Ngày tạo",style: TextStyle
                  (fontSize: 16,fontWeight: FontWeight.w500)),),

              Container(alignment: Alignment.center,
                width: _width*0.6,
                height:_height*0.05,child: Text("Tên tài liệu",style: TextStyle
                  (fontSize: 16,fontWeight: FontWeight.w500)
                  ,),),
            ],),

            Divider(),

            Expanded(child: buildTree())

          ],
        ),),

    );
  }

  Widget buildTree() {
    if (dataListThayThe== null|| dataListThayThe.length < 0 || isLoading) {
      return Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ));
    } else if (dataListThayThe.length  == 0) {
      return Center(
        child: Text("Không có bản ghi"),
      );
    }
    return RefreshIndicator(key: refreshKey,
        child: ListView.builder(
          // controller: _scrollerController,
          itemCount: dataListThayThe == null ? 0 : dataListThayThe.length + 1,
          itemBuilder: (context, index) {
            if (index == dataListThayThe.length) {
              return _buildProgressIndicator();
            } else {
              return getList(dataListThayThe[index]);
            }
          },
        ),
        onRefresh: onRefresh);

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

  Widget getList(item) {

    var Title = item['Title'] != null ?item['Title'] :"" ;
    var hscvMaHoSo = item['Created'] != null ?item['Created'] :"" ;

    var sMIDField = item['ID'] != null ? item['ID']: 0;

    return Column(children: [

      ListTile(

          leading: Container(width: MediaQuery.of(context).size.width*0.25,
    child: Text(GetDate(hscvMaHoSo)),),
          title: Text(Title,maxLines: 2,),
          trailing: Icon(Icons.arrow_right),
          onTap: () {Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => thongTinHSCV(
                idHS: sMIDField,nam: widget.nam,
              ),
            ),
          );}

      ) ,Divider()
    ],);
  }



}

String formatDOB(value){
  return DateFormat('dd-MM-yy')
      .format(DateFormat('yy-MM-dd').parse(value));
  // var parsedDate = DateTime.parse(strDt);
  // return ("${parsedDate.day}/${parsedDate.month}/${parsedDate.year}");
}
String ttHoSo(id) {
  String tt='';
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
String GetDate(String strDt){

  // return DateFormat('yyyy-MM-dd  kk:mm')
  //     .format(DateFormat('yyyy-MM-dd kk:mm').parse(strDt));
  var parsedDate = DateTime.parse(strDt);
  return ("${parsedDate.day}/${parsedDate.month}/${parsedDate.year}  "
      "${parsedDate.hour}:${parsedDate.minute}");
}