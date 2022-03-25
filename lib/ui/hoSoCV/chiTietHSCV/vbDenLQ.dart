import 'dart:async';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hb_mobile2021/common/HoSoCV/coQuanBH.dart';
import 'package:hb_mobile2021/common/HoSoCV/loaiVB.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/core/services/hoSoCVService.dart';
import 'package:hb_mobile2021/ui/hoSoCV/chiTietHSCV/ThongTinHSCV.dart';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'dart:convert';
import 'package:json_table/json_table.dart';

class vbDenLQ extends StatefulWidget {
  final int id;
  final String  nam;
  final String  idVBDlienQuan;

  vbDenLQ({this.id, this.nam,this.idVBDlienQuan});

  @override
  _vbDenLQState createState() => _vbDenLQState();
}

class _vbDenLQState extends State<vbDenLQ> {

  TextEditingController searchController = TextEditingController();
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
  var idLoaiCQ;
  bool showD = true;
  int hosoid;
  String testthuhomerxoa;
  String ActionXL = "GetVBDenLienQuan";
  // List<dynamic> dataListThayThe = [];
  // var columns = [
  //   JsonTableColumn("hscvMaHoSo", label: "Mã hồ sơ"),
  //   JsonTableColumn("hscvNguoiLap.Title", label: "Người lập"),
  //   JsonTableColumn("Title", label: "Tên hồ sơ công việc"),
  //   JsonTableColumn("hscvTrangThaiXuLy", label: "Trạng thái xử lý",valueBuilder:ttHoSo),
  // ];
  //
  Timer _timer;


  void _initializeTimer() {
    _timer = Timer.periodic(const Duration(minutes:5), (_) {
      logOut(context);
      _timer.cancel();
    });

  }

  void _handleUserInteraction([_]) {
    if (!_timer.isActive) {
      // This means the user has been logged out
      return;
    }

    _timer.cancel();
    _initializeTimer();
  }

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
    _initializeTimer();
    super.initState();


      GetDataHSCV1("","","");
    GetDataCoQuanBH();
    GetDataLoaiVB();


  }
  GetDataCoQuanBH() async {
    String detailChucVu = await getDataDetailHSCV(widget.id, "GetCoQuanBH");
    if(mounted)
      {
        setState(() {
          var vanban = json.decode(detailChucVu)['OData'];
          var lstData = (vanban as List).map((e) => ListDataCQ.fromJson(e))
              .toList();
          List<ListDataCQ> lstDataSearch = List<ListDataCQ>();
          lstData.forEach((element) {
            lstDataSearch.add(element);
            vanbanListCQ = lstDataSearch;
          });
        });
      }

  }

  GetDataLoaiVB() async {
    String detailChucVu = await getDataDetailHSCV(widget.id, "GetLoaiVB&LoaiVB=vbden");
    if(mounted)
      {
        setState(() {
          var vanban = json.decode(detailChucVu)['OData'];
          var lstData = (vanban as List).map((e) => ListData.fromJson(e)).toList();
          List<ListData> lstDataSearch = List<ListData>();
          lstData.forEach((element) {
            lstDataSearch.add(element);
            vanbanList = lstDataSearch;
          });
        });
      }

  }

  GetDataHSCV1(String query,String idLVB,String idCQBH) async {
  hscv = await getDataDetailHSCVVBD(ActionXL,query,widget.id,widget
      .idVBDlienQuan,widget.nam,idLVB,idCQBH);
if(mounted)
  {
    setState(() {
      dataListThayThe = jsonDecode(hscv)['OData'];
      isLoading = false;
    });
  }

  }



  @override
  Widget build(BuildContext context) {
    double  _height = MediaQuery.of(context).size.height;
    Size  size = MediaQuery.of(context).size;
    double  _width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: _handleUserInteraction,
      onPanDown: _handleUserInteraction,
      onScaleStart: _handleUserInteraction,
      child:Scaffold(
      appBar: AppBar(title: Text("Thông tin chi tiết hồ sơ công việc"),
        //automaticallyImplyLeading: false
      ),
      body:Container( padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 20,),
            TextField(autofocus: true,
               controller: searchController,
              cursorColor: Colors.black45,
              style: TextStyle(
                  color: Colors.black,
                 ),
              decoration: new InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Nhập từ khoá tìm kiếm',
                hintStyle: TextStyle(
                  color: Color(0xffC0C0C0),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
                contentPadding:
                const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                  borderRadius: BorderRadius.circular(2),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),onChanged: (value){
              if(mounted){
                setState(() {
                  GetDataHSCV1(value,"","");
                });
              }

              },
            ),
            SizedBox(height: 10,),
            Row(children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: InkWell(
                  onTap: () {
                    //_selectDateTN(context);
                  },
                  child: Container(
                    width: size.width / 3,
                    height: size.height /18,
                    margin:  EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black38,

                        ),
                        borderRadius: BorderRadius.all(Radius
                            .circular(8),)
                    ),
                    child:  loaiVB(
                      listData: vanbanList,
                      title: 'Chọn loại văn bản',
                      searchHintText: 'Tìm kiếm',
                      onSaved: (value) {
                        setState(() {

                          GetDataHSCV1("",value[0].toString(),"");
                        });;
                      },
                    ),
                  ),
                ),
              ),
              Flexible(

                fit: FlexFit.tight,
                child: InkWell(
                  onTap: () {
                    // _selectDateDN(context);
                  },
                  child: Container(
                    width: size.width /3,
                    height: size.height /18,
                    margin:  EdgeInsets.only(left: 10),
                    // margin:  EdgeInsets.only(left: 20,right: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black38,

                        ),
                        borderRadius: BorderRadius.all(Radius
                            .circular(8),)
                    ),
                    child: coQuanBH(
                      listData: vanbanListCQ,
                      title: 'Chọn cơ quan ban hành',
                      searchHintText: 'Tìm kiếm',
                      onSaved: (value) {
                        setState(() {
                          GetDataHSCV1("","",value[0].toString());
                        });
                      },
                    ),
                  ),
                ),
              ),

            ],),
            SizedBox(height: 30,),
            Row(children: [
              Container(width: _width*0.3,
                alignment: Alignment.center,
                height:_height*0.05,
                child: Text("Số ký hiệu",style: TextStyle
                  (fontSize: 16,fontWeight: FontWeight.w500)),),

              Container(alignment: Alignment.center,
                width: _width*0.6,
                height:_height*0.05,child: Text("Trích yếu",style: TextStyle
                  (fontSize: 16,fontWeight: FontWeight.w500)
                  ,),),
            ],),

            Divider(),

            Expanded(child: buildTree())

          ],
        ),),

    ),);
  }

  Widget buildTree() {
    if (dataListThayThe==null || dataListThayThe.length < 0 || isLoading) {
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

    var vbdiDoKhan = item['vbdiDoKhan'] != null &&
        item['vbdiDoKhan']['Title'] != null
        ?item['vbdiDoKhan']['Title'] :"" ;
    var Title = item['vbdTrichYeu'] != null ?item['vbdTrichYeu'] :"" ;
    var hscvMaHoSo = item['vbdSoKyHieu'] != null ?item['vbdSoKyHieu'] :"" ;
    var vbdUserChuaXuLy1 = item['vbdUserChuaXuLy'] !=
        null && item['vbdUserChuaXuLy']!= null ?item['vbdUserChuaXuLy']:[] ;
    var vbdCoQuanBanHanh = item['vbdCoQuanBanHanh'] !=
        null&& item['vbdCoQuanBanHanh']['Title'] != null ?item['vbdCoQuanBanHanh']['Title']  :"" ;
    var sMIDField = item['ID'] != null ? item['ID']: 0;
    var vbdIsSentVanBan1 = item['vbdIsSentVanBan'] != null ?
    item['vbdIsSentVanBan']: false;
    var vbdTrangThaiXuLyVanBan1 = item['vbdTrangThaiXuLyVanBan'] != null ?
    item['vbdTrangThaiXuLyVanBan']: 0;
    var dataa = vbdUserChuaXuLy1;
    var iduser = currentUserID;
    var t = false;
    var t1=0;
    if(dataa != null )
    {
      for(var x in dataa){
       t1 = x['ID'];

      }
      // var t1 = dataa.find(x => x.ID == iduser);
      if (t1 != "" && t1 > 0 && t1 != null)
        t = true;

    };


    return Column(children: [

      ListTile(
          leading: Container(width: MediaQuery.of(context).size.width*0.25,child: vbdTrangThaiXuLyVanBan1 ==2? Text(hscvMaHoSo,maxLines: 2,style: TextStyle(color:Colors.red),)
        :( (vbdTrangThaiXuLyVanBan1 == 4 || vbdTrangThaiXuLyVanBan1 == 1
        || (vbdTrangThaiXuLyVanBan1 == -1
            || vbdTrangThaiXuLyVanBan1 == 0)
            && t == true
        || vbdIsSentVanBan1 == false)?Text(hscvMaHoSo,maxLines: 2,style:
    TextStyle(color:Colors.blue),):Text(hscvMaHoSo,maxLines: 2,style:
    TextStyle(color:Colors.black),)),),
          title:vbdTrangThaiXuLyVanBan1 ==2? Text(Title,maxLines: 2,style: TextStyle(color:Colors.red),)
              :( (vbdTrangThaiXuLyVanBan1 == 4 || vbdTrangThaiXuLyVanBan1 == 1
    || (vbdTrangThaiXuLyVanBan1 == -1
    || vbdTrangThaiXuLyVanBan1 == 0)
    && t == true
    || vbdIsSentVanBan1 == false)?Text(Title,maxLines: 2,style:
          TextStyle(color:Colors.blue),):Text(Title,maxLines: 2,style:
          TextStyle(color:Colors.black),)),
          subtitle:vbdTrangThaiXuLyVanBan1 ==2? Row(
            children: [
              Text("Cơ quan ban hành: ",style: TextStyle
                (fontSize: 12,
                  fontWeight: FontWeight.w500,color:Colors.red),maxLines: 1,),
              Container(width: MediaQuery.of(context).size.width*0.23,child:
              Text(vbdCoQuanBanHanh,style: TextStyle(fontSize: 12,
                  fontStyle: FontStyle.italic,color:Colors.red),maxLines: 2,) ),
            ],
          )
              :( (vbdTrangThaiXuLyVanBan1 == 4 || vbdTrangThaiXuLyVanBan1 == 1
              || (vbdTrangThaiXuLyVanBan1 == -1
                  || vbdTrangThaiXuLyVanBan1 == 0)
                  && t == true
              || vbdIsSentVanBan1 == false)?Row(
            children: [
              Text("Cơ quan ban hành: ",style: TextStyle
                (fontSize: 12,
                  fontWeight: FontWeight.w500,color:Colors.red),maxLines: 1,),
              Container(width: MediaQuery.of(context).size.width*0.23,child:
              Text(vbdCoQuanBanHanh,style: TextStyle(fontSize: 12,
                  fontStyle: FontStyle.italic,color:Colors.red),maxLines: 2,) ),


            ],
          ):Row(
            children: [
              Text("Cơ quan ban hành: ",style: TextStyle
                (fontSize: 12,
                  fontWeight: FontWeight.w500),maxLines: 1,),
              Container(width: MediaQuery.of(context).size.width*0.23,child:
              Text(vbdCoQuanBanHanh,style: TextStyle(fontSize: 12,
                  fontStyle: FontStyle.italic),maxLines: 2,) ),


            ],
          )),

          trailing:(vbdiDoKhan == "Thượng khẩn" ||vbdiDoKhan
              == "Khẩn" || vbdiDoKhan == "Hỏa tốc")? Image(
              width: MediaQuery.of(context).size.width*0.1,
              alignment: Alignment.centerLeft,
              image: AssetImage('assets/hoatoc.png')):SizedBox(),
          onTap: () {Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => thongTinHSCV(
                idHS: sMIDField,nam: widget.nam,
              ),
            ),
          );}

      ) ,
      Divider()
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