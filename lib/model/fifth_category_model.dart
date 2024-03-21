// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FifthCategory {
  final String name_fifth;
  final String IDcategory_first;
  final String IDcategory_secnond;
  final String IDcategory_third;
  final String IDcategory_fourth;
  final String number_cate;
  FifthCategory({
    required this.name_fifth,
    required this.IDcategory_first,
    required this.IDcategory_secnond,
    required this.IDcategory_third,
    required this.IDcategory_fourth,
    required this.number_cate,
  });

  FifthCategory copyWith({
    String? name_fifth,
    String? IDcategory_first,
    String? IDcategory_secnond,
    String? IDcategory_third,
    String? IDcategory_fourth,
    String? number_cate,
  }) {
    return FifthCategory(
      name_fifth: name_fifth ?? this.name_fifth,
      IDcategory_first: IDcategory_first ?? this.IDcategory_first,
      IDcategory_secnond: IDcategory_secnond ?? this.IDcategory_secnond,
      IDcategory_third: IDcategory_third ?? this.IDcategory_third,
      IDcategory_fourth: IDcategory_fourth ?? this.IDcategory_fourth,
      number_cate: number_cate ?? this.number_cate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name_fifth': name_fifth,
      'IDcategory_first': IDcategory_first,
      'IDcategory_secnond': IDcategory_secnond,
      'IDcategory_third': IDcategory_third,
      'IDcategory_fourth': IDcategory_fourth,
      'number_cate': number_cate,
    };
  }

  factory FifthCategory.fromMap(Map<String, dynamic> map) {
    return FifthCategory(
      name_fifth: map['name_fifth'] as String,
      IDcategory_first: map['IDcategory_first'] as String,
      IDcategory_secnond: map['IDcategory_secnond'] as String,
      IDcategory_third: map['IDcategory_third'] as String,
      IDcategory_fourth: map['IDcategory_fourth'] as String,
      number_cate: map['number_cate'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FifthCategory.fromJson(String source) => FifthCategory.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FifthCategory(name_fifth: $name_fifth, IDcategory_first: $IDcategory_first, IDcategory_secnond: $IDcategory_secnond, IDcategory_third: $IDcategory_third, IDcategory_fourth: $IDcategory_fourth, number_cate: $number_cate)';
  }

  @override
  bool operator ==(covariant FifthCategory other) {
    if (identical(this, other)) return true;
  
    return 
      other.name_fifth == name_fifth &&
      other.IDcategory_first == IDcategory_first &&
      other.IDcategory_secnond == IDcategory_secnond &&
      other.IDcategory_third == IDcategory_third &&
      other.IDcategory_fourth == IDcategory_fourth &&
      other.number_cate == number_cate;
  }

  @override
  int get hashCode {
    return name_fifth.hashCode ^
      IDcategory_first.hashCode ^
      IDcategory_secnond.hashCode ^
      IDcategory_third.hashCode ^
      IDcategory_fourth.hashCode ^
      number_cate.hashCode;
  }
   }
