import 'dart:async';
import 'dart:convert';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hb_mobile2021/common/SearchDropdownListServer.dart';
import 'package:hb_mobile2021/common/SmCombobox.dart';
import 'package:hb_mobile2021/common/VBDen/GiaoViec.dart';
import 'package:hb_mobile2021/common/VBDen/SuaVBD.dart';
import 'package:hb_mobile2021/common/VBDen/ThuHoiVB.dart';
import 'package:hb_mobile2021/common/VBDen/TreeChuyenNhanhVBD.dart';
import 'package:hb_mobile2021/common/VBDen/chuyenNhanh.dart';
import 'package:hb_mobile2021/core/models/VanBanDenJson.dart';
import 'package:hb_mobile2021/core/services/VBDiService.dart';
import 'package:hb_mobile2021/core/services/VbdenService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'package:hb_mobile2021/ui/vbduthao/themMoiHS/ThemMoiDT.dart';
import 'dart:developer' as Dev;
import 'package:multi_select_item/multi_select_item.dart';
import 'package:hb_mobile2021/common/VBDen/TreeChuyenVBDen.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'TabbarChiTiet/ChonDS.dart';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
class BottomNav extends StatefulWidget {
  int id;
  final int nam;
  final String MaDonVi;
  final ttvbDen;

  BottomNav({this.id,this.nam,this.MaDonVi,this.ttvbDen});

  @override
  _BottomNav createState() => _BottomNav();
}

class _BottomNav extends State<BottomNav> with SingleTickerProviderStateMixin {
  List dataSource = [
    {"display": "Xanh", "value": "1"},
    {"display": "Đỏ", "value": "2"},
    {"display": "Tím", "value": "3"},
    {"display": "Vàng", "value": "4"},
    {"display": "Lục", "value": "5"},
    {"display": "Lam", "value": "6"},
    {"display": "Chàm", "value": "7"},
    {"display": "Tím", "value": "8"}
  ];

  MultiSelectController controller = new MultiSelectController();
  DateTime _dateTime;
  DateTime selectedDate = DateTime.now();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  double _height;
  double _width;
  String _setDate;
  String _setDate1;
  bool isLoading = false;
  int _tabIndex = 0;
  TabController _tabController;
  final TreeController _treeController = TreeController(allNodesExpanded: false);
  List chitiet1 = [];
  String daidien = "true";
  List CBList = [];
  var dulieudt = "";
  bool multipleSelection;
  String selectedValue = "";
  var  ttduthao = null ;

  Map<String, bool> values = new Map<String, bool>();
  Map<String, bool> vals = new Map<String, bool>();
  ScrollController _scrollerController = new ScrollController();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var refreshKeyDS = GlobalKey<RefreshIndicatorState>();
  String ActionXL = "GetListVBDi";
  String ActionXLD =  "GetVBDByIDMobile";
  List<ListData> vanbanList = [];
  List _myActivities = [];
  List<String> _colors = <String>['', 'Văn bản 1', 'Văn bản 2', 'Văn bản 3', 'Văn bản 4'];
  String _color = '';
  String TenCB;
  int _radioValue = 0;
  int nam22 =  2022;
  final GlobalKey<State> key = new GlobalKey<State>();
  List<Widget> listDanhSach = new List<Widget>();
  bool isPressed = false;
  _pressed() {
    var newVal = true;
    if(isPressed) {
      newVal = false;
    } else {
      newVal = true;
    }
    if (mounted) { setState((){
      isPressed = newVal;
    });}

  }
  Timer _timer;


  void _initializeTimer() {
    _timer = Timer.periodic(const Duration(minutes:5), (_) {
      // logOut(context);
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
    ///_initializeTimer();
    ttduthao =  widget.ttvbDen;
    print("ttduthao " +ttduthao.toString());
   if(widget.nam != null ||widget.nam == "")
     {
       nam22 = widget.nam;
     }



    if (mounted) { setState(() {
      var tendangnhap = sharedStorage.getString("username");
      //GetDataNguoiPhoiHop(tendangnhap);
      GetDataDetailVBDi(tendangnhap);

      _tabController = TabController(vsync: this, length: 2);
      _scrollerController.addListener(() {
        if (_scrollerController.position.pixels == _scrollerController.position.maxScrollExtent) {
          GetDatacb(dulieudt);
          CBList;
          lstUsers;
          isPressed;
        }
      });
      controller.disableEditingWhenNoneSelected = true;
      controller.set(CBList.length);
      refreshList();
      refreshListDS();
    }); }


    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) { setState(() {
      refreshList();
      refreshListDS();
      UiGetData(CBList);


    });}

  }
  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
    if(_timer != null)
    _timer.cancel();
  }


  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));
    if (picked != null)
      if (mounted) { setState(() {
        selectedDate = picked;
        _dateController.text =  DateFormat('dd-MM-yyyy')
            .format(DateFormat('yyyy-MM-dd').parse(selectedDate.toString()));

      });}

  }
  void httpJob(AnimationController controller) async {
    controller.forward();
    print("delay start");
    await Future.delayed(Duration(seconds: 3), () {});
    print("delay stop");
    controller.reset();
  }

// lấy chi tiết văn bản
  GetDataDetailVBDi(String tendangnhap) async {
    String detailVBDi = await getDataCVBD(tendangnhap, 'GetTreeDonVi');
    int i;
    chitiet1 = json.decode(detailVBDi)['OData'][0]['children'];
    String vbdt = await getDataCB(tendangnhap, "GetListUserByPhongBan", chitiet1[0]['key'], daidien);

    if (mounted) { setState(() {
      // var data =  json.decode(detailVBDi)['OData'][0]['children'];
      CBList = json.decode(vbdt)['OData'];
      for (i = 0; i < chitiet1.length; i++) {
        String vl = chitiet1[i]['key'].toString();
        values.putIfAbsent(vl, () => false);
        if (chitiet1[i]['children'].length > 0) {
          Map<String, bool> values2 = new Map<String, bool>();
          for (int j = 0; j < chitiet1[i]['children'].length; j++) {
            String vl2 = chitiet1[i]['children'][j]['key'].toString();
            values2.putIfAbsent(vl2, () => false);
          }
          values.addAll(values2);

        }
      }
    }); }


  }

  GetDatacb(String data1) async {
    var tendangnhap = sharedStorage.getString("username");
    String vbdt = await getDataCB(tendangnhap, "GetListUserByPhongBan", data1, daidien);
    if (mounted) {

        setState(() {
          CBList = json.decode(vbdt)['OData'];
          refreshList();
          UiGetData(CBList);
          _toggleTab();
        });

    }

  }

// lấy danh sách người phối hợp
  GetDataNguoiPhoiHop(String tendangnhap) async {
    String detailVBDT = await getDataCVB(tendangnhap, ActionXL);

    if (mounted) {setState(() {
      var vanban = json.decode(detailVBDT)['OData'];
      var lstData = (vanban as List).map((e) => ListData.fromJson(e)).toList();
      List<ListData> lstDataSearch = List<ListData>();
      lstData.forEach((element) {
        lstDataSearch.add(element);
        vanbanList = lstDataSearch;
      });
    }); }

  }

  // click tbs mới
  void _toggleTab() {
    _tabIndex = _tabController.index + 1;
    _tabController.animateTo(_tabIndex);
  }

  // hàm tải lại trnag
  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);

    await Future.delayed(Duration(seconds: 2));
    if (mounted) { setState(() {
      CBList;
      context;
      lstUsers;

    }); }

    return null;
  }

  Future<Null> refreshListDS() async {
    refreshKeyDS.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    if (mounted) {  setState(() {
      //lstUsers;
      FloatingActionButton;

    });}

    return null;
  }

  //  title  bootm
  @override
  Widget build(BuildContext context) {



    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey[100]),
        color: Colors.white,
      ),
      height: 56.0,
      child:ttduthao != null? ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 1,
          itemBuilder: (context, index) {
            return Row(
              children: <Widget>[

                // isQTNew &&
                (vbdTTXuLyVanBanLT != 17
                    && vbdTTXuLyVanBanLT != 28
                    && vbdTTXuLyVanBanLT != 24
                    && vbdTTXuLyVanBanLT != 26)
                    ? Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            TextButton.icon(
                              icon: Icon(Icons.next_plan_outlined),
                              label: Text('ChuyểnVB'),
                              onPressed: () {
                                onPressButton(context, 7);
                              },
                              // textTheme: ButtonTextTheme.primary,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ):SizedBox(),

//Chuyển nahnh
//

                (vbdPhuongThuc != 3 && ThemVanBanDen == true &&
                    !(GuiVanBan== true))
                    ? Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            TextButton.icon(
                              icon: Icon(Icons.assistant_direction
                              ),
                              label: Text('Chuyển nhanh'),
                              onPressed: () {
                                onPressButton(context, 0);
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ):SizedBox(),


                //thuhoi

                isTraCuu ==true
                    && checkThuHoi ==true
                    && ( vbdTTXuLyVanBanLT != 17
                    && vbdTTXuLyVanBanLT != 28 && vbdTTXuLyVanBanLT != 24
                    && vbdTTXuLyVanBanLT != 26) 
                    && (vbdTrangThaiXuLyVanBan !=2)
                    ?Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton.icon(
                          icon: Icon(Icons.keyboard_return),
                          label: Text('Thu hồi'),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute
                              (builder: (context) =>ThuHoiVb(id:widget.id, nam:widget.nam)
                            ));


                          },
                        )
                      ],
                    ),
                  ),
                ): SizedBox(),
//Sửa
                SuaVanBanDen == true? Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton.icon(
                          icon: Icon(Icons.edit),
                          label: Text('Sửa'),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute
                              (builder: (context) =>SuaVBD(id:widget.id,
                              MaDonVi:widget.MaDonVi,Yearvb: widget.nam ,)
                            ));


                          },
                        )
                      ],
                    ),
                  ),
                ):SizedBox(),

//giao việc

                isTraCuu == true
                    // ( lstvbdUserChuaXuLy.where((o) => o['LookupId'] == currentUserID >0'))
            && vbdUserChuaXuLy == true
                    //&& currentDuThao.ID <= 0
                    && (vbdTTXuLyVanBanLT != 17
                    && vbdTTXuLyVanBanLT != 28 
                    && vbdTTXuLyVanBanLT != 24 && vbdTTXuLyVanBanLT != 26)
                ?Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton.icon(
                          icon: Icon(Icons.present_to_all_outlined),
                          label: Text('Giao việc'),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute
                              (builder: (context) =>GiaoViec(id:widget.id,
                              MaDonVi:widget.MaDonVi,Yearvb: widget.nam ,)
                            ));


                          },
                        )
                      ],
                    ),
                  ),
                ):SizedBox(),



//từ chối
                (ThemVanBanDen == true
                    || lstPhongBanLaVanThuVBDEN.length == 0)
                    && vbdPhuongThuc !=0
                    && !(vbdSoVanBan > 0) && (vbdTTXuLyVanBanLT != 17
                    && vbdTTXuLyVanBanLT != 28
                    && vbdTTXuLyVanBanLT != 24 && vbdTTXuLyVanBanLT != 26)
                    ? Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            TextButton.icon(
                              icon: Icon(Icons.undo_rounded),
                              label: Text('Từ chối VB'),
                              onPressed: () {
                                onPressButton(context, 9);
                              },
                              // textTheme: ButtonTextTheme.primary,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ):SizedBox(),
//ý kiến
                Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton.icon(
                          icon: Icon(Icons.comment),
                          label: Text('Ý kiến'),
                          onPressed: () {
                            onPressButton(context, 1);
                          },
                          //textTheme: ButtonTextTheme.primary,
                        )
                      ],
                    ),
                  ),
                ),

//Xử lý xong

                (isTraCuu == true && (vbdIsSentVanBan == true|| vbdPhuongThuc == 2)
                    && (vbdTTXuLyVanBanLT != 17 && vbdTTXuLyVanBanLT != 28 
                    && vbdTTXuLyVanBanLT != 24 && vbdTTXuLyVanBanLT != 26)
                    && (vbdUserChuaXuLy == true))||
                    (!ThemVanBanDen
                    || (ThemMoiVanBanDuThao == true
                    && !SiteAction.contains("vpubhb")))

                    ?  Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton.icon(
                          icon: Icon(Icons.move_to_inbox),
                          label: Text('Xử lý xong'),
                          onPressed: () {
                            onPressButton(context, 8);
                          },
                          //textTheme: ButtonTextTheme.primary,
                        )
                      ],
                    ),
                  ),
                ) : SizedBox(),

// bút phê
                butPheVBD == true ?Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton.icon(
                          icon: Icon(Icons.comment),
                          label: Text('Bút phê'),
                          onPressed: () {
                            onPressButton(context, index + 5);
                          },
                          //textTheme: ButtonTextTheme.primary,
                        )
                      ],
                    ),
                  ),
                ):SizedBox(),


//hạn xử lý


                isTraCuu== true  && vbdIsSentVanBan == true
                    && vbdUserChuaXuLy == true
                    && (vbdHanXuLy != null || vbdHanXuLy != "")
                    && (vbdTTXuLyVanBanLT != 17
                    &&vbdTTXuLyVanBanLT != 28
                    && vbdTTXuLyVanBanLT != 24
                    && vbdTTXuLyVanBanLT != 26)
                    ? Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton.icon(
                          icon: Icon(Icons.calendar_today),
                          label: Text('Hạn xử lý'),
                          onPressed: () {
                            onPressButton(context, index + 6);
                          },
                          //textTheme: ButtonTextTheme.primary,
                        )
                      ],
                    ),
                  ),
                ):SizedBox() ,

//Xem để biết
                checkbtnXDB == true && (vbdTTXuLyVanBanLT != 17
                    && vbdTTXuLyVanBanLT != 28
                    && vbdTTXuLyVanBanLT != 24
                    && vbdTTXuLyVanBanLT != 26)
                    ?  Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton.icon(
                          icon: Icon(Icons.add_to_home_screen_rounded),
                          label: Text('Xem để biết'),
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Xem để biết'),
                              content: const Text('Bạn có chắc chắn muốn chuyển văn bản sang trạng thái xem để biết?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    var thanhcong = await postChuyenTT(
                                        widget.id, "XemDB",widget.nam);
                                    Navigator.of(context).pop();
                                    await showAlertDialog(context, json.decode(thanhcong)['Message']);

                                  },
                                  child: const Text('Tiếp tục '),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Huỷ'),
                                ),
                              ],
                            ),
                          ),

                          //textTheme: ButtonTextTheme.primary,
                        )
                      ],
                    ),
                  ),
                ):SizedBox(),



                  isTraCuu== true && vbdTrangThaiXuLyVanBan != 3
                     && XemDB.contains("",currentUserID)&&
             (vbdTTXuLyVanBanLT != 17
            && vbdTTXuLyVanBanLT != 28
            && vbdTTXuLyVanBanLT != 24
            && vbdTTXuLyVanBanLT != 26)
                    ?  Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton.icon(
                          icon: Icon(Icons.file_copy_sharp),
                          label: Text('Dự thảo VB'),
                          onPressed: () =>Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (BuildContext context) => ThemMoiDT()),
                                  (Route<dynamic> route) => true) ,

                          //textTheme: ButtonTextTheme.primary,
                        )
                      ],
                    ),
                  ),
                ):SizedBox(),



              ],
            );
          }): Center(
          child: CircularProgressIndicator()
      ),
    );
  }

  void onPressButton(context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          if(_timer != null){
            _timer.cancel();
          }

          return _getBodyPage(context, index);
        });
  }

  void add() {
    CBList.add({"key": CBList.length + 1});
    if (mounted) {  setState(() {
      controller.set(CBList.length);
    });}

  }

  //treeview chuyển văn bản
  List<TreeNode> toTreeNodes(dynamic parsedJson) {
    if (parsedJson is Map<String, dynamic>) {
      String title11 = parsedJson['title'];
      // existingItem = chitiet.firstWhere(
      //         (itemToCheck) => itemToCheck == parsedJson['key'],
      //     orElse: () => null);
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
              children: toTreeNodes(parsedJson[k])))
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
                      InkWell(
                        child: Container(
                          child: Text(
                            parsedJson[i]['title'],
                          ),
                        ),
                        onTap: () async {
                          String data1 = parsedJson[i]['key'];
                          dulieudt = data1;
                          GetDatacb(data1);
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  children: toTreeNodes(parsedJson[i]['children']),
                ),
              ))
          .values
          .toList();
    }
    return [TreeNode(content: Text(parsedJson.toString()))];
  }

  void selectAll() {
    if (mounted) { setState(() {
      controller.toggleAll();
    }); }

  }
  bool isAllSpaces(String input) {
    String output = input.replaceAll(' ', '');
    if(output == '') {
      return true;
    }
    return false;
  }


  List<bool> checkPH = [];

  Widget UiGetData(List<dynamic> lstCB) {
    CBList = lstCB;
    if(lstCB != null){
      if (lstCB.length <= 0 || CBList.length == 0) {
        return Center(
          child: Text("Phòng ban chưa có cán bộ"),
        );
      } else{
        return RefreshIndicator(
          key: refreshKey,
          child: Stack(
            children: [
              ListView.builder(
                itemCount: CBList.length,
                // ignore: missing_return
                itemBuilder: (context, index) {

                  if (CBList.length > 0 && index < CBList.length) {
                    return getBody(CBList[index]);
                  } else if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
                      child: Center(
                        child: Text(
                          "Không có bản ghi",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    );
                  }
                },
                controller: _scrollerController,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    // lstUsers;
                    // selectedValue;
                    // fetchData();
                    // _toggleTab();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => ChonDS()),
                            (Route<dynamic> route) => true);
                  },
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 60.0,
                  ),
                  style: ElevatedButton.styleFrom(shape: CircleBorder(), primary: Colors.blue),
                ),
              ),
            ],
          ),
          onRefresh: refreshList,
        );
      }
    }


  }

  Widget getBody(item) {

    var title = item["Title"];
    TenCB = title;
    //VanBanDiJson vbdi = vanBanDiJson(item.toString());
    return Card(
      elevation: 1.5,
      child: InkWell(
        onTap: () {
          if (mounted) {setState(() {}); }

        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                          padding: EdgeInsets.fromLTRB(5.0, 3, 0, 0),
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                            title,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: FloatingActionButton(
                          child: const Icon(Icons.group_add_outlined),
                          backgroundColor:isPressed ?Colors.red: Colors.blue.shade800 ,
                          onPressed: () {
                            _pressed();
                            if (mounted) { setState(() {

                              if (!(lstUsers.length > 0) ||
                                  (lstUsers.length > 0 && !lstUsers.containsKey(item["ID"]))) {
                                lstUsers.addAll({item["ID"]: item["Title"]});
                                // lst.addAll({item["ID"]: item["Title"]});

                              }

                              if (!selectedValue.contains("^" + item["ID"].toString() + ";#")) {
                                String val = "^" + item["ID"].toString() + ";#" + item["Title"];
                                selectedValue += val;
                              }


                              strID.add(item["ID"]);
                              refreshListDS();
                            });}

                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // dữ liệu toàn bộ
  Widget _getBodyPage(context, int index) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    switch (index) {
      case 0:
        return Scaffold(
          body:
          SingleChildScrollView(
            child:TreeChuyenNhanhVBDen(id:widget.id,nam:widget.nam),

          ),
        );
        break;
      case 1:
        return
          SingleChildScrollView(child:
        Container(
            height: MediaQuery.of(context).size.height * .60,
            child: Column(
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Theme(
                    data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                    child: TextField(
                      autofocus: false,
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black),
                      controller: _titleController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.add, color: Colors.black26, size: 22.0),
                        filled: true,
                        fillColor: Color(0x162e91),
                        hintText: 'Nhập ý kiến',
                        contentPadding: EdgeInsets.only(left: 10.0, top: 15.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black26),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black26),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onChanged: null,
                    ),
                  ),
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
                            .width * 0.25,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.06,
                        child:TextButton.icon (
                            icon: Icon(Icons.send),
                            label: Text("Gửi",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),textAlign:
                            TextAlign.center,),
                            onPressed: ()   async {
                              String iaa =  _titleController.text.trim();
                              var tendangnhap = sharedStorage.getString("username");
                              if(isAllSpaces(iaa) )
                              {
                                showAlertDialog(context,"Nhập ý kiến!");
                              }
                              else{
                                  var thanhcong=  null;
                                  var thongbao = null;


                                  EasyLoading.show();


                                  // await httpJob(controller);
                                  thanhcong= await  postYKienVBD(tendangnhap,
                                    widget.id, "ADDYKien", _titleController
                                          .text,widget.nam);
                                  _titleController.text = "";
                                  EasyLoading.dismiss();
                                  Navigator.of(context).pop();
                                  thongbao =  json.decode(thanhcong)['Message'];
                                  showAlertDialog(context,thongbao );


                                //showLoading(context)




                                Navigator.of(context).pop();

                                _titleController.text = "";
                              }
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
                            _timer.cancel();
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          )
                      ),),
                  ),

                ],)



              ],
            )),);
        break;
      case 2:
        return Container(
          height: MediaQuery.of(context).size.height * .60,
          child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Đồng ý thu hồi văn bản',
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
                                icon: Icon(Icons.send_and_archive),
                                label: Text("Thu hồi",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
                                  textAlign:
                                  TextAlign.center,),
                                onPressed: ()async   {
                                  EasyLoading.show();
                                  _timer.cancel();
                                  EasyLoading.dismiss();
                                  Navigator.of(context).pop();
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
                                  _timer.cancel();
                                  Navigator.of(context).pop();
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                )
                            ),),
                        ),

                      ],)
                  ],
                ),
              )),
        );
        break;
      case 3:
        return DefaultTabController(
            length:2,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(50.0),
                child: AppBar(
                  bottom: TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(
                        text: 'Đơn vị',
                      ),
                      Tab(
                        text: 'Danh sách CB',
                      ),
                      // Tab(
                      //   text: 'Danh sách chọn',
                      // ),
                    ],
                  ),
                ),
              ),
              body: !isLoading
                  ? TabBarView(
                      controller: _tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        SingleChildScrollView(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: EdgeInsets.all(30),
                              child: Column(
                                children: [
                                  //TreeChuyenVBD(toggleTab:_toggleTab),
                                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    TreeView(
                                      nodes: toTreeNodes(chitiet1),
                                      treeController: _treeController,
                                    ),
                                  ])
                                ],
                              ),
                            ),
                          ),
                        ),
                        UiGetData(CBList),
                       // UiGetDanhSach(),

                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ));
        break;
      case 4:
        return Container(
          height: MediaQuery.of(context).size.height * .60,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Chọn văn bản ký số'),
              ),
              new SmComboBox(
                dataSource: dataSource,
                titleText: 'Màu sắc',
                myActivities: _myActivities,
                onSaved: (value) {
                  Dev.log('$value');
                },
              ),
              new FormField(
                builder: (FormFieldState state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      icon: const Icon(FontAwesomeIcons.paintBrush),
                      labelText: 'Chọn văn bản',
                    ),
                    isEmpty: _color == '',
                    child: new DropdownButtonHideUnderline(
                      child: new DropdownButton(
                        value: _color,
                        isDense: true,
                        onChanged: (String newValue) {
//                           setState(() {
// //                                newContact.favoriteColor = newValue;
//                             _color = newValue;
//                             state.didChange(newValue);
//                           });
                        },
                        items: _colors.map((String value) {
                          return new DropdownMenuItem(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  child: Text("Ký số"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.blueAccent)),
                ),
              )
            ],
          ),
        );
        break;
      case 5:
        return Container(
            height: MediaQuery.of(context).size.height * .60,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Theme(
                    data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                    child: TextField(
                      autofocus: false,
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black),
                      controller: _titleController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.add, color: Colors.black26, size: 22.0),
                        filled: true,
                        fillColor: Color(0x162e91),
                        hintText: 'Ý kiến bút phê',
                        contentPadding: EdgeInsets.only(left: 10.0, top: 15.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black26),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black26),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onChanged: null,
                    ),
                  ),
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
                            label: Text("Bút phê",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
                              textAlign:
                              TextAlign.center,),
                            onPressed: () async {
                              bool isAllSpaces(String input) {
                                String output = input.replaceAll(' ', '');
                                if(output == '') {
                                  return true;
                                }
                                return false;
                              }
                              var tendangnhap = sharedStorage.getString("username");
                              String iaa =  _titleController.text.trim();
                              if(isAllSpaces(iaa))
                              {showAlertDialog(context,"Nhập ý kiến, bút phê");
                              }
                              else {
                                EasyLoading.show();
                                var thanhcong = await postYKienVBD
                                  (tendangnhap, widget.id, "ADDButPhe",
                                    _titleController.text,widget.nam);
                                EasyLoading.dismiss();
                                Navigator.of(context).pop();
                                _titleController.text = "";

                                Navigator.of(context).pop();

                                showAlertDialog(context, json.decode(thanhcong)['Message']);
                              }

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
            ));
        break;
      case 6:
        return Container(
            height: MediaQuery.of(context).size.height * .60,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        child: Text("Hạn xử lý"),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                        child: InkWell(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: Container(
                            width: _width / 1.8,
                            height: _height / 20,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: TextFormField(
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                              enabled: false,
                              keyboardType: TextInputType.text,
                              controller: _dateController == null ? selectedDate : _dateController,
                              // onSaved: (val) {
                              //   _setDate1 = val;
                              // },
                              decoration: InputDecoration(
                                  disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                  // labelText: 'Time',
                                  contentPadding: EdgeInsets.only(bottom: 15.0)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
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
                            .width * 0.4,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.06,
                        child:TextButton.icon (
                            icon: Icon(Icons.schedule_send),
                            label: Text("Cập nhật",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
                              textAlign:
                              TextAlign.center,),
                            onPressed: () async {
                              var tendangnhap = sharedStorage.getString("username");
                              EasyLoading.show();
                              var thanhcong = await postHanXuLyVBD
                                (tendangnhap, widget.id, "HanXuLy",
                                  _dateController.text.toString(),widget.nam);

                              EasyLoading.dismiss();
                              Navigator.of(context).pop();
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
            ));
        break;
      case 7:
        return Scaffold(
          body:
          SingleChildScrollView(
            child:TreeChuyenVBDen(id:widget.id,nam:widget.nam),

          ),
        );
        break;
      case 8:
        return
          SingleChildScrollView(child:
          Container(
              height: MediaQuery.of(context).size.height * .60,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Theme(
                      data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                      child: TextField(
                        autofocus: false,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black),
                        controller: _titleController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.add, color: Colors.black26, size: 22.0),
                          filled: true,
                          fillColor: Color(0x162e91),
                          hintText: 'Nhập ý kiến  xử lý',
                          contentPadding: EdgeInsets.only(left: 10.0, top: 15.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onChanged: null,
                      ),
                    ),
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
                              .width * 0.4,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.06,
                          child:TextButton.icon (
                              icon: Icon(Icons.send),
                              label: Text("Cập nhật",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
                                textAlign:
                                TextAlign.center,),
                              onPressed: ()async   {

                                String iaa =  _titleController.text.trim();
                                var tendangnhap = sharedStorage.getString("username");
                                if(isAllSpaces(iaa) )
                                {
                                  showAlertDialog(context,"Nhập ý kiến xử lý !");
                                }
                                else{
                                  var thanhcong=  null;
                                  var thongbao =null ;
                                  // await httpJob(controller);
                                  EasyLoading.show();
                                  thanhcong= await  postXuLyXongVBD(tendangnhap,
                                    widget.id, "Done", _titleController
                                          .text,widget.nam);
                                  //showLoading(context);
                                  EasyLoading.dismiss();

                                  showAlertDialog(context, json.decode(thanhcong)['Message']);



                                  Navigator.of(context).pop();

                                  _titleController.text = "";
                                }
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
              )),);
        break;
      case 9:
        return Container(
            height: MediaQuery.of(context).size.height * .60,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Theme(
                    data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                    child: TextField(
                      autofocus: false,
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black),
                      controller: _titleController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.add, color: Colors.black26, size: 22.0),
                        filled: true,
                        fillColor: Color(0x162e91),
                        hintText: 'Nhập ý kiến từ chối',
                        contentPadding: EdgeInsets.only(left: 10.0, top: 15.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black26),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black26),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onChanged: null,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.only(left: 10,right: 10,top: 10),
                      child:   TextButton.icon (
                        // child: Text("Đóng lại",style: TextStyle(fontWeight: FontWeight.bold),),
                          icon: Icon(Icons.send_and_archive),
                          label: Text('Cập nhật',style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () async {
                            bool isAllSpaces(String input) {
                              String output = input.replaceAll(' ', '');
                              if(output == '') {
                                return true;
                              }
                              return false;
                            }
                            var tendangnhap = sharedStorage.getString("username");
                            String iaa =  _titleController.text.trim();
                            if(isAllSpaces(iaa))
                            {showAlertDialog(context,"Nhập ý kiến từ chối");
                            }
                            else {
                              EasyLoading.show();
                              var thanhcong = await postTuCHoiVBD(tendangnhap,
                                  widget.id, "TUCHOI", _titleController.text,
                                  widget.nam);
                              Navigator.of(context).pop();
                              _titleController.text = "";
                              EasyLoading.dismiss();
                              Navigator.of(context).pop();

                              showAlertDialog(context, json.decode(thanhcong)['Message']);
                            }

                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue[50]),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                          )
                      ),
                    ),

                    Padding(padding: EdgeInsets.only(left: 10,right: 10,top: 10),
                      child:   TextButton.icon (
                        // child: Text("Đóng lại",style: TextStyle(fontWeight: FontWeight.bold),),
                          icon: Icon(Icons.delete_forever),
                          label: Text('Đóng lại',style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          )
                      ),
                    )

                  ],)
              ],
            ));
        break;
    }
  }
}

//dữ liệu văn bản
class ListDataVBD {
  String text;
  String ID;

  ListDataVBD({@required this.text, @required this.ID});

  factory ListDataVBD.fromJson(Map<String, dynamic> json) {
    return ListDataVBD(ID: (json['key']), text: json['title']);
  }
}
