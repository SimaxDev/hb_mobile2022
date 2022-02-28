import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'package:hb_mobile2021/ui/vbduthao/themMoiHS/ThemPT.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'ThemDT.dart';


class ThemMoiDT extends StatefulWidget {
    ThemMoiDT({Key key}) : super(key: key);

  @override
  _ThemMoiDTState createState() => _ThemMoiDTState();
}

class _ThemMoiDTState extends State<ThemMoiDT> {
  bool isLoading = false;
  Timer _timer;


  void _initializeTimer() {
    _timer = Timer.periodic(const Duration(minutes:5), (_) {
      logOut(context);
      _timer.cancel();
    });

  }
  @override
  void dispose(){
    super.dispose();
    _timer.cancel();
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
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleUserInteraction,
      onPanDown: _handleUserInteraction,
      onScaleStart: _handleUserInteraction,
      child:DefaultTabController(length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: 'Dự thảo',
                ),
                Tab(
                  text: 'Phiếu trình',
                ),

              ],
            ),
            title: Text('Thêm mới dự thảo'),
          ),
          body: !isLoading
              ? TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
            ThemDT(),
              ThemPT(),
            ],
          )
              : Center(
            child: CircularProgressIndicator(),
          ),
        ),
    ),);
  }
}
