

import 'dart:convert';

import 'package:get/get.dart';

class DataController extends GetxController {
  // List listDataNangCao = [].obs;
  var isLoading = true.obs;
  var ID = "0".obs;
  List HoSoList = [].obs;
  RxBool isEnabled = false.obs;
  RxList lstChiTietDt = [].obs;


  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  @override
  void dispose(){
    super.dispose();
    isLoading;
    ID;
   HoSoList;
   isEnabled;

  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void change() {
    HoSoList.obs;
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      //var products = await GiapDapApi.getDataGiaiDap();
      //var products = await hoSoCVService.GetDataLV(ID);
      // if (products != null) {
      //   //listDataNangCao = products;
      // }
    } finally {
      isLoading(false);
    }
  }



}

