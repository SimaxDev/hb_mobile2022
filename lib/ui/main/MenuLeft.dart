import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:hb_mobile2021/core/services/MenuLeftService.dart';
import 'package:hb_mobile2021/core/services/VbdenService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/ui/main/btnavigator_widget.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'package:hb_mobile2021/ui/vbden/vbden.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MenuLeft extends StatefulWidget {
  int page;
  final String year;
  final String username;
   final String  queryLeft;
   final int queryID;


  MenuLeft({this.page,this.username, this.year,this.queryLeft, this.queryID});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Menuleft();
  }

}

class _Menuleft extends State<MenuLeft>  {
  ScrollController _scrollController = new ScrollController();
  List menuleft = [];
  List data = [];
  bool isLoading = false;
  int _currentIndex =1;
  int indexVB ;
  String urlttVB = '';
  var tendangnhap = "";
   bool checker = false;
  int tappedIndex;
  String nam =  "";
  SharedPreferences sharedStorage;
  SharedPreferences viTriHienTai;

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
    // TODO: implement initState
    //  if(getString("username"))
    _initializeTimer();
    this.getMenu();
    isLoading = true;
    //tappedIndex = 0;
    if (mounted) {setState(() {


      nam =  widget.year;
    });}

    super.initState();
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 500),
    );

  }

  @override
  void dispose(){
    super.dispose();
    _timer.cancel();
  }
  getMenu() async {

    isLoading = true;
    String item = await GetMenuLeft(widget.page,widget.year);
    if (mounted) {setState(() {
      isLoading = false;
      menuleft = json.decode(item);
      for( int i= 0 ; i< menuleft.length; i++)
      {

        if(menuleft[i]['ID'] == widget.queryID)
          tappedIndex = i;
      }

    });}

  }

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: _handleUserInteraction,
      onPanDown: _handleUserInteraction,
      onScaleStart: _handleUserInteraction,
      child:MenuLeftData(),);
  }

  Widget MenuLeftData() {

    if (menuleft== null|| menuleft.length < 0 || isLoading) {
      //isLoading = !isLoading;
      return Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ));
    } else if (menuleft.length == 0) {
      return Center(
        child: Text("Không có bản ghi"),
      );}
      return ListView.builder(controller: _scrollController,
        itemCount: menuleft == null ? 0 :menuleft.length,
        itemBuilder: (context, index) {
            return
            Container(
             // height: MediaQuery.of(context).size.height,
                  //margin: EdgeInsets.only(bottom: 10),
                  color: tappedIndex == index  ? Colors.blue : Colors.white,
                  child:GetBodyMenuLeft(menuleft[index]))

             ;
        }
      );

  }

  Widget GetBodyMenuLeft(item) {
    var title = item['Title'];
    var query=  item['query'];
    var ID=  item['ID'];

    return Card(child:ListTile(

      title:Text(
        title,
        maxLines: 1,
        style: TextStyle(fontWeight: FontWeight.normal,
        ),
      ),

      //trailing: Icon(Icons.arrow_right),
      onTap: () {
        checker = true;
        if (mounted) {setState(()   {
          //print(menuleft) ;
          for( int i= 0 ; i< menuleft.length; i++)
          {
            IDTT =  ID;
            if(menuleft[i]['ID'] == ID)
              tappedIndex = i;
          }


        });}

        //  GetDetailMenuLeft(widget.page,query, widget.year);
        if(widget.page ==1 ) {
          indexVB=0;
        }
        if(widget.page ==2 ) {
          indexVB=1;
        }
        if(widget.page ==3 ) {
          indexVB=2;
        }
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            BottomNavigator(page: widget.page,
                query : query,year: widget.year,ID :ID )), (Route<dynamic>
        route)
        => false);

        //Navigator.pop(context);
      },
    ));
  }

}