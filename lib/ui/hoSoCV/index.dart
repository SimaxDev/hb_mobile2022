import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:hb_mobile2021/core/models/UserJson.dart';
import 'package:hb_mobile2021/core/services/DataControllerGetxx.dart';
import 'package:hb_mobile2021/core/services/UserService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/core/services/hoSoCVService.dart';
import 'package:hb_mobile2021/ui/hoSoCV/themMoiHS.dart';
import 'package:hb_mobile2021/ui/main/MenuRight.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hb_mobile2021/ui/main/MenuLeft.dart';
import 'package:intl/intl.dart';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'chiTietHSCV/ThongTinHSCV.dart';

class HSCVWidget extends StatefulWidget {
  String urlLoaiVB;
  final int val;
  final String username;
  String nam = "2022";

  HSCVWidget(
      {Key? key,
      required this.urlLoaiVB,
      required this.val,
      required this.username,
      required this.nam})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HSCVState();
  }
}

class HSCVState extends State<HSCVWidget> {
  List HoSoList = [];

  //List duthaoDisplay = [];
  bool isLoading = false;
  var ttHoSoKey = 4;
  ScrollController _scrollerController = new ScrollController();
  int skip = 1;
  int pageSize = 10;
  int skippage = 0;
  late String hoten, chucvu;
  late String testthuhomerxoa;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  String ActionXL = "GetListHSCV";
  late String tendangnhap;
  int IDT = 0;
  var tongso = 0;
  bool chckSwitch = false;
  bool _showPass1 = true;
  bool _showPass2 = true;
  bool _showPass3 = true;
  bool showEge1 = false;
  bool showEge2 = false;
  bool showEge3 = false;
  TextEditingController _titleController = TextEditingController();
  bool showD = true;
  List<String> Year = [
    ttHoSo(0),
    ttHoSo(1),
    ttHoSo(2),
    ttHoSo(3),
    ttHoSo(4),
    ttHoSo(5),
    ttHoSo(6)
  ];
  String dropdownValue = "";
  String nam1 = "2021";

  List<String> Years = ["2024","2023","2022","2021", "2020", "2019", "2018",
    "2017"];
  String dropdownValueYear = "";
  int _user = 6;
  final DataController product = Get.put(DataController());


  @override
  void initState() {
    //_initializeTimer();
    // TODO: implement initState
    DateTime now = DateTime.now();
    nam1 = DateFormat('yyyy').format(now);
    dropdownValueYear=nam1;
    //  if(getString("username"))
    GetInfoUserNew();
    GetInfoUser();
    super.initState();

    chckSwitch = false;
    dropdownValue = ttHoSo(6);

    // _scrollerController.addListener(() {
    //   if (_scrollerController.position.pixels == _scrollerController.position.maxScrollExtent) {

    //     HoSoList;
    //   }
    // });
    setState(() {

      GetDataHSCV();
      IDT = IDTT;
      isLoading = true;
      //  GetDataHSCV();
      refreshList();
    });
  }

  @override
  void dispose() {
    super.dispose();

    // HoSoList.clear();
    GetDataHSCV();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      // GetDataHSCV();
      // refreshList();
      // HoSoList;
    });
  }

  @override
  Future<void> destroy() {
    return GetDataHSCV();
  }

  //lấy thông tin user
  UserJson user = new UserJson(cbNhanEmail: true,cbNhanSMS: true,ChucVu: '',DiaChi: '',Email: '',GioiTinh: 0,NgaySinh: '',SDT: '',SDTN: '',ThongBao: '',Title: '');

  GetInfoUser() async {
    if (sharedStorage! != null) {
      isLoading = false;
      var item = await GetInfoUserService(widget.username);

      // user = jsonToUserJson(item);
      user = UserJson.fromJson(item);
      sharedStorage!.setString("hoten", user.Title);
      sharedStorage!.setString("chucvu", user.ChucVu);
    }
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    if (mounted) {
      setState(() {
        HoSoList;

        // GetDataHSCV();
      });
    }

    return null;
  }

  GetInfoUserNew() async {
    sharedStorage = await SharedPreferences.getInstance();
    setState(() {
      user.Title = sharedStorage!.getString("hoten")!;
      hoVaTen = user.Title;
      user.ChucVu = sharedStorage!.getString("chucvu")!;
    });
    var tendangnhap = sharedStorage!.getString("username");
    ten = tendangnhap;
  }

  GetDataByKeyYearVBDi(String trangthai, String nam) async {
    String yeartimkiem = await getDataByKeyTrangThai1(
        ActionXL, trangthai, skip, pageSize, skippage, nam);
    setState(() {
      HoSoList = json.decode(yeartimkiem)['OData'];
      skip++;
      skippage += 10;
      tongso = json.decode(yeartimkiem)['TotalCount'];
      isLoading = false;
    });
  }

  //lay data vbhs
  Future GetDataHSCV() async {
    if (tongso != null) if ((tongso - (skip) * pageSize < 0)) {
      pageSize = tongso - (skip - 1) * pageSize;
      chckSwitch = true;
      // return _buildProgressIndicator();

    } else {
      pageSize = 10;
    }

    String vbhs = "";
    vbhs = await getDataHomeHSCV(ActionXL, widget.urlLoaiVB,skip,pageSize);
    if (mounted) {
      setState(() {
        HoSoList.addAll(json.decode(vbhs)['OData']);

        // dataList += json.decode(vbden)['OData'];

        tongso = json.decode(vbhs)['TotalCount'];
        isLoading = false;
        _scrollerController.addListener(() {
          if (chckSwitch != true) {
            if (_scrollerController.position.pixels ==
                _scrollerController.position.maxScrollExtent) {
              GetDataHSCV();
              // GetDataByKeyYearVBDen(dropdownValue);
              HoSoList;
            }
          }
        });
      });
    }
    // vbhs = await getDataHomeVBDT(skip, pageSize, ActionXL,widget.urlLoaiVB,year);
  }

  GetDataMenuLeftVBDT() async {
    String vbhs = await datavb;
    setState(() {
      HoSoList = json.decode(vbhs)['OData'];
      //skip++;
      tongso = json.decode(vbhs)['TotalCount'];
      isLoading = false;
    });
  }

  //tim kiem van ban
  GetDataByKeyWordVBDT(String text) async {
    var tendangnhap = sharedStorage!.getString("username");
    String vbtimkiem = await getDataByKeyWordHSCV(tendangnhap!, ActionXL, text);
    setState(() {
      HoSoList = json.decode(vbtimkiem)['OData'];
      tongso = json.decode(vbtimkiem)['TotalCount'];
      isLoading == false;
    });
  }

  void onToggleNgayMo() {
    setState(() {
      showEge1 = true;
      sortType = 1;
      sort(HoSoList, sortType);
      _showPass1 = !_showPass1;
      if (showEge1 == true) {
        showEge2 = false;
        showEge3 = false;
      }
    });
  }

  void onToggleHanXuLy() {
    setState(() {
      showEge2 = true;
      sortType = 2;
      sort(HoSoList, sortType);
      _showPass2 = !_showPass2;
      if (showEge2 == true) {
        showEge3 = false;
        showEge1 = false;
      }
    });
  }

  void onToggleNguoiLap() {
    setState(() {
      showEge3 = true;
      sortType = 3;
      sort(HoSoList, sortType);
      _showPass3 = !_showPass3;
      if (showEge3 == true) {
        showEge2 = false;
        showEge1 = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(-15.0, 0.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white, // Set border color
                  ), // Set border width
                  borderRadius: BorderRadius.all(
                      Radius.circular(10.0)), // Set rounded corner radius
                  // Make rounded corner of border
                ),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: TextField(
                        autofocus: false,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(fontSize: 17),
                          hintText: 'Tìm kiếm',
                          prefixIcon: Icon(Icons.search,
                              color: Colors.white, size: 20.0),
                          border: InputBorder.none,
                          // contentPadding: EdgeInsets.only(left: 0.0,
                          //  top: 5.0,),
                        ),
                        onChanged: (val) {
                          setState(() {
                            showD = false;
                            testthuhomerxoa = val;

                            GetDataByKeyWordVBDT(testthuhomerxoa);
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
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _titleController.text = "";
                          testthuhomerxoa = "";
                          //GetDataVBDen();
                          showD = true;
                          GetDataByKeyWordVBDT(testthuhomerxoa);
                        });
                      },
                    )
                        : SizedBox()
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.15,
              child: DropdownButton<String>(
                value: dropdownValue,
                isExpanded: true,
                // icon: const Icon(Icons.arrow_downward),
                // iconSize: 24,
                //elevation: 16,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal),
                underline: Container(
                  height: 1,
                  color: Colors.white70,
                ),
                onChanged: ( newValue) {
                  setState(() {
                    _user = Year.indexOf(newValue!);
                    dropdownValue = ttHoSo(_user);
                    GetDataByKeyYearVBDi(_user.toString(), dropdownValueYear);
                  });
                },
                items: Year.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Text(
                          value,
                          maxLines: 1,
                          style: TextStyle(fontSize: 13),
                        ),
                      ));
                }).toList(),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.01,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.15,
              child: DropdownButton<String>(
                value: dropdownValueYear,
                // icon: const Icon(Icons.arrow_downward),
                // iconSize: 24,
                //elevation: 16,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 13),
                underline: Container(
                  height: 2,
                  color: Colors.white70,
                  width: 50,
                ),
                onChanged: ( newValue) {
                  if (mounted) {
                    setState(() {
                      dropdownValueYear = newValue!;
                      GetDataByKeyYearVBDi(
                          _user.toString(), dropdownValueYear);
                    });
                  }
                },
                items: Years.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Text(value),
                      ));
                }).toList(),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.person_outline),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              //tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      endDrawerEnableOpenDragGesture: false,
      endDrawer: MenuRight(
        users: widget.username,
        hoten: user.Title,
        chucvu: user.ChucVu,
      ),
      body: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              //alignment: Alignment.topLeft,
              width: MediaQuery.of(context).size.width * 0.1,
              child: IconButton(
                icon:
                Icon(const IconData(0xe164, fontFamily: 'MaterialIcons')),
                onPressed: () {},
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.25,
                child: showEge1 == true
                    ? GestureDetector(
                  onTap: onToggleNgayMo,
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 7, 0, 0),
                      child: Row(
                        children: [
                          Container(
                            child: Text('Ngày mở',

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
                                ? AssetImage(
                                'assets/logo_down_arrow.png')
                                : AssetImage(
                                'assets/logo_up_arrow.png'),
                          ),
                        ],
                      )),
                )
                    : GestureDetector(
                    onTap: onToggleNgayMo,
                    child: Container(
                      margin: EdgeInsets.only(top: 15, left: 10),
                      alignment: Alignment.bottomLeft,
                      child: Text('Ngày mở',
                          //overflow: TextOverflow.clip,
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                    ))),
            Container(
                width: MediaQuery.of(context).size.width * 0.25,
                child: showEge2 == true
                    ? GestureDetector(
                  onTap: onToggleHanXuLy,
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(5, 7, 0, 0),
                      child: Row(
                        children: [
                          Container(
                            child: Text('Hạn xử lý',
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
                                ? AssetImage(
                                'assets/logo_down_arrow.png')
                                : AssetImage(
                                'assets/logo_up_arrow.png'),
                          ),
                        ],
                      )),
                )
                    : GestureDetector(
                    onTap: onToggleHanXuLy,
                    child: Container(
                      margin: EdgeInsets.only(top: 15, left: 5),
                      alignment: Alignment.bottomLeft,
                      child: Text('Hạn xử lý',
                          //overflow: TextOverflow.clip,
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                    ))),
            Container(
              // width: MediaQuery.of(context).size.width * 0.25,
                width: MediaQuery.of(context).size.width * 0.25,
                child: showEge3 == true
                    ? GestureDetector(
                  onTap: onToggleNguoiLap,
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                      child: Row(
                        children: [
                          Container(
                            child: Text('Người lập',
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
                                ? AssetImage(
                                'assets/logo_down_arrow.png')
                                : AssetImage(
                                'assets/logo_up_arrow.png'),
                          ),
                        ],
                      )),
                )
                    : GestureDetector(
                    onTap: onToggleNguoiLap,
                    child: Container(
                      margin: EdgeInsets.only(top: 15),
                      alignment: Alignment.bottomLeft,
                      child: Text('Người lập',
                          //overflow: TextOverflow.clip,
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
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
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.black38,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      tongso == null ? "0" : tongso.toString(),
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
            child: getBody(),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        onPressed: () {


          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => ThemMoiHS()),
                  (Route<dynamic> route) => true);
        },
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            Container(
              color: Color(0xff2196F3),
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height / 15,
              child: DrawerHeader(
                  child: Container(
                      child: Row(
                        children: [
                          Flexible(
                              flex: 1,
                              child: InkWell(
                                onTap: () => Navigator.of(context).pop(),
                                child: Text(
                                  "X",
                                  style: TextStyle(fontSize: 20, color: Colors.white),
                                ),
                              )),
                          Flexible(
                            flex: 8,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Hồ sơ công việc",
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ))),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              child: MenuLeft(
                page: 4,
                username: widget.username,
                year: nam1,
                queryID: IDTT, queryLeft: '',
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getBody() {
    if (HoSoList == null || HoSoList.length < 0 || isLoading) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
      ));
    } else if (HoSoList.length == 0) {
      return Center(
        child: Text("Không có bản ghi"),
      );
    }
    return RefreshIndicator(
        key: refreshKey,
        child: ListView.builder(
          controller: _scrollerController,
          itemCount: HoSoList == null ? 0 : HoSoList.length + 1,
          itemBuilder: (context, index) {
            if (index == HoSoList.length) {
              return _buildProgressIndicator();
            } else {
              return getCard(HoSoList[index]);
            }
          },
        ),
        onRefresh: refreshList);
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

// các thẻ con trong list view
  Widget getCard(item) {
    var hscvTrangThaiXuLy =
        item['hscvTrangThaiXuLy'] != null ? item['hscvTrangThaiXuLy'] : 0;
    var hscvNguoiLap = item['hscvNguoiLap']['Title'] != null
        ? item['hscvNguoiLap']['Title']
        : 0;
    var DMDescription = item['DMDescription'];
    var Title = item['Title'] != null ? item['Title'] : "";
    //var isyKienField = item['isyKienField'] ?? "";
    var sMIDField = item['ID'] != null ? item['ID'] : 0;
    IDTT = sMIDField;
    String trangthaiState = ttHoSo(hscvTrangThaiXuLy);
    var temp = DateFormat("yyyy-MM-dd").parse(item['hscvNgayMoHoSo']) != null
        ? DateFormat("yyyy-MM-dd").parse(item['hscvNgayMoHoSo'])
        : DateFormat("yyyy-MM-dd").parse(item['hscvNgayMoHoSo']);
    var hscvNgayMoHoSo = DateFormat("dd-MM-yyyy").format(temp);

    var temp1 = item['hscvHanXuLy'] != null
        ? DateFormat("yyyy-MM-dd").parse(item['hscvHanXuLy'])
        : "";
    var hscvHanXuLy;
    if (temp1 != null && temp1 != "") {
      hscvHanXuLy = DateFormat("dd-MM-yyyy").format(temp1 as DateTime);
    }

    return Card(
        elevation: 1.5,
        child: InkWell(
          onTap: () {
            // isyKienField == false ?
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => thongTinHSCV(
                  idHS: sMIDField,
                  nam: dropdownValueYear,
                ),
              ),
            );
            // : print('tapped');
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: ListTile(
                        title: Text(
                          Title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          hscvNgayMoHoSo,
                          style: TextStyle(height: 1.5),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15.0, bottom: 10),
                      child: Text(
                        "Người lập: " + hscvNguoiLap,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(right: 0),
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      hscvTrangThaiXuLy == 1
                          ? Container(
                              margin: EdgeInsets.only(top: 5),
                              child: (DMDescription != null &&
                                      DMDescription.contains("#DaChuyenVT#"))
                                  ? Column(
                                      children: [
                                        Text(trangthaiState,
                                            style: new TextStyle(
                                                fontSize: 13,
                                                color: Colors.black)),
                                        Text("Đã chuyển văn thư",
                                            style: new TextStyle(
                                                fontSize: 13,
                                                color: Colors.black))
                                      ],
                                    )
                                  : Text(trangthaiState,
                                      style: new TextStyle(
                                          fontSize: 13, color: Colors.black)),
                            )
                          : Container(
                              child: Text(trangthaiState,
                                  style: new TextStyle(
                                      fontSize: 13, color: Colors.red)),
                            ),
                      SizedBox(
                        height: 20,
                      ),
                      hscvHanXuLy == null || hscvHanXuLy == ""?   Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Text(
                                "Hạn xử lý",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.italic),
                              )),
                          Container(
                              padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
                              // width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                hscvHanXuLy == null || hscvHanXuLy == ""
                                    ? ""
                                    : "(" + hscvHanXuLy + ")",
                                //  overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.italic),
                              )),
                        ],
                      ):SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  //Sắp xếp ds dự thảo
  bool isSort = false;
  int sortType = 0;

  void sort(List list, int type) {
    switch (type) {
      case 1:
        list.sort((a, b) => isSort
            ? Comparable.compare(b["hscvNgayMoHoSo"], a["hscvNgayMoHoSo"])
            : Comparable.compare(a["hscvNgayMoHoSo"], b["hscvNgayMoHoSo"]));
        break;
      case 0:
        list.sort((a, b) => isSort
            ? Comparable.compare(b['Created'], a['Created'])
            : Comparable.compare(a['Created'], b['Created']));
        break;
      case 3:
        list.sort((a, b) => isSort
            ? Comparable.compare(
                b["hscvNguoiLap"]["Title"], a["hscvNguoiLap"]["Title"])
            : Comparable.compare(
                a["hscvNguoiLap"]["Title"], b["hscvNguoiLap"]["Title"]));
        break;
      case 2:
        list.sort((a, b) => isSort
            ? Comparable.compare(
                b["hscvHanXuLy"] == null ? "" : b["hscvHanXuLy"],
                a["hscvHanXuLy"] == null ? "" : a["hscvHanXuLy"])
            : Comparable.compare(
                a["hscvHanXuLy"] == null ? "" : a["hscvHanXuLy"],
                b["hscvHanXuLy"] == null ? "" : b["hscvHanXuLy"]));
        break;
    }
    // list.sort((a,b) => isSort ? Comparable.compare(b[type], a[type]) : Comparable.compare(a[type], b[type])) ;
    setState(() {
      isSort = !isSort;
    });
  }
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
    case 6:
      tt = "Tất cả ";
      break;
    default:
      tt = "Tất cả ";
      break;
  }
  return tt;
}
