import 'dart:convert';

import 'package:flutter/cupertino.dart';

List<Dashboard> dashboardFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<Dashboard>.from(jsonData.map((x) => Dashboard.fromJson(x)));
}

String dashboardToJson(List<Dashboard> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

class Dashboard{
  int id;
  String name;
  int? total;
  String? url;

  Dashboard({
    required this.id,
    required this.name,
    this.total,
    this.url
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) => new Dashboard(
    id: json['id'],
    name: json['name'],
    total: json['total'],
    url: json['url'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'total': total,
    'url': url,
  };

   @override
  String toString() {
    return "Dashboard(url: $url, name: $name)";
  }

}
