import 'dart:async';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:hb_mobile2021/core/models/UserJson.dart';
import 'package:hb_mobile2021/core/services/UserService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/ui/main/MenuRight.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'package:hb_mobile2021/ui/vbduthao/themMoiHS/ThemMoiDT.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ChiTietVBDuThao.dart';
import 'package:hb_mobile2021/ui/main/MenuLeft.dart';
import 'package:hb_mobile2021/core/services/VBDuThaoService.dart';
import 'package:intl/intl.dart';

class DuThaoWidget extends StatefulWidget {
  final int pageindex;
   String urlLoaiVB;
  final int val;
   final String username;
   String nam;

  DuThaoWidget({Key key, this.urlLoaiVB,this.val,this.username, this.pageindex,this.nam }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DuThaoState();
  }
}

class DuThaoState extends State<DuThaoWidget> {
  List duthaoList = [];
  //List duthaoDisplay = [];
  bool isLoading = false;
  var ttDuthaoKey = 4;
  ScrollController _scrollerController = new ScrollController();
  int skip = 1;
  int pageZ = 10;
  int skippage = 0;
  String hoten, chucvu;
  String testthuhomerxoa;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  String ActionXL = "GetListVBDT";
  String tendangnhap;
  int IDT = 0;
  String vbdt = "";
  var tongso = 0;
  bool _showPass1 = true;
  bool _showPass2 = true;
  bool _showPass3 = true;
  bool showEge1 = false;
  bool showEge2 = false;
  bool showEge3 = false;
  TextEditingController _titleController = TextEditingController();
  bool showD = true;
  bool chckSwitch = false;
  String nam = "";
  List<String> Year = ["2024","2023","2022","2021", "2020", "2019", "2018", "2017"];
  String dropdownValue  = "";

  @override
  void initState() {
    //_initializeTimer();
    // TODO: implement initState
    super.initState();
    isLoading = true;
    chckSwitch = false;
    setState(() {
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

    });
     GetDataVBDT(dropdownValue);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      //GetDataVBDen();
      getBody();
    });
  }
  @override
  void dispose() {

    // if(_timer != null){
    //   _timer.cancel();
    // }

    super.dispose();
  }

  //lấy thông tin user
  UserJson user = new UserJson();
  GetInfoUser() async {
    var TenDangNhap = sharedStorage.getString("username");
    if (sharedStorage != null){
      isLoading = false;
      var item = await GetInfoUserService(TenDangNhap);

      // user = jsonToUserJson(item);
      user = UserJson.fromJson(item);
      sharedStorage.setString("hoten", user.Title);
      sharedStorage.setString("chucvu", user.ChucVu);
    }
  }
  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    if(mounted){
      setState(() {
        getBody();
      });
    }


    return null;
  }
  GetInfoUserNew() async{
    sharedStorage = await SharedPreferences.getInstance();
    setState(() {
      user.Title = sharedStorage.getString("hoten");
      hoVaTen = user.Title;
      user.ChucVu = sharedStorage.getString("chucvu");
    });
    var tendangnhap = sharedStorage.getString("username");
    ten = tendangnhap;

  }
  //lay data vbdt
  GetDataVBDT(String nam) async {
    if(tongso != null)
      if ((tongso-(skip)*pageZ< 0)) {
        pageZ = tongso-(skip-1)*pageZ ;
        chckSwitch =true;
        // return _buildProgressIndicator();

      } else {
        pageZ = 10;}

    // if(widget.urlttVB == null || widget.urlttVB == ""|| widget.nam == null || widget.nam == "" )
    // {
    //   nam = "2021";
    //   vbden= await getDataLeftVBDen(skip, pageSize, ActionXL,widget.urlttVB,nam);
    // }
    // else
    vbdt= await getDataHomeVBDT(skip, pageZ, ActionXL,widget.urlLoaiVB,
        nam,skippage);
    if (mounted) {setState(() {
      // dataList += json.decode(vbden)['OData'];
      duthaoList.addAll(json.decode(vbdt)['OData']);
      skip++;
      skippage += 10;

      tongso = json.decode(vbdt)['TotalCount'];
      isLoading = false;
      _scrollerController.addListener(() {
        if(chckSwitch != true){
          if (_scrollerController.position.pixels == _scrollerController.position.maxScrollExtent) {
            GetDataVBDT(dropdownValue);
            // GetDataByKeyYearVBDen(dropdownValue);
            duthaoList;
          }
        }

      });
    });}

  }



  GetDataMenuLeftVBDT() async {

    String vbdt = await datavb;
    setState(() {
      duthaoList = json.decode(vbdt)['OData'];
      tongso=  json.decode(vbdt)['TotalCount'];
      isLoading = false;
    });
  }



  //tim kiem van ban
  GetDataByKeyWordVBDT(String text) async {
    var tendangnhap = sharedStorage.getString("username");
    String vbtimkiem = await getDataByKeyWordVBDT( ActionXL,
      text,dropdownValue,widget.urlLoaiVB);
    setState(() {
      duthaoList = json.decode(vbtimkiem)['OData'];
      tongso=  json.decode(vbtimkiem)['TotalCount'];
      isLoading == false;
    });
  }

  GetDataByKeyYearVBDuThao(String year) async {
    var tendangnhap = sharedStorage.getString("username");
    String yeartimkiem = await getDataByKeyYearVBDuThao(tendangnhap,widget
        .urlLoaiVB, ActionXL, year,skip,pageZ);
    setState(() {
      duthaoList = json.decode(yeartimkiem)['OData'];
      skip++;
      tongso=  json.decode(yeartimkiem)['TotalCount'];
      isLoading = false;
    });
  }

  void onToggleNguoiSoan() {

    setState(() {
      showEge1 = true;
      sortType = 1;
      sort(duthaoList, sortType);
      _showPass1 = !_showPass1;
      if(showEge1 == true){
        showEge2 = false;
        showEge3 = false;}
    });
  }
  void onToggleNgaySoan() {

    setState(() {
      showEge2 = true;
      sortType = 2;
      sort(duthaoList, sortType);
      _showPass2 = !_showPass2;
      if(showEge2 == true){
        showEge3 = false;
        showEge1 = false;}
    });
  }
  void onToggleNguoiKy() {

    setState(() {
      showEge3 = true;
      sortType = 3;
      sort(duthaoList, sortType);
      _showPass3 = !_showPass3;
      if(showEge3 == true){
        showEge2 = false;
        showEge1 = false;}
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                          style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _titleController.text = "";
                          testthuhomerxoa = "";
                          //GetDataVBDen();
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
                  if(mounted){
                    setState(() {
                      skip =1;
                      skippage =0;
                      dropdownValue = newValue;
                      duthaoList.clear();
                      isLoading = true;
                      // GetDataByKeyYearVBDen(dropdownValue);
                      GetDataVBDT(dropdownValue);
                    });
                  }
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
                width: MediaQuery.of(context).size.width * 0.25,
                child: showEge1 == true
                    ? GestureDetector(
                  onTap: onToggleNguoiSoan,
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 7, 0, 0),
                      child: Row(
                        children: [
                          Container(
                            child: Text('Người soạn',

                                //overflow: TextOverflow.clip,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold,decoration: TextDecoration.underline,)),
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
                    onTap: onToggleNguoiSoan,
                    child: Container(
                      margin: EdgeInsets.only(top: 15,left: 10),
                      alignment: Alignment.bottomLeft,
                      child: Text('Người soạn',
                          //overflow: TextOverflow.clip,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    ))),
            Container(
                width: MediaQuery.of(context).size.width * 0.25,
                child: showEge2 == true
                    ? GestureDetector(
                  onTap: onToggleNgaySoan,
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(5, 7, 0, 0),
                      child: Row(
                        children: [
                          Container(
                            child: Text('Ngày trình',
                                //overflow: TextOverflow.clip,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold,decoration: TextDecoration.underline,)),
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
                    onTap: onToggleNgaySoan,
                    child: Container(
                      margin: EdgeInsets.only(top: 15,left: 5),
                      alignment: Alignment.bottomLeft,
                      child: Text('Ngày trình',
                          //overflow: TextOverflow.clip,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    ))),
            Container(
              // width: MediaQuery.of(context).size.width * 0.25,
                width: MediaQuery.of(context).size.width * 0.25,
                child: showEge3 == true
                    ? GestureDetector(
                  onTap: onToggleNguoiKy,
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                      child: Row(
                        children: [
                          Container(
                            child: Text('Người ký',
                                //overflow: TextOverflow.clip,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold,decoration: TextDecoration.underline,)),
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
                    onTap: onToggleNguoiKy,
                    child: Container(
                      margin: EdgeInsets.only(top: 15),
                      alignment: Alignment.bottomLeft,
                      child: Text('Người ký',
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
                  SizedBox(height: 3,),
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
                  builder: (BuildContext context) => ThemMoiDT()),
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
                              "Văn dự thảo",
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
              child: MenuLeft(page: 3,username:widget.username, year:
              dropdownValue,queryLeft : widget.urlLoaiVB,queryID: IDT,),
            )
          ],
        ),
      ),
    );
  }

  Widget getBody() {

    if (duthaoList== null || duthaoList.length < 0 || isLoading) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
      ));
    } else if (duthaoList.length  == 0) {
      return Center(
        child: Text("Không có bản ghi"),
      );
    }
    return RefreshIndicator(
      key: refreshKey,
      child: ListView.builder(
        itemCount: duthaoList == null ? 0 : duthaoList.length ,
        physics:
        ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
            if(index == tongso){
              _buildProgressIndicator();
            }else{
              return getCard(duthaoList[index]);
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
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

// các thẻ con trong list view
  Widget getCard(item) {
    var trangthai = item['vbdiTrangThaiVB'] != null ? item['vbdiTrangThaiVB'] : 0;
    var vbdiNguoiSoanField = item['vbdiNguoiSoan_x003a_Title']['Title'] != null  ?item['vbdiNguoiSoan_x003a_Title']['Title'] :  "" ;
    var vbdiTrichYeuField = item['vbdiTrichYeu'] != null ?item['vbdiTrichYeu'] : "";
   //var isyKienField = item['isyKienField'] ?? "";
    var sMIDField = item['ID'] != null ? item['ID']: 0;
    vbdiXuatPhatTuHSCV = item['vbdiXuatPhatTuHSCV'].length> 0 ?
    item['vbdiXuatPhatTuHSCV']:[];
    var MaDonVi = item['MaDonVi'] != null ? item['MaDonVi'] :"";
    String trangthaiState = ttDuthao(trangthai);
   var temp =  DateFormat("yyyy-MM-dd").parse(item['vdiNgayTrinhKy']) != null ?DateFormat("yyyy-MM-dd").parse
     (item['vdiNgayTrinhKy']) : DateFormat("yyyy-MM-dd").parse(item['vdiNgayTrinhKy']);
    var ngaytrinh = DateFormat("dd-MM-yyyy").format(temp);
    return Card(
        elevation: 1.5,
        child: InkWell(
          onTap: () {

            // isyKienField == false ?
           // MaDonVi = Request["MaDonVi"];
           //  if (MaDonVi.StartsWith("sites"))
           //  {
           //    year =  widget.nam;
           //    // List<string> lstTT = MaDonVi.Split('/').ToList();
           //    // if (lstTT.Count > 0 && lstTT.Count == 3)
           //    //   SYear = lstTT[1].ToInt32();
           //  }
           //  else year ="0";
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ThongTinDuThaoWidget(
                        idDuThao: sMIDField,users: widget.username,nam:widget.nam,
                          MaDonVi:MaDonVi
                      ),
                    ),
                  );
                // : print('tapped');
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.fromLTRB(5.0, 3, 0, 0),
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          vbdiTrichYeuField,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,color: Colors.blue
                          ),
                        )),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text(
                        "Người soạn:"+" "+vbdiNguoiSoanField,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.22,
                      child: Text(trangthaiState,
                          style: new TextStyle(
                              fontSize: 13, color: new Color(0xFF26C6DA))),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 20.0),
                      child: Text(
                        ngaytrinh,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
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
            ? Comparable.compare(b["vbdiNguoiSoan"]["Title"],
                a["vbdiNguoiSoan"]["Title"]):Comparable.compare(a["vbdiNguoiSoan"]["Title"],
            b["vbdiNguoiSoan"]["Title"]));
        break;
      case 0:
        list.sort((a, b) => isSort
            ? Comparable.compare(b['Created'],
                a['Created']):Comparable.compare(a['Created'],
            b['Created']));
        break;
      case 3:
        list.sort((a, b) => isSort
            ? Comparable.compare(b["vbdiNguoiKy"]["Title"],
                a["vbdiNguoiKy"]["Title"]):Comparable.compare(a["vbdiNguoiKy"]["Title"],
            b["vbdiNguoiKy"]["Title"]));
        break;
        case 2:
        list.sort((a, b) => isSort
            ? Comparable.compare(b["vdiNgayTrinhKy"],
                a["vdiNgayTrinhKy"]):Comparable.compare(a["vdiNgayTrinhKy"],
            b["vdiNgayTrinhKy"]));
        break;
    }
    // list.sort((a,b) => isSort ? Comparable.compare(b[type], a[type]) : Comparable.compare(a[type], b[type])) ;
    setState(() {
      isSort = !isSort;
    });
  }
}

String ttDuthao(id) {
  String tt;
  switch (id) {
    case 0:
      tt = "Đã thu hồi";
      break;
    case 1:
      tt = "Đã chuyển phát hành";
      break;
    case 2:
      tt = "Đang soạn thảo/Xin ý kiến";
      break;
    case 3:
      tt = "Đã phê duyệt";
      break;
    case 4:
      tt = "Đang trình ký";
      break;
    case 5:
      tt = "Đã ký";
      break;
    case 6:
      tt = "Đang  làm lại";
      break;
    case 8:
      tt = "Chờ xác nhận thu hồi";
      break;
  }
  return tt;
}
