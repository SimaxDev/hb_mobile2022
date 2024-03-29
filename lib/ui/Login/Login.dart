import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:get/get.dart';
import 'package:hb_mobile2021/core/models/UserJson.dart';
import 'package:hb_mobile2021/core/services/UserService.dart';

import 'package:hb_mobile2021/ui/Login/singUp.dart';

import 'package:hb_mobile2021/ui/main/btnavigator_widget.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'package:http/http.dart' as http;
import 'package:new_version/new_version.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';
import 'package:local_auth/local_auth.dart';

class LoginWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginWidget> {
  late SharedPreferences sharedStorage;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;
  bool rememberMeTK = false;
  bool isLoading = false;
  bool _showPass = true;
  List lstThongTinLConfig = [];
  var user;
  final localAuth = LocalAuthentication();
  void isload(){
    setState(() {
      isLoading = false ;
    });
  }


  Future<void> _authenticate() async {
    bool canCheckBiometrics = await localAuth.canCheckBiometrics;
    if (canCheckBiometrics) {
      bool authenticated = await localAuth.authenticate(
        localizedReason: 'Xác thực bằng vân tay để truy cập vào ứng dụng',
        options: const AuthenticationOptions(useErrorDialogs: true, stickyAuth: true,)
      );
      if (authenticated) {

        usernameController.text = "huongvt.ubnd";
        passwordController.text = "123456a@";
        rememberMe= true;
        login(usernameController.text, passwordController.text);

      } else {
        isload();
      print("Xác thực không thành công!");
      }
    }
  }




  @override
  void initState() {
    super.initState();

    // String username = sharedStorage.getString("usernames");
    // usernameController.text = username;
    rememberAccount();
  //  _checkVersion();

  }



  void _checkVersion() async {
    final newVersion = NewVersion(
      androidId: "com.hoabinh.gov.hb_mobile2021",
        iOSId:"com.hoabinh.jsc.gov.vn"
    );
    final status = await newVersion.getVersionStatus();

    if (status!.localVersion != status.storeVersion) {
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: "CẬP NHẬT!!!",
        dismissButtonText: "Bỏ qua",
        dialogText: "Vui lòng cập nhật ứng dụng từ " +
            "${status.localVersion}" +
            " lên " +
            "${status.storeVersion}",
        dismissAction: () {
          SystemNavigator.pop();
        },
        updateButtonText: "Cập nhật",
      );
    }

    print("DEVICE : " + status.localVersion);
    print("STORE : " + status.storeVersion);
  }

  rememberAccount() async {
    sharedStorage = await SharedPreferences.getInstance();
    if (sharedStorage.containsKey("username")) {
      String? username = sharedStorage.getString("username");
      String? passname = sharedStorage.getString("password");
      bool? rememberAccount = sharedStorage.getBool("rememberme");
      usernameController.text = username!;
      if (rememberAccount == true) {
        passwordController.text = passname!;
      }

      if (mounted) {
        setState(() {
          rememberMe = rememberAccount!;
        });
      }
    }
  }

  GetInfoUser(String TenDangNhap) async {
    sharedStorage = await SharedPreferences.getInstance();
    var item = await GetInfoUserService(TenDangNhap);
    if (sharedStorage != null) {
      setState(() {
        isLoading = false;




        FirebaseMessaging.instance.subscribeToTopic("truyenthong_all");
if(item == null){
  {
    showAlertDialog(context, "Tài khoản hoặc mật khẩu không đúng");
    setState(() {
      isLoading = false;});
  }
}

        tenPhongBan =
        item['CurrentTenPhongBan'] != null ? item['CurrentTenPhongBan'] : "";
        CurrentTenDonVi =
        item['CurrentTenDonVi'] != null ? item['CurrentTenDonVi'] : "";
        OrganName = item['OrganName'] != null ? item['OrganName'] : "";
        notIsQuanTriNew =
        item['notIsQuanTriNew'] != null ? item['notIsQuanTriNew'] : false;
        isQTNew = item['isQTNew'] != null ? item['isQTNew'] : false;
        lstThongTinGroup =
        item['lstThongTinGroup'] != null ? item['lstThongTinGroup'] : [];
        EmailHT = item['userEmail'] != null ? item['userEmail'] : "";
        Telephone =
        item['userDienThoaiDD'] != null ? item['userDienThoaiDD'] : "";
        userGroups = item['userGroups'] != null ? item['userGroups'] : [];
        butPheVBD = item['ListPermissions'] != null &&
            item['ListPermissions']['ButPheVanBan'] != null
            ? item['ListPermissions']['ButPheVanBan']
            : false;
        groupID = item['groupID'] != null ? item['groupID'] : 0;
        lstPhongBanLaVanThuVBDI = item['lstPhongBanLaVanThuVBDI'].length> 0
            ?item['lstPhongBanLaVanThuVBDI']:[] ;
        lstPhongBanLaVanThuVBDEN = item['lstPhongBanLaVanThuVBDEN'].length >
            0 ? item['lstPhongBanLaVanThuVBDEN']: [];
        SiteAction = item['SiteAction'] != null ? item['SiteAction'] : "";

        if (item['ListPermissions'] != null &&
            item['ListPermissions'].length > 0) {
          ThemMoiVanBanDi = item['ListPermissions']['ThemMoiVanBanDi'] != null
              ? item['ListPermissions']['ThemMoiVanBanDi']
              : false;
          ThemVanBanDen = item['ListPermissions']['ThemVanBanDen'] != null
              ? item['ListPermissions']['ThemVanBanDen']
              : false;
          ThemMoiVanBanDuThao = item['ListPermissions']['ThemMoiVanBanDuThao'] != null
              ? item['ListPermissions']['ThemMoiVanBanDuThao']
              : false;
          ThietLapHoiBao = item['ListPermissions']['ThietLapHoiBao'] != null
              ? item['ListPermissions']['ThietLapHoiBao']
              : false;
          CapSoVanBanDi = item['ListPermissions']['CapSoVanBanDi'] != null
              ? item['ListPermissions']['CapSoVanBanDi']
              : false;
          hanXLVBD = item['ListPermissions']['GuiVanBanD'] != null
              ? item['ListPermissions']['GuiVanBanD']
              : false;
          GuiVanBanDi = item['ListPermissions']['GuiVanBanDi'] != null
              ? item['ListPermissions']['GuiVanBanDi']
              : false;
          SuaVanBanDen = item['ListPermissions']['SuaVanBanDen'] != null
              ? item['ListPermissions']['SuaVanBanDen']
              : false;
          GuiVanBan = item['ListPermissions']['GuiVanBan'] != null
              ? item['ListPermissions']['GuiVanBan']
              : false;
          imageCK =item['ListFileAttach'].length >0 &&item['ListFileAttach']!=
              null  &&
              item['ListFileAttach'][0]['Url'] != null
              ? item['ListFileAttach'][0]['Url']
              : "";
          widthKy =item['SignatureWidth']!= null
              ? item['SignatureWidth'].toDouble()
              : 150.0;
          heightKy =item['SignatureHeight']!= null
              ? item['SignatureHeight'].toDouble()
              : 75.0;
        }

        userTenTruyCap =
        item['userTenTruyCap'] != null ? item['userTenTruyCap'] : "";
        CurrentDonViID =
        item['CurrentDonVi'] == null ? 0 : item['CurrentDonVi']['LookupId'];
        ThongTinLConfig =
        item['lstThongTinLConfig'] != null ? item['lstThongTinLConfig'] : [];
        DonViInSiteID =
        item['DonViInSite'] == null ? 0 : item['DonViInSite']['LookupId'];

        ID = item['ID'];
        currentUserID = ID;
        userHasQuyenKyVB = item['lstPBHasVanBan'];

        lstThongTinLConfig = item['lstThongTinLConfig'] != null &&
            item['lstThongTinLConfig'].length > 0
            ? item['lstThongTinLConfig']
            : [];
        for (var i in lstThongTinLConfig) {
          if (i['configType'] == "pGuiXuLyChinh") {
            ispGuiXuLyChinh = true;
          }
        }

        userChucVu = item['userChucVu'].length > 0 &&
            item['userChucVu'][0]['LookupValue'] != null
            ? item['userChucVu'][0]['LookupValue']
            : "";
        user = UserJson.fromJson(item);

        sharedStorage.setString("hoten", user.Title);
        sharedStorage.setString("chucvu", user.ChucVu);


          });
    }
  }

  updateTokenFirebase(String tokenUser) async {
    var url = Uri.parse(
        "http://qlvbapi.moj.gov.vn/test/UpdateTokenFirebase?tokenfirebase=" +
            tokenfirebase!);
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer ' + tokenUser});
    if (response.statusCode == 200) {
      var mess = json.decode(response.body)['Message'];
    }
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => Get.to(singUp()),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Bạn chưa có tài khoản? ',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff021029),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
                // color: Colors.white,
              ),
            ),
            TextSpan(
                text: 'Đăng ký',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 16,
                  color: Color(0xff021029),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                  // color: Colors.white,
                )
                // style: TextStyle(
                //   color: Colors.white,
                //   fontSize: 18.0,
                //   fontWeight: FontWeight.bold,
                // ),
                ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xCCFFFF),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/hb-logo.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Padding(
                padding: EdgeInsets.all(20),
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                      ))
                    : ListView(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            child: Image(
                              image: AssetImage('assets/logo_thb.png'),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "UBND TỈNH HOÀ BÌNH",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: Colors.white,
                                      offset: Offset(5.0, 5.0),
                                    )
                                  ]),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "QUẢN LÝ VĂN BẢN VÀ ĐIỀU HÀNH TÁC NGHIỆP",
                              style: TextStyle(
                                  color: Color(0xFFFDD835),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            child: Column(
                              children: [
                                Container(
                                    padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                                    child: new Theme(
                                      data: new ThemeData(
                                        primaryColor: Colors.black45,
                                      ),
                                      child: new TextField(
                                        controller: usernameController,
                                        cursorColor: Colors.black45,
                                        style: TextStyle(
                                          color: Color(0xff021029),
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,),
                                        decoration: new InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.black45),
                                          ),
                                          border: new OutlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: Colors.black45)),
                                          labelText: 'Tài khoản',
                                          labelStyle: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                          prefixIcon: const Icon(
                                            Icons.person,
                                            color: Colors.black,
                                          ),
                                          prefixText: ' ',
                                        ),
                                      ),
                                    )),
                                Stack(
                                  alignment: AlignmentDirectional.centerEnd,
                                  children: [
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 10, 10, 0),
                                        child: new Theme(
                                          data: new ThemeData(
                                            primaryColor: Colors.black45,
                                          ),
                                          child: new TextField(
                                            obscureText: _showPass,
                                            controller: passwordController,
                                            cursorColor: Colors.black45,
                                            style: TextStyle(
                                                color: Color(0xff021029),
                                                fontSize: 14,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w500),
                                            decoration: new InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.black),
                                              ),
                                              border: new OutlineInputBorder(
                                                  borderSide: new BorderSide(
                                                      color: Colors.white)),
                                              labelText: 'Mật khẩu',
                                              labelStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              prefixIcon: const Icon(
                                                Icons.lock,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        )),
                                    GestureDetector(
                                        onTap: onToggleShowPass,
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 20, 0),
                                          // child: Text(
                                          //   'Show',
                                          //   style: TextStyle(
                                          //     color: Colors.white,
                                          //     fontSize: 13,
                                          //     fontWeight: FontWeight.bold,
                                          //   ),
                                          // ),
                                          child: Image(
                                            height: 30,
                                            image: _showPass
                                                ? AssetImage(
                                                    'assets/logo_eye.png')
                                                : AssetImage(
                                                    'assets/logo_disseye.png'),
                                          ),
                                        ))
                                  ],
                                ),
                                Container(
                                  child: Theme(
                                      data: ThemeData(
                                          unselectedWidgetColor: Colors.black,
                                          backgroundColor: Colors.white),
                                      child: CheckboxListTile(
                                        activeColor: Colors.black12,
                                        title: Text(
                                          "Nhớ tên đăng nhập",
                                          style: TextStyle(fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        value: rememberMe,
                                        checkColor: Colors.black,
                                        onChanged: (newValue) {
                                          if (mounted) {
                                            setState(() {
                                              rememberMe = newValue!;
                                            });
                                          }
                                        },
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                      )),
                                ),
                                Container(
//                   color: Colors.white,
                                  height: 50,
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xff3064D0), // background (button) color// foreground (text) color
                                        shape:  RoundedRectangleBorder(
                                            side:new  BorderSide(color: Colors.blue,), //the outline color
                                            borderRadius: new BorderRadius.all(new Radius.circular(10))),
                                      ),
                                        //the outline color

                                    child: Text('Đăng nhập',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          // color: Colors.white,
                                        )),
                                    onPressed: () async {
                                      if (mounted) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                      }


                                      login(usernameController.text.trim(),
                                          passwordController.text);
                                      rememberMeTK = true;
                                    },
                                  ),
                                ),

                                // IconButton(
                                //   icon: Icon(Icons.fingerprint,
                                //     size: 50,),
                                //   onPressed: () {
                                //     if (mounted) {
                                //       setState(() {
                                //         isLoading = true;
                                //       });
                                //     }
                                //     _authenticate();
                                //   },
                                //
                                //
                                // ),
                                SizedBox(
                                  height: 20,
                                ),
                                _buildSignupBtn(),
                                 SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          )
                        ],
                      )),
          )),
    );
  }


  void onToggleShowPass() {
    if (mounted) {
      setState(() {
        _showPass = !_showPass;
      });
    }
  }

  // void showNotification() {
  //   int _counter = 0;
  //   flutterLocalNotificationsPlugin.show(
  //       0,
  //       "Bạn có một thông báo mới!",
  //       "Đã có một văn bản chuyển đến từ tài khoản huongvt.ubnd! Cho bạn.",
  //       NotificationDetails(
  //           android: AndroidNotificationDetails(channel.id, channel.name, channel.description,
  //               importance: Importance.high,
  //               color: Colors.blue,
  //               playSound: true,
  //             icon: '@mipmap/launcher_icon',)));
  // }
  Future<void> login(String username, String password) async {
    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      var headers = {
        'Content-Type': 'application/x-www-form-urlencoded'
      };
      var request = http.Request('POST', Uri.parse('https://apimobile.hoabinh.gov.vn/token'));
     //var request = http.Request('POST', Uri.parse('http://apimobile2021.ungdungtructuyen.vn/token')); //33
      //var request = http.Request('POST', Uri.parse('http://appmobilehb2024.ungdungtructuyen.vn/token')); //27

      request.bodyFields = {
        'username': username,
        'password': password,
        'grant_type': 'password'
      };
      matKhauHT = password;
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();


    // var url = Uri.parse("http://apiappmobilehoabinh.ungdungtructuyen.vn/token");
  // var url = Uri.parse("https://apimobile.hoabinh.gov.vn/token");
  //     var details = {
  //       'username': username,
  //       'password': password,
  //       'grant_type': 'password'
  //     };
  //     matKhauHT = password;
  //     var parts = [];
  //     details.forEach((key, value) {
  //
  //       parts.add('${Uri.encodeQueryComponent(key)}='
  //           '${Uri.encodeQueryComponent(value)}');
  //     });
  //     // var formData = parts.join('&'); //nối đường dẫnf
  //     var response = await http.post(
  //       url,
  //       headers: {
  //         'Accept': 'application/json',
  //         'Content-Type': 'application/x-www-form-urlencoded',
  //       },
  //       // body: formData,
  //     );

      var getToken, expires_in;
      SharedPreferences sharedToken = await SharedPreferences.getInstance();
      DateTime now = DateTime.now();
      if (response.statusCode == 200) {

        var IN  =  await response.stream.bytesToString();

         getToken = jsonDecode(IN)['access_token'];

        expires_in = jsonDecode(IN)['expires_in'];
        // getToken = json.decode(await response.stream.bytesToString())['access_token'];
        //
        // expires_in = json.decode(await response.stream.bytesToString())['expires_in'];
         sharedToken.setString("token", getToken);
        var expiresOut = now.add(new Duration(seconds: expires_in));

        sharedToken.setBool("rememberme", rememberMe);

        tendangnhapAll = username;

        if (rememberMe) {
          sharedToken.setString("username", username);
          sharedToken.setString("password", password);
        }
        if (rememberMeTK) {
          sharedToken.setString("username", username);
        }
        //FirebaseMessaging.instance.subscribeToTopic("truyenthong_all");
         await GetInfoUser(username);
        sharedToken.setString("expires_in", expiresOut.toString());




        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    BottomNavigator(username: username)),
            (Route<dynamic> route) => false);
        setState(() {
          isLoading = false;
        });
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }

        showAlertDialog(context, "Tài khoản hoặc mật khẩu không đúng");
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

      showAlertDialog(context, "Tài khoản và mật khẩu không được trống");
    }
  }
}
