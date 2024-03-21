// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/src/material/dropdown.dart';

class SecondCategory {
  final String name_second;
  final String id_category;
  final String number_cate;

  var IDcategory_second;

  var IDcategory_first;
  SecondCategory({
    required this.name_second,
    required this.id_category,
    required this.number_cate,
  });

  SecondCategory copyWith({
    String? name_second,
    String? id_category,
    String? number_cate,
  }) {
    return SecondCategory(
      name_second: name_second ?? this.name_second,
      id_category: id_category ?? this.id_category,
      number_cate: number_cate ?? this.number_cate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name_second': name_second,
      'id_category': id_category,
      'number_cate': number_cate,
    };
  }

  factory SecondCategory.fromMap(Map<String, dynamic> map) {
    return SecondCategory(
      name_second: map['name_second'] as String,
      id_category: map['id_category'] as String,
      number_cate: map['number_cate'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SecondCategory.fromJson(String source) => SecondCategory.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SecondCategory(name_second: $name_second, id_category: $id_category, number_cate: $number_cate)';

  @override
  bool operator ==(covariant SecondCategory other) {
    if (identical(this, other)) return true;
  
    return 
      other.name_second == name_second &&
      other.id_category == id_category &&
      other.number_cate == number_cate;
  }

  @override
  int get hashCode => name_second.hashCode ^ id_category.hashCode ^ number_cate.hashCode;

  static map(DropdownMenuItem<String> Function(dynamic data) param0) {}
}
