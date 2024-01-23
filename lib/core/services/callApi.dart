import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

//const String DOMAIN = "http://apimobile2021.ungdungtructuyen.vn";//33


const String DOMAIN = "https://apimobile.hoabinh.gov.vn";

     //tesst

SharedPreferences? sharedStorage;


Future responseDataPost(String path,String formdata) async {
  var url = Uri.parse(DOMAIN + path);
  var response;
  sharedStorage = await SharedPreferences.getInstance();
  if( sharedStorage == null){
    return CircularProgressIndicator();
  }
  else{
  String? token = sharedStorage!.getString("token");
   // response = await post(Uri.parse(url),
   //    headers: {
   //    "Accept": "application/json",
   //    "Content-Type": "application/x-www-form-urlencoded",
   //   'Authorization': 'Bearer ' + token
   //    },
   //   body: formdata
   // );
  response = await http.post(
    url,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer ' + token!
    },
    body: formdata,
  );

  return response;}
}
responseDataPost1(String path, final formdata) async {
  var url = Uri.parse(DOMAIN + path);
  var response =  null ;
  sharedStorage = await SharedPreferences.getInstance();
  if( sharedStorage == null){
    return CircularProgressIndicator();
  }
  else{
  String? token = sharedStorage!.getString("token");
  response = await http.post(
    url,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer ' + token!
    },
    body: json.encode(formdata),
  );

  return response;}
}
Future<http.Response> responseDataPost2(String path, var formdata) async {
   var url = Uri.parse(DOMAIN + path);
    String? token = sharedStorage!.getString("token");
  return await http.post(
   url,
      body: json.encode(formdata),
      headers: { 'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": 'Bearer ' + token!,}
    );

}
//lay chi tiet vbden
responseDataPostVBDen(String path,String formdata) async {
   var url = Uri.parse(DOMAIN + path);
  sharedStorage = await SharedPreferences.getInstance();
  String? token = sharedStorage!.getString("token");
  var response = await http.post(
    url,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer ' + token!
    },
    body: formdata,
  );
  return response;
}


responseData(String path) async {
   var url = Uri.parse(DOMAIN + path);
  sharedStorage = await SharedPreferences.getInstance();
  String? token = sharedStorage!.getString("token");
  var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer ' + token!
      }
  );
  return response;
}
// get home văn bản đến
responseDataHOmeVBDen(String path, String formdata) async {
   var url = Uri.parse(DOMAIN + path);
  sharedStorage = await SharedPreferences.getInstance();
  String? token = sharedStorage!.getString("token");
  var response = await http.post(
    url,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer ' + token!
    },
    body: formdata,
  );
  return response;
}
responseMK(String path, String formdata) async {
   var url = Uri.parse(DOMAIN + path);
  var response = await http.post(
    url,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: formdata,
  );
  return response;
}
responseDataVBDen(String path, String formdata) async {
   var url = Uri.parse(DOMAIN + path);
  sharedStorage = await SharedPreferences.getInstance();
  String? token = sharedStorage!.getString("token");
  var response = await http.post(
    url,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer ' + token!
    },
    body: formdata,
  );
  return response;
}

//getusser apimoi
responseUser(String path) async {
   var url = Uri.parse(DOMAIN + path);
  var response = await http.get(url);
  return response;
}
responsePostData(String path, String formdata) async {
   var url = Uri.parse(DOMAIN + path);
  sharedStorage = await SharedPreferences.getInstance();
  String? token = sharedStorage!.getString("token");
  var response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer ' + token!
      },
      body: formdata

  );
  return response;
}