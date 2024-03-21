// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MainCategoryModel {
final String name_first;
final String id_category;
final String ID;
  MainCategoryModel({
    required this.name_first,
    required this.id_category,
    required this.ID,
  });

  MainCategoryModel copyWith({
    String? name_first,
    String? id_category,
    String? ID,
  }) {
    return MainCategoryModel(
      name_first: name_first ?? this.name_first,
      id_category: id_category ?? this.id_category,
      ID: ID ?? this.ID,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name_first': name_first,
      'id_category': id_category,
      'ID': ID,
    };
  }

  factory MainCategoryModel.fromMap(Map<String, dynamic> map) {
    return MainCategoryModel(
      name_first: map['name_first'] as String,
      id_category: map['id_category'] as String,
      ID: map['ID'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MainCategoryModel.fromJson(String source) => MainCategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MainCategoryModel(name_first: $name_first, id_category: $id_category, ID: $ID)';

  @override
  bool operator ==(covariant MainCategoryModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.name_first == name_first &&
      other.id_category == id_category &&
      other.ID == ID;
  }

  @override
  int get hashCode => name_first.hashCode ^ id_category.hashCode ^ ID.hashCode;
}
