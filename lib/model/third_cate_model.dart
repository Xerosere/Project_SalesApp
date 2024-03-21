// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Third_category {
  final String name_third;
  final String IDcategory_first;
  final String IDcategory_second;
  final String number_cate;
  Third_category({
    required this.name_third,
    required this.IDcategory_first,
    required this.IDcategory_second,
    required this.number_cate,
  });

  Third_category copyWith({
    String? name_third,
    String? IDcategory_first,
    String? IDcategory_second,
    String? number_cate,
  }) {
    return Third_category(
      name_third: name_third ?? this.name_third,
      IDcategory_first: IDcategory_first ?? this.IDcategory_first,
      IDcategory_second: IDcategory_second ?? this.IDcategory_second,
      number_cate: number_cate ?? this.number_cate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name_third': name_third,
      'IDcategory_first': IDcategory_first,
      'IDcategory_second': IDcategory_second,
      'number_cate': number_cate,
    };
  }

  factory Third_category.fromMap(Map<String, dynamic> map) {
    return Third_category(
      name_third: map['name_third'] as String,
      IDcategory_first: map['IDcategory_first'] as String,
      IDcategory_second: map['IDcategory_second'] as String,
      number_cate: map['number_cate'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Third_category.fromJson(String source) => Third_category.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Third_category(name_third: $name_third, IDcategory_first: $IDcategory_first, IDcategory_second: $IDcategory_second, number_cate: $number_cate)';
  }

  @override
  bool operator ==(covariant Third_category other) {
    if (identical(this, other)) return true;
  
    return 
      other.name_third == name_third &&
      other.IDcategory_first == IDcategory_first &&
      other.IDcategory_second == IDcategory_second &&
      other.number_cate == number_cate;
  }

  @override
  int get hashCode {
    return name_third.hashCode ^
      IDcategory_first.hashCode ^
      IDcategory_second.hashCode ^
      number_cate.hashCode;
  }
}
