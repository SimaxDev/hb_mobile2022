import 'dart:async';
import 'package:flutter/scheduler.dart';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:hb_mobile2021/core/services/MenuLeftService.dart';
import 'package:hb_mobile2021/ui/main/btnavigator_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MenuLeft extends StatefulWidget {
  int page;
  final String year;
  final String username;
   final String  queryLeft;
   final int queryID;


  MenuLeft({required this.page,required this.username, required this.year,required this.queryLeft, required this.queryID});
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
  late int indexVB ;
  String urlttVB = '';
  var tendangnhap = "";
   bool checker = false;
   int? tappedIndex;
  String nam =  "";
  late SharedPreferences sharedStorage;
  late SharedPreferences viTriHienTai;




  @override
  void initState() {
    // TODO: implement initState
    //  if(getString("username"))
    //_initializeTimer();
    this.getMenu();
    isLoading = true;
    tappedIndex = 0;
    if (mounted) {setState(() {


      nam =  widget.year;
    });}

    super.initState();
    // _scrollController.animateTo(
    //   0.0,
    //   curve: Curves.easeOut,
    //   duration: const Duration(milliseconds: 500),
    // );
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      _scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 500),
      );
    });
  }

  @override
  void dispose(){

    _scrollController.dispose();
    super.dispose();
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
    return  MenuLeftData();
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
            BottomNavigator(page: widget.page,username: widget.username,index: 0,
                query : query,year: widget.year,ID :ID )), (Route<dynamic>
        route)
        => false);

        //Navigator.pop(context);
      },
    ));
  }

}