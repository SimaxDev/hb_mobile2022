class MyData {
  String previous;
  String next;
  List<Results> results;

  MyData.fromJson(Map<String, dynamic> json) {
    // previous = json['previous'];
    // next = json['next'];
    // if (json['results'] != null) {
    //   results = new List<Results>();
    //   json['results'].forEach((v) {
    //     results.add(new Results.fromJson(v));
    //   });
    // }
  }
}

class Results {
  String SKH;
  String trichYeu;
  String ngayBanHanh;
  String ngayKy;
  bool verified;

  Results.fromJson(Map<String, dynamic> json) {
    SKH = json['first_name'];
    ngayBanHanh = json['last_name'];
    trichYeu = json['email'];
    ngayKy = json['phone'];

  }
}
