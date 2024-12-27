import 'package:tdd_clean/features/news/domain/news_entity.dart';

class NewsModel extends NewsEntity {
  const NewsModel({
    required String? sourceId,
    required String sourceName,
    required String? author,
    required String title,
    required String? description,
    required String url,
    required String? urlToImage,
    required DateTime publishedAt,
    required String? content,
  }) : super(
          sourceId: sourceId,
          sourceName: sourceName,
          author: author,
          title: title,
          description: description,
          url: url,
          urlToImage: urlToImage,
          publishedAt: publishedAt,
          content: content,
        );

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      sourceId: json['source']?['id'] as String?,
      sourceName: json['source']?['name'] as String? ?? '',
      author: json['author'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      url: json['url'] as String,
      urlToImage: json['urlToImage'] as String?,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      content: json['content'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': {
        'id': sourceId,
        'name': sourceName,
      },
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt.toUtc().toIso8601String().replaceAll('.000Z', 'Z'),
      'content': content,
    };
  }
}
