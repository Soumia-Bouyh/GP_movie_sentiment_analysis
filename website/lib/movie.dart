import 'dart:convert';

class Movie {
  final String name;
  final String imageUrl;
  final double rating;
  final List<Comment> comments;

  Movie({
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.comments,
  });
}

class Comment {
  final String text;
  final String sentiment;

  Comment({
    required this.text,
    required this.sentiment,
  });
}

Movie parseMovie(String jsonStr) {
  Map<String, dynamic> json = jsonDecode(jsonStr);
  return Movie(
    name: json['title'],
    imageUrl: '${json['title'].replaceAll(' ', '')}.jpg', 
    rating: json['filledStarsCount'].toDouble(),
    comments: (json['reviews'] as List<dynamic>).map((commentJson) {
      return Comment(
        text: commentJson['comment'],
        sentiment: commentJson['sentiment'],
      );
    }).toList(),
  );
}
