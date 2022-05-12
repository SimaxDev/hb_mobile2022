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
  String nam;
  ThemMoiDT({Key key,this.nam}) : super(key: key);

  @override
  _ThemMoiDTState createState() => _ThemMoiDTState();
}

class _ThemMoiDTState extends State<ThemMoiDT> {
  bool isLoading = false;


  @override
  void dipose(){

    super.dispose();
  }


  @override
  void initState() {

   // _initializeTimer();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,
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
            ThemDT( nam: widget.nam,),
            ThemPT(),
          ],
        )
            : Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
