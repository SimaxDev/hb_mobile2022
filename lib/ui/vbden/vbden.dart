import 'dart:async';
import 'dart:math';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:flutter/material.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/restart.dart';
import 'package:hb_mobile2021/ui/main/btnavigator_widget.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:hb_mobile2021/core/models/UserJson.dart';
import 'package:hb_mobile2021/core/services/UserService.dart';
import 'package:hb_mobile2021/core/services/VbdenService.dart';
import 'package:hb_mobile2021/ui/main/MenuRight.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chitiet_vbden.dart';
import 'package:hb_mobile2021/ui/main/MenuLeft.dart';

class ListVBDen extends StatefulWidget {
  String urlttVB;
  final String created;
  final String username;
  final int val;
  String nam;

  //VanBanDi({this.urlttVB});
  ListVBDen({Key key, this.urlttVB, this.created, this.username, this.val,
    this.nam}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ListVBDen1();
  }
}

class ListVBDen1 extends State<ListVBDen> {
  List dataList = [];
  List dataDisplay = [];
  bool isLoading = false;
  String hoten, chucvu;
  int skip = 1;
  int pageSize = 20;
  int skippage = 0;
  String ActionXL = "GetListVBDen";
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
  String vbtimkiem = "";
  int IDT = 0;
  TextEditingController _titleController = TextEditingController();
  bool showD = true;
  String testthuhomerxoa;
  String nam = "";
  List<String> Year = ["2022","2021", "2020", "2019", "2018", "2017"];
  String dropdownValue = "";
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

  @override
  void initState() {
    _initializeTimer();
    // TODO: implement initState
    //  if(getString("username"))
    super.initState();
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
    GetDataVBDen(dropdownValue);

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) { setState(() {
      UiGetData();
    });}

  }


  @override
  void dispose() {
    if(_timer != null){
      _timer.cancel();
    }
    super.dispose();
  }

  //lấy thông tin user
  UserJson user = new UserJson();

  GetInfoUserNew() async {
    sharedStorage = await SharedPreferences.getInstance();
    if (mounted) {setState(() {
      user.Title = sharedStorage.getString("hoten");
      user.ChucVu = sharedStorage.getString("chucvu");
    });}

    var tendangnhap = sharedStorage.getString("username");
    ten = tendangnhap;
  }

//refesh lại trnag
  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));


    return null;
  }

//lay data vbden

  GetDataVBDen(String nam) async {
    if(tongso != null)
      if ((tongso-(skip)*pageSize< 0)) {
        pageSize = tongso-(skip-1)*pageSize ;
        chckSwitch =true;
        // return _buildProgressIndicator();

      } else {
        pageSize = 10;}

    // if(widget.urlttVB == null || widget.urlttVB == ""|| widget.nam == null || widget.nam == "" )
    // {
    //   nam = "2021";
    //   vbden= await getDataLeftVBDen(skip, pageSize, ActionXL,widget.urlttVB,nam);
    // }
    // else
    vbden= await getDataLeftVBDen(skip, pageSize, ActionXL,widget.urlttVB,
      nam,skippage);
    if (mounted) {setState(() {
      // dataList += json.decode(vbden)['OData'];
      dataList.addAll(json.decode(vbden)['OData']);
      skip++;
      skippage += 10;

      tongso = json.decode(vbden)['TotalCount'];
      isLoading = false;
      _scrollerController.addListener(() {
        if(chckSwitch != true){
          if (_scrollerController.position.pixels == _scrollerController.position.maxScrollExtent) {
            GetDataVBDen(dropdownValue);
            // GetDataByKeyYearVBDen(dropdownValue);
            dataList;
          }
        }

      });
    });}

  }

  getDataMsenuLefft() async {
    vbden = await getDataLeftVBDen(skip, pageSize, ActionXL, widget.urlttVB,
      widget.nam,skippage);
    if (mounted) { setState(() {
      dataList = json.decode(vbden)['OData'];

      tongso = json.decode(vbden)['TotalCount'];
      isLoading = false;
    });}

  }

//tim kiem van ban
  GetDataByKeyWordVBDen(String text) async {
    var tendangnhap = sharedStorage.getString("username");
        vbtimkiem = await getDataByKeyWordVBDen(tendangnhap, ActionXL, text,
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
    return GestureDetector(
      onTap: _handleUserInteraction,
      onPanDown: _handleUserInteraction,
      onScaleStart: _handleUserInteraction,
      child:Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(-15.0, 0.0),
              child: Container(
              width: MediaQuery.of(context).size.width * 0.47,

              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white, // Set border color
                ), // Set border width
                borderRadius: BorderRadius.all(Radius.circular(10.0)), // Set rounded corner radius
                // Make rounded corner of border
              ),
              child: Row(

                children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextField(
                      autofocus: false,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: 17),
                        hintText: 'Tìm kiếm',
                        prefixIcon: Icon(Icons.search, color: Colors.white, size: 20.0),
                        border: InputBorder.none,
                        // contentPadding: EdgeInsets.only(left: 0.0,
                        //  top: 5.0,),
                      ),
                      onChanged: (val) {
                        setState(() {

                          showD = false;
                          testthuhomerxoa = val;

                          GetDataByKeyWordVBDen(testthuhomerxoa);
                        });
                      },
                    ),
                  ),
                  !showD
                      ? InkWell(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.05,
                      child: Text(
                        "X",
                        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
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
                      : SizedBox()

                ],
              ),),),


          Container(
            width: MediaQuery.of(context).size.width *
                0.15,
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
            onChanged: (String newValue) {
              if (mounted) {setState(() {
                skip =1;
                skippage =0;
                dropdownValue = newValue;
                dataList.clear();
                isLoading = true;
               // GetDataByKeyYearVBDen(dropdownValue);
                GetDataVBDen(dropdownValue);


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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                //alignment: Alignment.topLeft,
                width: MediaQuery.of(context).size.width * 0.1,
                child: IconButton(
                  icon: Icon(const IconData(0xe164, fontFamily: 'MaterialIcons')),
                  onPressed: () {
                    // if (button == true) {
                    //   GetDataByCreatedVBDen('true');
                    //   button = false;
                    // } else {
                    //   GetDataByCreatedVBDen('false');
                    //   button = true;
                    // }
                  },
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.23,
                  child: showEge1 == true
                      ? GestureDetector(
                          onTap: onToggleNgayDen,
                          child: Container(
                              padding: const EdgeInsets.fromLTRB(10, 7, 0, 0),
                              child: Row(
                                children: [
                                  Container(
                                    child: Text('Ngày đến',

                                        //overflow: TextOverflow.clip,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        )),
                                  ),
                                  Image(
                                    height: 30,
                                    width: 10,
                                    image: _showPass1
                                        ? AssetImage('assets/logo_down_arrow.png')
                                        : AssetImage('assets/logo_up_arrow.png'),
                                  ),
                                ],
                              )),
                        )
                      : GestureDetector(
                          onTap: onToggleNgayDen,
                          child: Container(
                            margin: EdgeInsets.only(top: 15, left: 10),
                            alignment: Alignment.bottomLeft,
                            child: Text('Ngày đến',
                                //overflow: TextOverflow.clip,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          ))),
              Container(
                  width: MediaQuery.of(context).size.width * 0.28,
                  child: showEge2 == true
                      ? GestureDetector(
                          onTap: onToggleSKH,
                          child: Container(
                              padding: const EdgeInsets.fromLTRB(10, 7, 0, 0),
                              child: Row(
                                children: [
                                  Container(
                                    child: Text('Số ký hiệu',
                                        //overflow: TextOverflow.clip,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        )),
                                  ),
                                  Image(
                                    height: 30,
                                    width: 10,
                                    image: _showPass2
                                        ? AssetImage('assets/logo_down_arrow.png')
                                        : AssetImage('assets/logo_up_arrow.png'),
                                  ),
                                ],
                              )),
                        )
                      : GestureDetector(
                          onTap: onToggleSKH,
                          child: Container(
                            margin: EdgeInsets.only(top: 15, left: 10),
                            alignment: Alignment.bottomLeft,
                            child: Text('Số ký hiệu',
                                //overflow: TextOverflow.clip,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          ))),
              Container(
                  // width: MediaQuery.of(context).size.width * 0.25,
                  width: MediaQuery.of(context).size.width * 0.23,
                  child: showEge3 == true
                      ? GestureDetector(
                          onTap: onToggleTrichYeu,
                          child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                              child: Row(
                                children: [
                                  Container(
                                    child: Text('Trích yếu',
                                        //overflow: TextOverflow.clip,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        )),
                                  ),
                                  Image(
                                    height: 30,
                                    width: 10,
                                    image: _showPass3
                                        ? AssetImage('assets/logo_down_arrow.png')
                                        : AssetImage('assets/logo_up_arrow.png'),
                                  ),
                                ],
                              )),
                        )
                      : GestureDetector(
                          onTap: onToggleTrichYeu,
                          child: Container(
                            margin: EdgeInsets.only(top: 15),
                            alignment: Alignment.bottomLeft,
                            child: Text('Trích yếu',
                                //overflow: TextOverflow.clip,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          ))),
              Container(
                //alignment: Alignment(-10.0, -1.0),
                width: MediaQuery.of(context).size.width * 0.15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // alignment: Alignment(-50.0, 0),
                      margin: EdgeInsets.only(
                        top: 15,
                      ),
                      child: Text(
                        'Tổng số:',
                        style: TextStyle(fontSize: 10, color: Colors.black38, fontStyle: FontStyle.italic),
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        tongso == null ? "0":
                        tongso.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              )
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
      drawer: Drawer(
        child: new ListView(
          children: <Widget>[
            Container(
              color: Color(0xff2196F3),
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height / 15,
              child: DrawerHeader(
                  child: Container(
                child: Row(children: [
                  Flexible(flex:1 ,
                    child: InkWell(
                      onTap: ()=>Navigator.of(context).pop(),
                      child: Text(
                        "X",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white
                        ),
                      ),
                    )),
                  Flexible(flex:8 ,
                    child: Container(
                      alignment: Alignment.center,
                      child:Text(
                        "Văn bản đến",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white
                        ),
                      ) ,),),

                ],)
              )),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              child: MenuLeft(page: 1,username: widget.username,year:
              dropdownValue,queryLeft: widget.urlttVB,queryID:IDTT),
            )
          ],
        ),
      ),
    ),);
  }

  Widget UiGetData() {
    if (dataList== null || dataList.length < 0 || isLoading) {
      //isLoading = !isLoading;
      return Center(
          child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
      ));
    } else if (dataList.length == 0) {
      return Center(
        child: Text("Không có bản ghi"),
      );
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
            _buildProgressIndicator();
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
    var trichyeu = item['vbdTrichYeu'] != null ? item['vbdTrichYeu'] :"";
    var soKyHieu = item['vbdSoKyHieu'] != null ? item['vbdSoKyHieu'] : "";
    //var soKyHieu = "sdjbhsdjoghsdjghsgjlkshgsljh";
    var aa = item['vbdNgayDen'] == null?"": DateTime.tryParse(item['vbdNgayDen']);
    var ngaybanhanh =item['vbdNgayDen'] == null?"": DateFormat("dd-MM-y").format(aa);
    var id = item['ID'] != null ? item['ID'] :"";
    var MaDonVi = item['MaDonVi'] != null ? item['MaDonVi'] :"";
    var ListName = item['ListName'] == null ? "" : item['ListName'];
    int Yearvb = item['vbdYear'] == null ? 2020: item['vbdYear'];
    var trangthai =  item['vbdTrangThaiXuLyVanBan'] ==  null ?"": item['vbdTrangThaiXuLyVanBan'];
   // var temp = DateFormat('yyyy-MM-dd').parse(item['vbdNgayBanHanh']);
    //var tempden = DateFormat('yyyy-MM-dd').parse(item['vbdNgayDen']);
   // var ngayden = DateFormat('dd-MM-yyyy').format(tempden);
    //var trangthai = item['vbdTrangThaiVanBan'] ?? "";
    //VanBanDiJson vbdi = vanBanDiJson(item.toString());
    return soKyHieu == null || soKyHieu == false || trangthai == 1 || trangthai == 4
        ? Card(
            elevation: 1.5,
            child: InkWell(
              onTap: () {
                _timer.cancel();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChiTietVBDen(id: id,MaDonVi:MaDonVi),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                  padding: EdgeInsets.fromLTRB(5.0, 3, 0, 0),
                                  // width: MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    soKyHieu,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.w600),
                                  )),
                              Container(
                                  padding: EdgeInsets.fromLTRB(5.0, 3, 0, 0),
                                  // width: MediaQuery.of(context).size.width * 0.3,
                                  child: Text(ngaybanhanh == null || ngaybanhanh == "" ?"":
                                    "(" + ngaybanhanh + ")",
                                    //  overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.italic),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                            //width: MediaQuery.of(context).size.width * 0.6,
                            padding: EdgeInsets.only(left: 5.0),
                            child: Text(
                              trichyeu,
                              maxLines: 3,
                              style: TextStyle(color: Colors.blue, fontSize: 14),
                              overflow: TextOverflow.clip,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : Card(
            elevation: 1.5,
            child: InkWell(
              onTap: () {
                _timer.cancel();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChiTietVBDen(id: id,
                        ListName:ListName,Yearvb:Yearvb,MaDonVi: MaDonVi,),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                  padding: EdgeInsets.fromLTRB(5.0, 3, 0, 0),
                                  child: Text(
                                    soKyHieu,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                                  )),
                              Container(
                                  padding: EdgeInsets.fromLTRB(5.0, 3, 0, 0),
                                  // width: MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    "(" + ngaybanhanh + ")",
                                    //  overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.italic),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                              padding: EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                              width: MediaQuery.of(context).size.width * 0.98,
                              child: Text(
                                trichyeu,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
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
