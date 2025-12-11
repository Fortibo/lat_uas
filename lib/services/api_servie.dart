import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lat_uas/models/post.dart';

class ApiServie {
  static const String baseUrl = "https://jsonplaceholder.typicode.com";

  // get post

  Future<List<Post>> fetchPosts() async {
    final uri = Uri.parse('$baseUrl/posts');
    final res = await http.get(uri);

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load posts Status: ${res.statusCode}');
    }
  }

  // get post id

  Future<Post> fetchPostById(int id) async {
    final uri = Uri.parse('$baseUrl/posts/$id');
    final res = await http.get(uri);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return Post.fromJson(data);
    } else {
      throw Exception('Failed to load post Status: ${res.statusCode}');
    }
  }
}
