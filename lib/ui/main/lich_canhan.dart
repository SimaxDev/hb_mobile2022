import 'dart:async';
import 'dart:math';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:hb_mobile2021/core/models/UserJson.dart';
import 'package:hb_mobile2021/core/services/VbdenService.dart';
import 'package:hb_mobile2021/ui/main/MenuRight.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DynamicEvent extends StatefulWidget {
  String urlttVB;
  final String created;
  final String username;
  final int val;
  String nam;


  //VanBanDi({this.urlttVB});
  DynamicEvent({Key? key, required this.urlttVB, required this.created, required this.username, required this.val,
    required this.nam}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ListVBDen1();
  }
}

class ListVBDen1 extends State<DynamicEvent> {
  bool checkOpen = false;
  List dataList = [];
  List dataDisplay = [];
  bool isLoading = false;
  late String hoten, chucvu;
  int skip = 1;
  int pageSize = 20;
  int skippage = 0;
  String ActionXL = "getLichLanhDao";
  ScrollController _scrollerController = new ScrollController();
  bool button = true;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  var tongso;

  var random;
  bool _showPass1 = true;

  bool _showPass2 = true;
  bool _showPass3 = true;
  bool showEge1 = false;
  bool showEge2 = false;
  bool showEge3 = false;
  bool chckSwitch = false;
  String vbden = "";
  int tuanThu = 0;

  String vbtimkiem = "";
  int IDT = 0;
  TextEditingController _titleController = TextEditingController();
  bool showD = true;
  late String testthuhomerxoa;
  String nam = "";
  var tenLD ;
  List<String> Year = ["2026","2025","2024","2023","2022","2021", "2020", "2019", "2018", "2017"];  String dropdownValue = "";
  String ActionXLLD = "GetLanhDao";
  List<ListDataP>  ListDataPDF = [];
  String IdLanhDao = "0";



  @override
  void initState() {
   // _initializeTimer();
    // TODO: implement initState
    //  if(getString("username"))

    super.initState();
    getDataMsenuLefft();
    isLoading = true;
    chckSwitch = false;
    if (mounted) {setState(() {
      if(widget.nam == null || widget.nam ==  ""){
        DateTime now = DateTime.now();
        nam =  DateFormat('yyyy').format(now) ;
        dropdownValue = nam;
      }
      else
      {
        dropdownValue = widget.nam;

      }
      IDT=IDTT ;


      GetInfoUserNew();
      refreshList();

    });}



  }

  @override
  void dispose(){
    super.dispose();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) { setState(() {
      UiGetData();
    });}

  }

  //lấy thông tin user
  UserJson user = new UserJson(cbNhanEmail: true,cbNhanSMS: true,ChucVu: '',DiaChi: '',Email: '',GioiTinh: 0,NgaySinh: '',SDT: '',SDTN: '',ThongBao: '',Title: '');

  GetInfoUserNew() async {
    sharedStorage = await SharedPreferences.getInstance();
    if (mounted) {setState(() {
      user.Title = sharedStorage!.getString("hoten")!;
      user.ChucVu = sharedStorage!.getString("chucvu")!;
    });}

    var tendangnhap = sharedStorage!.getString("username");
    ten = tendangnhap;
  }

//refesh lại trnag
  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));


    return null;
  }

//lay data vbden

  GetDataVBDen(String nam2,String tuanthu,String ID) async {
    http://apimobile.hoabinh.gov.vn/api/ServicesVBD/GetData?p_year=2022&p_week=3&ActionXL=getLichLanhDao&lId=63

    vbden= await getLich( ActionXL, nam2,tuanthu,ID);
    if (mounted) {setState(() {
      // dataList += json.decode(vbden)['OData'];
      dataList.addAll(json.decode(vbden)['OData']);
      tuanThu  = int.parse(json.decode(vbden)['OData'][0]['Tuan']);


      isLoading = false;
      // _scrollerController.addListener(() {
      //   if(chckSwitch != true){
      //     if (_scrollerController.position.pixels == _scrollerController.position.maxScrollExtent) {
      //       GetDataVBDen(dropdownValue,tuanThu.toString(),ID);
      //       // GetDataByKeyYearVBDen(dropdownValue);
      //       dataList;
      //     }
      //   }
      //
      // });
    });}

  }

  getDataMsenuLefft() async {
    vbden = await getDataCVBD1(ActionXLLD);
    if (mounted) { setState(() {
      if(mounted){ setState(() {
        var vanban = json.decode(vbden)['OData'];

        tenLD = vanban[0]['ID'].toString();
        IdLanhDao = vanban[0]['ID'].toString();
        GetDataVBDen(dropdownValue,"",tenLD.toString());
         var lstData = (vanban as List).map((e) => ListDataP.fromJson(e)).toList();
        lstData.forEach((element) {

          ListDataPDF.add(element);

        });
      });}
    //   IDLanhDao = json.decode(vbden)['OData']['ID'];
    //
    });}

  }

//tim kiem van ban
  GetDataByKeyWordVBDen(String text) async {
    var tendangnhap = sharedStorage!.getString("username");
    vbtimkiem = await getDataByKeyWordVBDen(tendangnhap!, ActionXL, text,
        dropdownValue,widget.urlttVB);


    if (mounted) { setState(() {
      dataList = json.decode(vbtimkiem)['OData'];
      tongso = json.decode(vbtimkiem)['TotalCount'];
    });}

  }


  void onToggleNgayDen() {
    if (mounted) {setState(() {
      showEge1 = true;
      sortType = 1;
      sort(dataList, sortType);
      _showPass1 = !_showPass1;
      if (showEge1 == true) {
        showEge2 = false;
        showEge3 = false;
      }
    });}

  }

  void onToggleSKH() {
    if (mounted) {  setState(() {
      showEge2 = true;
      sortType = 2;
      sort(dataList, sortType);
      _showPass2 = !_showPass2;
      if (showEge2 == true) {
        showEge3 = false;
        showEge1 = false;
      }
    });}

  }

  void onToggleTrichYeu() {
    if (mounted) {  setState(() {
      showEge3 = true;
      sortType = 3;
      sort(dataList, sortType);
      _showPass3 = !_showPass3;
      if (showEge3 == true) {
        showEge2 = false;
        showEge1 = false;
      }
    });}

  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [



            Container(
              width: MediaQuery.of(context).size.width *
                  0.15,
              alignment: Alignment.centerRight,
              child:   DropdownButton<String>(
                value: dropdownValue,
                // icon: const Icon(Icons.arrow_downward),
                // iconSize: 24,
                //elevation: 16,
                style: const TextStyle(color: Colors.black, fontWeight:
                FontWeight.normal,fontSize: 13),
                underline: Container(
                  height: 2,
                  color: Colors.white70,
                  width: 50,
                ),
                onChanged: ( newValue) {
                  if (mounted) {setState(() {
                    skip =1;
                    skippage =0;
                    dropdownValue = newValue!;
                    dataList.clear();
                    isLoading = true;
                    // GetDataByKeyYearVBDen(dropdownValue);
                    GetDataVBDen(dropdownValue,tuanThu.toString(),IdLanhDao);


                  });}

                },
                items: Year.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Text(value),
                      ));
                }).toList(),
              ),)

          ],
        ),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.person_outline),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      body: Column(
        children:[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width *0.35,
                  child: Text("Lịch công tác lãnh đạo:",style: TextStyle(fontWeight:
                  FontWeight.bold,fontSize: 13),)
              ),
              Container(alignment: Alignment.center,
                width: MediaQuery.of(context).size.width*0.5,
                height: MediaQuery.of(context).size.height /18,
                // padding: EdgeInsets.all(10),
                margin:  EdgeInsets.all(10),

                child:FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        // hint: Text("Chọn lãnh đạo"),
                        style: TextStyle(fontSize: 14,color: Colors.black),
                        value: tenLD,
                        isDense: false,
                        isExpanded: true,
                        onChanged: (newValue) {
                          if(mounted){
                            setState(() {
                              tenLD=newValue;
                              GetDataVBDen(dropdownValue,tuanThu.toString(),
                                  IdLanhDao.toString());
                              dataList.clear();
                            });
                          }
                        },
                        items: ListDataPDF.map((value) {

                          return DropdownMenuItem<String>(
                              onTap: (){
                                setState(() {
                                  IdLanhDao= value.ID.toString();
                                });


                              },
                              value: value.ID.toString(),
                              child:Padding(padding: EdgeInsets.all(10),
                                child: RichText(
                                  text: TextSpan(
                                    children: [


                                      TextSpan(text:value.Name == null? "":value.Name, style:
                                      TextStyle(
                                          color: Colors.black.withOpacity(0.75),
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13),

                                      ),
                                    ],
                                  ),
                                ),)
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: InkWell(
                  onTap: () {
                  },
                  child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      alignment: Alignment.center,
                      child:  GestureDetector(
                        onTap: (){

                          int tuansau = tuanThu;

                          tuansau-- ;
                          GetDataVBDen(dropdownValue,tuansau.toString(),IdLanhDao);
                          dataList.clear();
                          setState(() {
                            checkOpen= false;
                          });


                        },
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(15, 7, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text('Tuần trước',
                                      //overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        //  decoration: TextDecoration.underline,
                                      )),
                                ),

                              ],
                            )),
                      )
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: InkWell(
                  onTap: () {
                    //_selectDateTN(context);
                  },
                  child:    Container(
                      alignment: Alignment.center,
                      //width: MediaQuery.of(context).size.width * 0.23,
                      child:  GestureDetector(
                          onTap: onToggleNgayDen,
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 15, left: 10),
                                alignment: Alignment.center,
                                child: Text('Tuần thứ: ',
                                    //overflow: TextOverflow.clip,
                                    style: TextStyle(fontSize: 16, fontWeight:
                                    FontWeight.bold,color: Colors.blue)),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15),
                                alignment: Alignment.center,
                                child: Text(tuanThu.toString()
                                    ,
                                    //overflow: TextOverflow.clip,
                                    style: TextStyle(fontSize: 16, fontWeight:
                                    FontWeight.bold)),
                              )
                            ],)
                      )),
                ),
              ),

              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: InkWell(
                  onTap: () {
                    //_selectDateTN(context);
                  },
                  child:  Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: (){

                          int tuantiep = tuanThu;
                          tuantiep++ ;
                          GetDataVBDen(dropdownValue,tuantiep.toString(),IdLanhDao);
                          dataList.clear();
                          setState(() {
                            checkOpen= false;
                          });


                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(15, 7, 0, 0),
                          child: Container(
                            child: Text('Tuần sau',
                                //overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  // decoration: TextDecoration.underline,
                                )),
                          ),),
                      )
                  ),
                ),
              ),




            ],
          ),
          Expanded(
            child: Container(
              child: UiGetData(),
            ),
          )
        ],
      ),
      endDrawer: MenuRight(
        users: widget.username,
        hoten: user.Title,
        chucvu: user.ChucVu,
      ),
      endDrawerEnableOpenDragGesture: false,

    );
  }

  Widget UiGetData() {
    if (dataList== null || dataList.length < 0 || isLoading) {
      //isLoading = !isLoading;
      return Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ));
    } else if (dataList.length == 0) {
      return Container();
    }

    return RefreshIndicator(
      key: refreshKey,
      child: ListView.builder(
        itemCount: dataList == null ? 0 : dataList.length ,
        physics:
        ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if(index == tongso){
            return   _buildProgressIndicator();
          }else{
            return getBody(dataList[index]);
          }




        },
        controller: _scrollerController,
      ),
      onRefresh: refreshList,
    );
  }


  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity:isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget getBody( item) {
    var now =  DateTime.now();
    String ngay = "";
    String thang = "";
    var thoigian = "";

    List chua = [];
    var thang1 = now.month;
    var ngay1 = now.day;
    if(ngay1 < 10){
      ngay="0"+ngay1.toString();
    }
    else{
      ngay = ngay1.toString();
    }
    if(thang1 < 10){
      thang="0"+thang1.toString();
    }
    else{
      thang = thang1.toString();
    }
    thoigian =  '${ngay}/${thang}/${now.year}';


    var trichyeu = item['Ngay'] != null ? item['Ngay'] :"";
    var GthoigianList = item['lstThongtinChiTietNgay'] != null &&
        item['lstThongtinChiTietNgay']!= [] && item['lstThongtinChiTietNgay']
        .length >0?
    item['lstThongtinChiTietNgay']:[] ;
    for(var value in GthoigianList)
      {
        chua.add(value);
      }
      if(item['Ngay'].contains(thoigian)){
        checkOpen = true;
      }else
    {
      checkOpen = false;
    }




    return  ExpansionTile(
      title: Row(
        children: <Widget>[
          // CustomIcon(icons: FontAwesomeIcons.solidFile),
          SizedBox(
            width: 5,
          ),
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.8,
            child:Text(
              trichyeu,
              maxLines: 1,
              style:   TextStyle(color: Colors.black, fontWeight: FontWeight
                  .w600, fontSize: 14),
            ),
          ),


          Divider(),
        ],
      ),
      childrenPadding: EdgeInsets.only(left: 20,right: 10),
      initiallyExpanded:checkOpen,
      children: <Widget>[
        ListView.builder(
          physics:
          ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: chua.length,
          itemBuilder: (context, index) {
            return Column(children: [
              SizedBox(height: 10,
              ) ,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.2,
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Thời gian:',
                      style: TextStyle( fontWeight: FontWeight
                          .w600, fontSize: 14),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(right: 20),
                      //height:MediaQuery.of(context).size.height * 0.04,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.65,
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        chua[index]['strThoiGian'].toString(),
                        style:   TextStyle(color: Colors.black,  fontSize: 12),maxLines: 2,
                      )
                  ),


                ],
              ),
              Divider(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.2,
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Địa điểm:',
                      style: TextStyle( fontWeight: FontWeight
                          .w600, fontSize: 14),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(right: 20),
                      //height:MediaQuery.of(context).size.height * 0.04,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.65,
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        chua[index]['strDiaDiem'],
                        style:   TextStyle(color: Colors.black,  fontSize: 12),maxLines: 2,
                      )
                  ),


                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.2,
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Nội dung:',
                      style: TextStyle( fontWeight: FontWeight
                          .w600, fontSize: 14),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(right: 20),
                      //height:MediaQuery.of(context).size.height * 0.04,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.65,
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        chua[index]['strNoiDung'],
                        style:   TextStyle(color: Colors.black,  fontSize: 12),maxLines: 2,
                      )
                  ),


                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.2,
                    padding: EdgeInsets.only(left: 15.0),
                    alignment: Alignment.center,
                    child: Text(
                      'Thành phần tham gia:',
                      style: TextStyle( fontWeight: FontWeight
                          .w600, fontSize: 14),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(right: 20),
                     // height:MediaQuery.of(context).size.height * 0.04,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.65,
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        chua[index]['strThanhPhanThamGia'],
                        style:   TextStyle(color: Colors.black,  fontSize: 12),
                        maxLines: 2,
                      )
                  ),


                ],
              ),

              //
              SizedBox(height: 10,child:Divider(height:10,color: Colors.blue,
              ) ,)
            ],);
          },
        ),



      ],
    );
  }

  //sawsp xep

  bool isSort = false;
  int sortType = 0;

  void sort(List list, int type) {


    switch (type) {
      case 3:
        if (list.length > 1) {
          list.sort((a, b) => isSort
              ? Comparable.compare(b["vbdTrichYeu"], a["vbdTrichYeu"]):Comparable.compare(a["vbdTrichYeu"], b["vbdTrichYeu"]));
        }

        break;
      case 1:
        if (list.length > 1) {
          list.sort((a, b) => isSort
              ? Comparable.compare(b["vbdNgayDen"], a["vbdNgayDen"]):Comparable.compare(a["vbdNgayDen"], b["vbdNgayDen"]));
        }

        break;
      case 2:
        if (list.length > 1) {
          list.sort((a, b) => isSort
              ? Comparable.compare(b['vbdSoKyHieu'], a['vbdSoKyHieu']):Comparable.compare(a['vbdSoKyHieu'], b['vbdSoKyHieu']));
        }

        break;
    }
    // list.sort((a,b) => isSort ? Comparable.compare(b[type], a[type]) : Comparable.compare(a[type], b[type])) ;

    if (mounted) {setState(() {
      isSort = !isSort;
    });}
  }

  String getTrangThai(int trangthai) {
    switch (trangthai) {
      case 0:
        return "Chưa duyệt";
        break;
      case 1:
        return "Đã duyệt";
        break;
      case 2:
        return "Đang xử lý";
        break;
      case 3:
        return "Đã xử lý";
        break;
      default:
        return "trạng thái";
        break;
    }
  }
}


class CustomIcon extends StatelessWidget {
  final IconData icons;
  final Color bgiconColor;

  CustomIcon({required this.icons, required this.bgiconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 25,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 5),
          color: bgiconColor != null ? bgiconColor : Colors.white,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: FaIcon(icons, size: 15, color: Colors.blue[900]),
        ));
  }
}
class ListDataP {
  String Name;
  int ID;


  ListDataP({ required this.Name,required this.ID});

  factory ListDataP.fromJson(Map<String, dynamic> json) {
    return ListDataP( Name: json['Title'],ID: json['ID']);
  }
}