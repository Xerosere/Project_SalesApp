// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Tag_Model {
  final String name_tag;
  Tag_Model({
    required this.name_tag,
  });

  Tag_Model copyWith({
    String? name_tag,
  }) {
    return Tag_Model(
      name_tag: name_tag ?? this.name_tag,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name_tag': name_tag,
    };
  }

  factory Tag_Model.fromMap(Map<String, dynamic> map) {
    return Tag_Model(
      name_tag: map['name_tag'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Tag_Model.fromJson(String source) => Tag_Model.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Tag_Model(name_tag: $name_tag)';

  @override
  bool operator ==(covariant Tag_Model other) {
    if (identical(this, other)) return true;
  
    return 
      other.name_tag == name_tag;
  }

  @override
  int get hashCode => name_tag.hashCode;
}
