import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostRepository {
  Future<List<Post>> getPosts(int page, int limit) async {
    final response = await http.get(Uri.parse(
        'https://jsonplaceholder.typicode.com/posts?_page=$page&_limit=$limit'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
