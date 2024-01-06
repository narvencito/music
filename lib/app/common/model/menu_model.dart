// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

class MenuModel {
  MenuModel({
    required this.name,
    required this.icon,
    required this.route,
  });

  factory MenuModel.fromMap(Map<String, dynamic> map) {
    return MenuModel(
      name: map['name'].toString(),
      icon: map['icon'].toString(),
      route: map['route'].toString(),
    );
  }

  factory MenuModel.fromJson(String source) => MenuModel.fromMap(json.decode(source) as Map<String, dynamic>);
  String name;
  String icon;
  String route;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': icon,
      'route': route,
    };
  }

  String toJson() => json.encode(toMap());
}
