class MetaDataModel {
  final String title;
  final String authorName;
  final String authorUrl;
  final String description;

  MetaDataModel({
    required this.title,
    required this.authorName,
    required this.authorUrl,
    required this.description,
  });

  factory MetaDataModel.fromJson(Map<String, dynamic> json) {
    return MetaDataModel(
      title: json['title'],
      authorName: json['authorName'],
      authorUrl: json['authorUrl'],
      description: json['description'],
    );
  }
}
