

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hb_mobile2021/ui/Login/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/services/callApi.dart';

class rester{

  Timer _timer;


  void initializeTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      logOutALL();
      _timer.cancel();
    });

  }


  void logOutALL() async {
    sharedStorage = await SharedPreferences.getInstance();
    if(!sharedStorage.getBool("rememberme")) {
      sharedStorage.remove("password");
    }
    else{
      sharedStorage.remove("expires_in");
      sharedStorage.remove("token");
    }
    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
    //     builder: (BuildContext context) => LoginWidget()), (Route<dynamic> route) => false);
    Get.off(LoginWidget());

  }
}
