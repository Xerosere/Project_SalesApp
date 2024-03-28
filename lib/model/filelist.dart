// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FileModel {
  final String name_file;
  final String datetime_upload;
  final String? description_file;
  final String? user_name;
  final String number_cate;
  final String IDcategory_first;
  final String? IDcategory_second;
  final String? IDcategory_third;
  final String? IDcategory_fourth;
  final String? IDcategory_fifth;
  final String? path_video;
  final String type_file;
  final String Tag;
  FileModel({
    required this.name_file,
    required this.datetime_upload,
    this.description_file,
    this.user_name,
    required this.number_cate,
    required this.IDcategory_first,
    this.IDcategory_second,
    this.IDcategory_third,
    this.IDcategory_fourth,
    this.IDcategory_fifth,
    this.path_video,
    required this.type_file,
    required this.Tag,
  });

  get path_file => null;

  FileModel copyWith({
    String? name_file,
    String? datetime_upload,
    String? description_file,
    String? user_name,
    String? number_cate,
    String? IDcategory_first,
    String? IDcategory_second,
    String? IDcategory_third,
    String? IDcategory_fourth,
    String? IDcategory_fifth,
    String? path_video,
    String? type_file,
    String? Tag,
  }) {
    return FileModel(
      name_file: name_file ?? this.name_file,
      datetime_upload: datetime_upload ?? this.datetime_upload,
      description_file: description_file ?? this.description_file,
      user_name: user_name ?? this.user_name,
      number_cate: number_cate ?? this.number_cate,
      IDcategory_first: IDcategory_first ?? this.IDcategory_first,
      IDcategory_second: IDcategory_second ?? this.IDcategory_second,
      IDcategory_third: IDcategory_third ?? this.IDcategory_third,
      IDcategory_fourth: IDcategory_fourth ?? this.IDcategory_fourth,
      IDcategory_fifth: IDcategory_fifth ?? this.IDcategory_fifth,
      path_video: path_video ?? this.path_video,
      type_file: type_file ?? this.type_file,
      Tag: Tag ?? this.Tag,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name_file': name_file,
      'datetime_upload': datetime_upload,
      'description_file': description_file,
      'user_name': user_name,
      'number_cate': number_cate,
      'IDcategory_first': IDcategory_first,
      'IDcategory_second': IDcategory_second,
      'IDcategory_third': IDcategory_third,
      'IDcategory_fourth': IDcategory_fourth,
      'IDcategory_fifth': IDcategory_fifth,
      'path_video': path_video,
      'type_file': type_file,
      'Tag': Tag,
    };
  }

  factory FileModel.fromMap(Map<String, dynamic> map) {
    return FileModel(
      name_file: map['name_file'] as String,
      datetime_upload: map['datetime_upload'] as String,
      description_file: map['description_file'] != null
          ? map['description_file'] as String
          : null,
      user_name: map['user_name'] != null ? map['user_name'] as String : null,
      number_cate: map['number_cate'] as String,
      IDcategory_first: map['IDcategory_first'] as String,
      IDcategory_second: map['IDcategory_second'] != null
          ? map['IDcategory_second'] as String
          : null,
      IDcategory_third: map['IDcategory_third'] != null
          ? map['IDcategory_third'] as String
          : null,
      IDcategory_fourth: map['IDcategory_fourth'] != null
          ? map['IDcategory_fourth'] as String
          : null,
      IDcategory_fifth: map['IDcategory_fifth'] != null
          ? map['IDcategory_fifth'] as String
          : null,
      path_video:
          map['path_video'] != null ? map['path_video'] as String : null,
      type_file: map['type_file'] as String,
      Tag: map['Tag'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FileModel.fromJson(String source) =>
      FileModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FileModel(name_file: $name_file, datetime_upload: $datetime_upload, description_file: $description_file, user_name: $user_name, number_cate: $number_cate, IDcategory_first: $IDcategory_first, IDcategory_second: $IDcategory_second, IDcategory_third: $IDcategory_third, IDcategory_fourth: $IDcategory_fourth, IDcategory_fifth: $IDcategory_fifth, path_video: $path_video, type_file: $type_file, Tag: $Tag)';
  }

  @override
  bool operator ==(covariant FileModel other) {
    if (identical(this, other)) return true;

    return other.name_file == name_file &&
        other.datetime_upload == datetime_upload &&
        other.description_file == description_file &&
        other.user_name == user_name &&
        other.number_cate == number_cate &&
        other.IDcategory_first == IDcategory_first &&
        other.IDcategory_second == IDcategory_second &&
        other.IDcategory_third == IDcategory_third &&
        other.IDcategory_fourth == IDcategory_fourth &&
        other.IDcategory_fifth == IDcategory_fifth &&
        other.path_video == path_video &&
        other.type_file == type_file &&
        other.Tag == Tag;
  }

  @override
  int get hashCode {
    return name_file.hashCode ^
        datetime_upload.hashCode ^
        description_file.hashCode ^
        user_name.hashCode ^
        number_cate.hashCode ^
        IDcategory_first.hashCode ^
        IDcategory_second.hashCode ^
        IDcategory_third.hashCode ^
        IDcategory_fourth.hashCode ^
        IDcategory_fifth.hashCode ^
        path_video.hashCode ^
        type_file.hashCode ^
        Tag.hashCode;
  }
}
