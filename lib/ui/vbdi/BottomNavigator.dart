import 'dart:async';
import 'dart:convert';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hb_mobile2021/common/VBDi/ChuyenNBVBDi.dart';
import 'package:hb_mobile2021/common/SearchDropdownListServer.dart';
import 'package:hb_mobile2021/common/SmCombobox.dart';
import 'package:hb_mobile2021/common/VBDi/TableUserTT.dart';
import 'package:hb_mobile2021/common/VBDi/ThuHoiVBDi.dart';
import 'package:hb_mobile2021/common/VBDi/thayTheVB.dart';
import 'package:hb_mobile2021/common/VBDi/thaythe.dart';
import 'package:hb_mobile2021/common/VBDi/thietLapHBVBDi.dart';
import 'package:hb_mobile2021/core/services/VBDiService.dart';
import 'package:hb_mobile2021/core/models/VanBanDiJson.dart';
import 'package:hb_mobile2021/core/services/VbdenService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'dart:developer' as Dev;
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:hb_mobile2021/common/VBDi/TreeFromJson.dart';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'package:hb_mobile2021/ui/vbdi/viewPDF_ChuyenLT.dart';

import '../main/viewPDF.dart';

class BottomNav extends StatefulWidget {
  int id;
  int nam;
  String MaDonVi;
  final ttVbanDi;

  BottomNav({this.id,this.nam,this.MaDonVi,this.ttVbanDi});

  @override
  _BottomNav createState() => _BottomNav(id: id);
}
final GlobalKey<State> _keyLoader = new GlobalKey<State>();
class _BottomNav extends State<BottomNav> {
  int id;
  String idCDSD;
  List dataCheDoSD = [{"Title":"Khai thác, tra cứu","ID":"1"},{"Title":"Thu thập, lưu trữ ","ID":"2"}];

bool isLoading = false;
  int vbdiTrangThaiVB = 0;
  String idLoaiVBN = "";

  _BottomNav({this.id});
  Timer _timer;


  void _initializeTimer() {
    _timer = Timer.periodic(const Duration(minutes:5), (_) {
      // logOut(context);
      _timer.cancel();
    });

  }

  void _handleUserInteraction([_]) {
    // if (!_timer.isActive) {
    //   // This means the user has been logged out
    //   return;
    // }
    //
    // _timer.cancel();
    // _initializeTimer();
  }

  @override
  void initState() {
   // _initializeTimer();
    var tendangnhap = sharedStorage.getString("username");
   GetDataNguoiPhoiHop(tendangnhap);
    vbdiTrangThaiVB = trangThaiVB  ;
    super.initState();
    GetDataDetailVBDi(widget.id);


  }
  @override
  void dispose() {
    super.dispose();
    currentUserID;
    EasyLoading.dismiss();

  }


  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey[100]),
        color: Colors.white,
      ),
      height: 56.0,
      child: vanbanList.length > 0 && widget.ttVbanDi != null  ?
      ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 1,
          itemBuilder: (context, index) {
            return Row(
              children: <Widget>[
                GuiVanBanDi == true ?Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            FlatButton.icon(
                              icon: Icon(Icons.next_plan_outlined),
                              label: Text('Chuyển VB ngoài đơn vị'),
                              onPressed: () {

                                // onPressButton(context, 0);
                                onPressButton(context, 3);
                              },
                              textTheme: ButtonTextTheme.primary,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ): SizedBox(),
                GuiVanBanDi == true ?Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            FlatButton.icon(
                              icon: Icon(Icons.next_plan_outlined),
                              label: Text('Chuyển VB nội bộ đơn vị'),
                              onPressed: () {

                                // onPressButton(context, 0);
                                onPressButton(context, 6);
                              },
                              textTheme: ButtonTextTheme.primary,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ):SizedBox(),

                //Chuyển trục liên thông
                ((!CurrentTenDonVi.toUpperCase().startsWith("XÃ")
                    && !CurrentTenDonVi.toUpperCase().startsWith("PHƯỜNG"))
                    || SiteAction.contains("xalongson"))
                    && GuiVanBanDi == true

               ? Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            FlatButton.icon(
                              icon: Icon(Icons.next_plan_outlined),
                              label: Text('Chuyển trục liên thông'),
                              onPressed: () {

                                // onPressButton(context, 0);
                                onPressButton(context, 0);
                              },
                              textTheme: ButtonTextTheme.primary,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ):SizedBox(),

                //Ý kiến bút phê
                Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton.icon(
                          icon: Icon(Icons.comment),
                          label: Text('Ý kiến/bút phê'),
                          onPressed: () {

                            onPressButton(context, 1);
                          },
                          textTheme: ButtonTextTheme.primary,
                        )
                      ],
                    ),
                  ),
                ),

                //Thay thế văn bản

                  (checkThuHoi == true&&(ThemMoiVanBanDi == true
                    || (userTenTruyCap.contains("thuyvn") &&
                          SiteAction.contains("vpubhb"))
                    || (vbdiPBLookup>0 && lstPhongBanLaVanThuVBDI.length > 0))) &&
                      vbdiTrangThaiVB != 13
                    ? Container(
                  child: InkWell(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              TextButton.icon(
                                icon: Icon(Icons.ad_units_outlined
                                ),
                                label: Text('Thay thế VB'),
                                onPressed: () {

                                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                  // JsonDataGrid()));
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                      ThayThe(id: id,nam:widget.nam.toString()
                                      )));


                                },
                              )
                            ],
                          )
                        ]
                    ),
                  ),
                ):SizedBox(),

                // thiết lập hồi báo

                !vbdiCanTDHB &&
                   ThietLapHoiBao ==true
                    &&vbdiTrangThaiVB !=13
                    ? Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            TextButton.icon(
                              icon: Icon(Icons.assistant
                              ),
                              label: Text('Thiết lập hồi báo'),
                              onPressed: () {

                                onPressButton(context, 7);
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ):SizedBox(),

                // Cập nhật
                  (checkThuHoi== true&&(ThemMoiVanBanDi ==true
                    || (userTenTruyCap.contains("thuyvn") &&
                        SiteAction.contains("vpubhb")))
                    || (
                          vbdiPBLookup>0 &&
                     lstPhongBanLaVanThuVBDI.length > 0)) &&
                    vbdiTrangThaiVB !=13
                    ? Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            TextButton.icon(
                              icon: Icon(Icons.arrow_forward
                              ),
                              label: Text('Cập nhật VB '),
                              onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Xác nhận'),
                                  content: const Text('Bạn có chắc chắn muốn cập nhật văn bản'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {

                                        var tendangnhap = sharedStorage.getString("username");
                                        EasyLoading.show();
                                        var thanhcong =  await postCapNhatVB
                                          (tendangnhap, widget.id, "CapNhatVB",widget.nam);
                                        EasyLoading.dismiss();
                                        Navigator.of(context).pop();

                                        showAlertDialog(context, json.decode
                                          (thanhcong)['Message']);
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
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ):SizedBox(),


                // đã chuỷen văn bản

                  (!vbdiIsSentVanBan && CapSoVanBanDi == true)
                    && vbdiTrangThaiVB != 13
                    ? Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            TextButton.icon(
                              icon: Icon(Icons.arrow_forward
                              ),
                              label: Text('Đã chuyển VB '),
                              onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Xác nhận'),
                                  content: const Text('Bạn có chắc chắn muốn văn bản đi đã chuyển'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {
                                        var tendangnhap = sharedStorage.getString("username");
                                        EasyLoading.show();
                                        var thanhcong =  await postDaChuyenVB
                                          (tendangnhap, widget.id, "DaChuyenVB","true");
                                        EasyLoading.dismiss();
                                        Navigator.of(context).pop();
                                        showAlertDialog(context, json.decode(thanhcong)['Message']);
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
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ):SizedBox(),


                //Thu hồi
                  (checkThuHoi == true&&(ThemMoiVanBanDi ==true
                    || (userTenTruyCap.contains("thuyvn")
                        && SiteAction.contains("vpubhb"))
                    || (
                       vbdiPBLookup>0 &&
                         lstPhongBanLaVanThuVBDI.length > 0)))
                    && vbdiTrangThaiVB != 13
                    ?Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton.icon(
                          icon: Icon(Icons.keyboard_return),
                          label: Text('Thu hồi'),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute
                              (builder: (context) =>ThuHoiVbDi(id:widget.id, nam:widget.nam)
                            ));
                          },

                          textTheme: ButtonTextTheme.primary,
                        )
                      ],
                    ),
                  ),
                ):SizedBox(),

//Trả lại
               vbdiIsSentVanBan == false  && (CapSoVanBanDi == true
                    || lstPhongBanLaVanThuVBDI.length > 0) &&
                    vbdiTrangThaiVB != 13
                    ?Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton.icon(
                          icon: Icon(Icons.keyboard_return),
                          label: Text('Trả lại'),
                          onPressed: () {
                            onPressButton(context, 5);
                          },
                          textTheme: ButtonTextTheme.primary,
                        )
                      ],
                    ),
                  ),
                ):SizedBox(),
              ],
            );
          }) :
      Center(child: CircularProgressIndicator()
      ),
    );

//     return GestureDetector(
//       onTap: _handleUserInteraction,
//       onPanDown: _handleUserInteraction,
//       onScaleStart: _handleUserInteraction,
//       child:Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.blueGrey[100]),
//         color: Colors.white,
//       ),
//       height: 56.0,
//       child: vanbanList.length > 0 ?
//       ListView.builder(
//           scrollDirection: Axis.horizontal,
//           itemCount: 1,
//           itemBuilder: (context, index) {
//             return Row(
//               children: <Widget>[
//                 GuiVanBanDi == true ?Container(
//                   child: InkWell(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Column(
//                           children: <Widget>[
//                             FlatButton.icon(
//                               icon: Icon(Icons.next_plan_outlined),
//                               label: Text('Chuyển VB ngoài đơn vị'),
//                               onPressed: () {
//                                 // onPressButton(context, 0);
//                                 onPressButton(context, 3);
//                               },
//                               textTheme: ButtonTextTheme.primary,
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ): SizedBox(),
//                 GuiVanBanDi == true ?Container(
//                   child: InkWell(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Column(
//                           children: <Widget>[
//                             FlatButton.icon(
//                               icon: Icon(Icons.next_plan_outlined),
//                               label: Text('Chuyển VB nội bộ đơn vị'),
//                               onPressed: () {
//                                 // onPressButton(context, 0);
//                                 onPressButton(context, 6);
//                               },
//                               textTheme: ButtonTextTheme.primary,
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ):SizedBox(),
//
//                 //Chuyển trục liên thông
//                 Container(
//                   child: InkWell(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Column(
//                           children: <Widget>[
//                             FlatButton.icon(
//                               icon: Icon(Icons.next_plan_outlined),
//                               label: Text('Chuyển trục liên thông'),
//                               onPressed: () {
//                                 // onPressButton(context, 0);
//                                 onPressButton(context, 0);
//                               },
//                               textTheme: ButtonTextTheme.primary,
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//
//               //Ý kiến bút phê
//               Container(
//                   child: InkWell(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         FlatButton.icon(
//                           icon: Icon(Icons.comment),
//                           label: Text('Ý kiến/bút phê'),
//                           onPressed: () {
//                             onPressButton(context, 1);
//                           },
//                           textTheme: ButtonTextTheme.primary,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 //Thay thế văn bản
//                 (checkThuHoi == true
//             //&&(ThemMoiVanBanDi == true
//                     // ||(userTenTruyCap.contains("thuyvn") && SiteAction.contains("vpubhb"))
//                    // || lstPhongBanLaVanThuVBDI.length == 0)
//                 ) && vbdiTrangThaiVB != 13
//                     ? Container(
//                   child: InkWell(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Column(
//                           children: <Widget>[
//                             TextButton.icon(
//                               icon: Icon(Icons.ad_units_outlined
//                               ),
//                               label: Text('Thay thế VB'),
//                               onPressed: () {
//                                 // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
//                                 // JsonDataGrid()));
//                                 Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
//                                     JsonDataGrid(id: id,nam:widget.nam.toString())));
//
//
//                               },
//                             )
//                           ],
//                         )
//                       ]
//                     ),
//                   ),
//                 ):SizedBox(),
//
//                 // thiết lập hồi báo
//                 vbdiCanTDHB == false && ThietLapHoiBao == true
//                     && vbdiTrangThaiVB !=13
//                     ? Container(
//                   child: InkWell(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Column(
//                           children: <Widget>[
//                             TextButton.icon(
//                               icon: Icon(Icons.assistant
//                               ),
//                               label: Text('Thiết lập hồi báo'),
//                               onPressed: () {
//                                 onPressButton(context, 7);
//                               },
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ):SizedBox(),
//
//                 // Cập nhật
//                 (checkThuHoi == true &&(ThemMoiVanBanDi == true
//                     || (userTenTruyCap.contains("thuyvn") && SiteAction.contains("vpubhb"))) ||
//                     lstPhongBanLaVanThuVBDI.length > 0)
//                     && vbdiTrangThaiVB !=13
//                     ? Container(
//                   child: InkWell(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Column(
//                           children: <Widget>[
//                             TextButton.icon(
//                               icon: Icon(Icons.arrow_forward
//                               ),
//                               label: Text('Cập nhật VB '),
//                               onPressed: () => showDialog<String>(
//                                 context: context,
//                                 builder: (BuildContext context) => AlertDialog(
//                                   title: const Text('Xác nhận'),
//                                   content: const Text('Bạn có chắc chắn muốn cập nhật văn bản'),
//                                   actions: <Widget>[
//                                     TextButton(
//                                       onPressed: () async {
//                                         var tendangnhap = sharedStorage.getString("username");
//                                         EasyLoading.show();
//                                         var thanhcong =  await postCapNhatVB
//                                           (tendangnhap, widget.id, "CapNhatVB",widget.nam);
//                                         EasyLoading.dismiss();
//                                         Navigator.of(context).pop();
//
//                                       showAlertDialog(context, json.decode
//                                         (thanhcong)['Message']);
//                                       },
//                                       child: const Text('Tiếp tục '),
//                                     ),
//                                     TextButton(
//                                       onPressed: () => Navigator.pop(context),
//                                       child: const Text('Huỷ'),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ):SizedBox(),
//
//
//                 // đã chuỷen văn bản
//                 (vbdiIsSentVanBan == false
//             && CapSoVanBanDi == true)
//             && vbdiTrangThaiVB != 13
//                 ? Container(
//                   child: InkWell(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Column(
//                           children: <Widget>[
//                             TextButton.icon(
//                               icon: Icon(Icons.arrow_forward
//                               ),
//                               label: Text('Đã chuyển VB '),
//                               onPressed: () => showDialog<String>(
//                                 context: context,
//                                 builder: (BuildContext context) => AlertDialog(
//                                   title: const Text('Xác nhận'),
//                                   content: const Text('Bạn có chắc chắn muốn văn bản đi đã chuyển'),
//                                   actions: <Widget>[
//                                     TextButton(
//                                       onPressed: () async {
//                                         var tendangnhap = sharedStorage.getString("username");
//                                         EasyLoading.show();
//                                         var thanhcong =  await postDaChuyenVB
//                                           (tendangnhap, widget.id, "DaChuyenVB","true");
//                                         EasyLoading.dismiss();
//                                         Navigator.of(context).pop();
//
//                                         !isLoading
//                                             ? showAlertDialog(context, json.decode(thanhcong)['Message'])
//                                             : Center(child: CircularProgressIndicator());
//                                       },
//                                       child: const Text('Tiếp tục '),
//                                     ),
//                                     TextButton(
//                                       onPressed: () => Navigator.pop(context),
//                                       child: const Text('Huỷ'),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ):SizedBox(),
//
//
//                 //Thu hồi
//                 (checkThuHoi == true&&(ThemMoiVanBanDi == true
//                     || (userTenTruyCap.contains("thuyvn")
//                         && SiteAction.contains("vpubhb"))
//                     || lstPhongBanLaVanThuVBDI.length > 0))
//                     && vbdiTrangThaiVB != 13
//                      ?Container(
//                   child: InkWell(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         FlatButton.icon(
//                           icon: Icon(Icons.keyboard_return),
//                           label: Text('Thu hồi'),
//                           onPressed: () {
//                             Navigator.of(context).push(MaterialPageRoute
//                               (builder: (context) =>ThuHoiVbDi(id:widget.id, nam:widget.nam)
//                             ));
//                           },
//
//                           textTheme: ButtonTextTheme.primary,
//                         )
//                       ],
//                     ),
//                   ),
//                 ):SizedBox(),
//
// //Trả về
//                 vbdiIsSentVanBan == false
//                     && vbdiSoKyHieu.isEmpty
//                     && vbdiSoKyHieu != null
//                     &&(CapSoVanBanDi == true
//                         || lstPhongBanLaVanThuVBDI.length > 0)
//                     && vbdiTrangThaiVB != 13
//                     ?Container(
//                   child: InkWell(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         FlatButton.icon(
//                           icon: Icon(Icons.keyboard_return),
//                           label: Text('Trả về'),
//                           onPressed: () {
//                             onPressButton(context, 5);
//                           },
//                           textTheme: ButtonTextTheme.primary,
//                         )
//                       ],
//                     ),
//                   ),
//                 ):SizedBox(),
//               ],
//             );
//           }) : Center(
//         child: CircularProgressIndicator()
//       ),
//     ),);
  }

  void _tapSign() {
    Dev.log('message');
  }

  List _myActivities = [];
  List<String> _colors = <String>['', 'Văn bản 1', 'Văn bản 2', 'Văn bản 3', 'Văn bản 4'];
  String _color = '';

  void onPressButton(context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {

          return _getBodyPage(context, index);
        });
  }

  String ActionXL = "GetDonViLienThong";
  String ActionXL1 = "GetVBDiByID";
  List<ListData> vanbanList = [];
  List vanban = [];
  List<ListData> lstDataSearch = List<ListData>();

  GetDataNguoiPhoiHop(String tendangnhap) async {
    String detailVBDT = await getDataCVBDi(tendangnhap, ActionXL,widget.nam);
    if (mounted) {
      setState(() {
      vanban = json.decode(detailVBDT)['OData'].cast<Map<String, dynamic>>();
      //vanban = json.decode(detailVBDT)['OData'];
      var lstData = (vanban).map((e) => ListData.fromJson(e)).toList();
      List<ListData> lstDataSearch = List<ListData>();
      lstData.forEach((element) {
        lstDataSearch.add(element);
        vanbanList = lstDataSearch;
      });
    });}

  }

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
  DateTime _dateTime;
  DateTime selectedDate = DateTime.now();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  double _height;
  double _width;
  String _setDate;
  bool _isSuccess = false;
  List<String> _ten = [];
  var chitiet = null;
  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: _dateTime ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;
    if (mounted) {setState(() => _dateTime = newDate);}

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
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });}

  }
  //lấy danh sách chi tiết văn bản dự thảo
  GetDataDetailVBDi( int idDuThao) async {
    String detailVBDi =  await getDataDetailVBDi( idDuThao,
      ActionXL1,widget.MaDonVi);
    if (mounted) { setState(() {
      var data =  json.decode(detailVBDi)['OData'];
      chitiet = VanBanDiJson.fromJson(data);
    });}

  }

  Widget _getBodyPage(context, int index) {

    VanBanDiJson vbdi = chitiet;
    String  DonViGui = "";
    String  LoaiVanBan = "";
    String  SoKyHieu = "";
    String  TrichYeu = "";
    String  NguoiKy = "";
    String  NgayKy = "";
    String  NgayBanHanh = "";
    if(vbdi != null){
      DonViGui =vbdi.DonViGui;
      LoaiVanBan =vbdi.LoaiVanBan;
      SoKyHieu =vbdi.SoKyHieu;
      TrichYeu =vbdi.TrichYeu;
      NguoiKy =vbdi.NguoiKy;
      NgayBanHanh =vbdi.NgayBanHanh;
      NgayKy =vbdi.NgayKy;
    }

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    bool multipleSelection;

    switch (index) {
      case 0:
       /* return Scaffold(

            appBar: AppBar(
                title: Text(
            'Chuyển văn bản',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,),
                automaticallyImplyLeading: false,
                centerTitle: true,
                backgroundColor: Colors.lightBlue),
          body: SingleChildScrollView(

          child: Column(

            children: [

              Container(

                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(
                                'Đơn vị gửi',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              // padding: EdgeInsets.only(left: 22.0),
                              padding: EdgeInsets.fromLTRB(15, 15, 0, 10),
                              child: Text(
                                DonViGui,
                                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 0,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(
                                'Tiêu đề(*)',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                                //height: MediaQuery.of(context).size.height * 0.06,
                                // padding: EdgeInsets.only(left: 22.0),
                                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                   // minWidth: MediaQuery.of(context).size.width,
                                    ),
                                  child:new TextField(
                                    controller: TextEditingController(text:  '[VBDH]'+"["+ LoaiVanBan +"]" +"["+ SoKyHieu
                                        +"]"+"["+ TrichYeu +"]"),
                                    decoration: new InputDecoration(
                                      border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.black12)),
                                    ),
                                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                                    textAlign: TextAlign.justify,
                                    minLines: 1,
                                    maxLines: 5,
                                    onChanged: (text) {
                                      if(mounted){
                                        setState(() {});
                                      }

                                    },
                                  ),),
                                )
                          ],
                        ),
                        Divider(
                          height: 0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(
                                'Đơn vị nhận(*)',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              ///height: MediaQuery.of(context).size.height * 0.07,
                              padding: EdgeInsets.only(left: 15.0),
                              child: SearchServer(
                                listData: vanbanList,
                                multipleSelection: true,
                               // text: Text("Hya"),
                                title:"Hãy chọn đơn vị",
                               // searchHintText: 'Tìm kiếm',
                                onSaved: (value) {
                                  if (mounted) {setState(() {
                                    for(var item in value){
                                      if(idLoaiVBN != null){
                                        idLoaiVBN += (item.toString()) +"," ;
                                      }



                                    }

                                    if(idLoaiVBN != null && idLoaiVBN.length>0)
                                      idLoaiVBN =  idLoaiVBN.substring(0,idLoaiVBN.length-1);


                                  });}

                                },

                              ),

                            ),
                          ],
                        ),
                        Divider(
                          height: 0,
                        ),
                        Padding(padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Nội dung văn bản',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        Column

                          (
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:  <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Text('Loại văn bản',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.7,
                                  // padding: EdgeInsets.only(left: 22.0),
                                  padding: EdgeInsets.fromLTRB(15, 15, 0, 10),
                                  child: Text(LoaiVanBan,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ],
                            ),
                            Divider(height: 0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Text('Số ký hiệu',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight:  FontWeight.bold
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.7,
                                  padding: EdgeInsets.fromLTRB(15, 15, 0, 10),
                                  child: Text(SoKyHieu,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ],
                            ),
                            Divider(height: 0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(left: 20.0),
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  child: Text('Trích yếu',
                                    style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.7,
                                  padding: EdgeInsets.fromLTRB(15, 15, 0, 10),
                                  child: Text(TrichYeu,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ],
                            ),
                            Divider(height: 0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(left: 20.0),
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  child: Text('Người ký',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.7,
                                  padding: EdgeInsets.fromLTRB(15, 15, 0, 10),
                                  child: Text(NguoiKy,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ],
                            ),
                            Divider(height: 0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Text('Ngày ký',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight:  FontWeight.bold
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.7,
                                  padding: EdgeInsets.fromLTRB(15, 15, 0, 10),
                                  child: Text(NgayKy,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ],
                            ),
                            Divider(height: 0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Text('Ngày ban hành',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.7,
                                  padding: EdgeInsets.fromLTRB(15, 15, 0, 10),
                                  child: Text(NgayBanHanh,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ],
                            ),
                            Divider(height: 0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Text('File đính kèm',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 20),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black38 ,

                                    ),
                                    borderRadius: BorderRadius.circular(5),


                                  ),
                                  height:MediaQuery.of(context).size.height * 0.06,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.64,
                                  padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                                  child:DropdownButton(
                                    items: dataCheDoSD.map((item) {
                                      return new DropdownMenuItem(
                                        child:Text(item['Title'] ),

                                        value: item['ID'].toString(),
                                      );
                                    }).toList(),
                                    onChanged: (newVal) {
                                      setState(() {
                                        idCDSD = newVal;
                                        print("idCDSC "  +idCDSD);
                                      });
                                    },
                                    hint:Text("Chọn") ,isExpanded: true,
                                    underline:Container(),
                                    style: const TextStyle(color: Colors.black,
                                        fontWeight: FontWeight.normal,fontSize: 14),
                                    value: idCDSD,
                                  ),
                                ),
                              ],
                            ),
                            Divider(height: 0,),


                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(padding: EdgeInsets.only(top: 10,bottom: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.lightBlue[50], width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.6,
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.06,
                                child:TextButton.icon (
                                    icon: Icon(Icons.send_outlined),
                                    label: Text("Chuyển liên thông",style: TextStyle(fontWeight: FontWeight.bold,
                                      fontSize:
                                      16,),
                                      textAlign:
                                      TextAlign.center,),
                                    onPressed: () async {
                                      var ida="";
                                      ida = vanbanList[0].ID.toString();
                                      var tendangnhap = sharedStorage.getString("username");
                                      EasyLoading.show();
                                      var thanhcong =   await posChuyenLienThong(tendangnhap, widget.id, 'ChuyenLienThong',
                                          idLoaiVBN,widget.nam);
                                      _titleController.text = "";
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
                            Padding(padding: EdgeInsets.only(top: 10,left: 20,
                                bottom: 10),
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

                      ])),
            ],
          ),

        ),
        );*/
        return DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(50.0),
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    bottom: TabBar(
                      tabs: [
                        Tab(
                          text: 'Chuyển liên thông',
                        ),
                        Tab(
                          text: 'PDF',
                        ),
                      ],
                    ),
                  ),
                ),
                body: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Column(

                        children: [

                          Container(

                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.3,
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            'Đơn vị gửi',
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.7,
                                          // padding: EdgeInsets.only(left: 22.0),
                                          padding: EdgeInsets.fromLTRB(15, 15, 0, 10),
                                          child: Text(
                                            DonViGui,
                                            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      height: 0,
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.3,
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            'Tiêu đề(*)',
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.7,
                                          //height: MediaQuery.of(context).size.height * 0.06,
                                          // padding: EdgeInsets.only(left: 22.0),
                                          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              // minWidth: MediaQuery.of(context).size.width,
                                            ),
                                            child:new TextField(
                                              controller: TextEditingController(text:  '[VBDH]'+"["+ LoaiVanBan +"]" +"["+ SoKyHieu
                                                  +"]"+"["+ TrichYeu +"]"),
                                              decoration: new InputDecoration(
                                                border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.black12)),
                                              ),
                                              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                                              textAlign: TextAlign.justify,
                                              minLines: 1,
                                              maxLines: 5,
                                              onChanged: (text) {
                                                if(mounted){
                                                  setState(() {});
                                                }

                                              },
                                            ),),
                                        )
                                      ],
                                    ),
                                    Divider(
                                      height: 0,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.3,
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            'Đơn vị nhận(*)',
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.7,
                                          ///height: MediaQuery.of(context).size.height * 0.07,
                                          padding: EdgeInsets.only(left: 15.0),
                                          child: SearchServer(
                                            listData: vanbanList,
                                            multipleSelection: true,
                                            // text: Text("Hya"),
                                            title:"Hãy chọn đơn vị",
                                            // searchHintText: 'Tìm kiếm',
                                            onSaved: (value) {
                                              if (mounted) {setState(() {
                                                for(var item in value){
                                                  if(idLoaiVBN != null){
                                                    idLoaiVBN += (item.toString()) +"," ;
                                                  }
                                                }
                                                if(idLoaiVBN != null && idLoaiVBN.length>0)
                                                  idLoaiVBN =  idLoaiVBN.substring(0,idLoaiVBN.length-1);
                                              });}
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      height: 0,
                                    ),
                                    Padding(padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        'Nội dung văn bản',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                    ),
                                    Column

                                      (
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children:  <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.3,
                                              padding: EdgeInsets.only(left: 20.0),
                                              child: Text('Loại văn bản',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.7,
                                              // padding: EdgeInsets.only(left: 22.0),
                                              padding: EdgeInsets.fromLTRB(15, 15, 0, 10),
                                              child: Text(LoaiVanBan,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 14
                                                ),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(height: 0,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.3,
                                              padding: EdgeInsets.only(left: 20.0),
                                              child: Text('Số ký hiệu',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:  FontWeight.bold
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.7,
                                              padding: EdgeInsets.fromLTRB(15, 15, 0, 10),
                                              child: Text(SoKyHieu,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 14
                                                ),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(height: 0,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.only(left: 20.0),
                                              width: MediaQuery.of(context).size.width * 0.3,
                                              child: Text('Trích yếu',
                                                style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.7,
                                              padding: EdgeInsets.fromLTRB(15, 15, 0, 10),
                                              child: Text(TrichYeu,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.normal
                                                ),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(height: 0,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.only(left: 20.0),
                                              width: MediaQuery.of(context).size.width * 0.3,
                                              child: Text('Người ký',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.7,
                                              padding: EdgeInsets.fromLTRB(15, 15, 0, 10),
                                              child: Text(NguoiKy,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 14
                                                ),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(height: 0,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.3,
                                              padding: EdgeInsets.only(left: 20.0),
                                              child: Text('Ngày ký',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:  FontWeight.bold
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.7,
                                              padding: EdgeInsets.fromLTRB(15, 15, 0, 10),
                                              child: Text(NgayKy,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 14
                                                ),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(height: 0,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.3,
                                              padding: EdgeInsets.only(left: 20.0),
                                              child: Text('Ngày ban hành',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.7,
                                              padding: EdgeInsets.fromLTRB(15, 15, 0, 10),
                                              child: Text(NgayBanHanh,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 14
                                                ),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(height: 0,),
                                     


                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(padding: EdgeInsets.only(top: 10,bottom: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.lightBlue[50], width: 2),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.6,
                                            height: MediaQuery
                                                .of(context)
                                                .size
                                                .height * 0.06,
                                            child:TextButton.icon (
                                                icon: Icon(Icons.send_outlined),
                                                label: Text("Chuyển liên thông",style: TextStyle(fontWeight: FontWeight.bold,
                                                  fontSize:
                                                  16,),
                                                  textAlign:
                                                  TextAlign.center,),
                                                onPressed: () async {
                                                  var ida="";
                                                  ida = vanbanList[0].ID.toString();
                                                  var tendangnhap = sharedStorage.getString("username");
                                                  EasyLoading.show();
                                                  var thanhcong =   await posChuyenLienThong(tendangnhap, widget.id, 'ChuyenLienThong',
                                                      idLoaiVBN,widget.nam);
                                                  _titleController.text = "";
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
                                        Padding(padding: EdgeInsets.only(top: 10,left: 20,
                                            bottom: 10),
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

                                  ])),
                        ],
                      ),
                    ),

                    ViewPDFLT(),
                    
                  ],
                )));
        break;
      case 1:
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
                        hintText: 'Nhập ý kiến/bút phê',
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
                            .width * 0.5,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.06,
                        child:TextButton.icon (
                            icon: Icon(Icons.send),
                            label: Text("Ý kiến/Bút phê",style: TextStyle
                              (fontWeight: FontWeight.bold, fontSize: 14,),
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
                              else
                              {
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(top: 10),
                                  child: CircularProgressIndicator(
                                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                                  ),
                                );
                                EasyLoading.show();
                                var thanhcong=  await postYKienVBDi
                                  (tendangnhap, id, "ADDButPhe",
                                    _titleController.text,widget.nam);
                                EasyLoading.dismiss();
                                Navigator.of(context).pop();
                                _titleController.text = "";
                                showAlertDialog(context, json.decode(thanhcong)['Message']);



                                //  Navigator.pop(context);
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
                                icon: Icon(Icons.send),
                                label: Text("Thu hồi",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
                                  textAlign:
                                  TextAlign.center,),
                                onPressed: ()async   {

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
                ),
              )),
        );
        break;
      case 3:
        return Scaffold(

                body:
                SingleChildScrollView(
                  child:
                      TreeFromJson(),


                ),
                floatingActionButton:FloatingActionButton(
              onPressed: () async {
                var tendangnhap = sharedStorage.getString("username");
               String userList = lstvbdiNoiNhan;
                EasyLoading.show();
                var thanhcong = await postChuyenVBDiNgoai(tendangnhap, widget
                    .id,
                    "SendVBDi", userList,currentUserID,widget.nam);
                Navigator.of(context).pop();
                userList = "";
                currentUserID = 0;
                EasyLoading.dismiss();
              showAlertDialog(context, json.decode(thanhcong)['Message']);
        },
          child: Icon(Icons.assistant_direction),
          backgroundColor: Colors.blueAccent,
        ),


              );
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
                        hintText: 'Nhập ý kiến trả về',
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
                            icon: Icon(Icons.send_and_archive),
                            label: Text("Trả về",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),textAlign:
                            TextAlign.center,),
                            onPressed: () async {


                              bool isAllSpaces(String input) {
                                String output = input.replaceAll(' ', '');
                                if(output == '') {
                                  return true;
                                }
                                return false;
                              }

                              String iaa =  _titleController.text.trim();
                              if(isAllSpaces(iaa))
                              {showAlertDialog(context,"Nhập ý kiến trả về");
                              }
                              else
                              {
                                var tendangnhap = sharedStorage.getString("username");
                                EasyLoading.show();
                                var thanhcong =   await posTraVeVBDi(tendangnhap, widget.id, 'TraVe', _titleController
                                    .text);
                                _titleController.text = "";

                                EasyLoading.dismiss();
                                Navigator.of(context).pop();
                                showAlertDialog(context, json.decode(thanhcong)['Message']);

                                Navigator.of(context).pop();
                                _titleController.text = "";

                                //  Navigator.pop(context);
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
      case 6 :
        return Scaffold(
          body:
          SingleChildScrollView(
            child:ChuyenNBVBDi(id: widget.id,nam:widget.nam),




          ),
        );
      case 7:
        return Scaffold(
          body:
          SingleChildScrollView(
            child:thietLapHBVBDi(id:widget.id,nam:widget.nam),

          ),
        );
        break;

      default:
        {
          return Container(
              height: MediaQuery.of(context).size.height * .60,
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Danh sách người xử lý chính'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SearchServer(
                    listData: vanbanList,
                    multipleSelection: false,
                    title: 'Chọn xlc',
                    searchHintText: 'Tìm kiếm',
                    onSaved: (value) {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Danh sách người phối hợp'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SearchServer(
                    listData: vanbanList,
                    multipleSelection: true,
                    title: 'Chọn người phối hợp',
                    searchHintText: 'Tìm kiếm',
                    onSaved: (value) {},
                  ),
                ),
              ]));
        }
    }
  }



}