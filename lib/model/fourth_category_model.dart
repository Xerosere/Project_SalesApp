// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FourthCategory {
  final String name_fourth;
  final String IDcategory_first;
  final String IDcategory_second;
  final String IDcategory_third;
  final String number_cate; 
  FourthCategory({
    required this.name_fourth,
    required this.IDcategory_first,
    required this.IDcategory_second,
    required this.IDcategory_third,
    required this.number_cate,
  });

  FourthCategory copyWith({
    String? name_fourth,
    String? IDcategory_first,
    String? IDcategory_second,
    String? IDcategory_third,
    String? number_cate,
  }) {
    return FourthCategory(
      name_fourth: name_fourth ?? this.name_fourth,
      IDcategory_first: IDcategory_first ?? this.IDcategory_first,
      IDcategory_second: IDcategory_second ?? this.IDcategory_second,
      IDcategory_third: IDcategory_third ?? this.IDcategory_third,
      number_cate: number_cate ?? this.number_cate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name_fourth': name_fourth,
      'IDcategory_first': IDcategory_first,
      'IDcategory_second': IDcategory_second,
      'IDcategory_third': IDcategory_third,
      'number_cate': number_cate,
    };
  }

  factory FourthCategory.fromMap(Map<String, dynamic> map) {
    return FourthCategory(
      name_fourth: map['name_fourth'] as String,
      IDcategory_first: map['IDcategory_first'] as String,
      IDcategory_second: map['IDcategory_second'] as String,
      IDcategory_third: map['IDcategory_third'] as String,
      number_cate: map['number_cate'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FourthCategory.fromJson(String source) => FourthCategory.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FourthCategory(name_fourth: $name_fourth, IDcategory_first: $IDcategory_first, IDcategory_second: $IDcategory_second, IDcategory_third: $IDcategory_third, number_cate: $number_cate)';
  }

  @override
  bool operator ==(covariant FourthCategory other) {
    if (identical(this, other)) return true;
  
    return 
      other.name_fourth == name_fourth &&
      other.IDcategory_first == IDcategory_first &&
      other.IDcategory_second == IDcategory_second &&
      other.IDcategory_third == IDcategory_third &&
      other.number_cate == number_cate;
  }

  @override
  int get hashCode {
    return name_fourth.hashCode ^
      IDcategory_first.hashCode ^
      IDcategory_second.hashCode ^
      IDcategory_third.hashCode ^
      number_cate.hashCode;
  }
}
