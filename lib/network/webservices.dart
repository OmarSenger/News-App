import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/news.dart';

class Webservices {

  Future<News> loadNews (String type,String country) async {
    final response = await http.get('http://newsapi.org/v2/top-headlines?country=$country&category=$type&apiKey=4be9e97a2fea4ef4808fe877c7e85bee');
    if (response.statusCode == 200){
      final json = jsonDecode(response.body);
      return News.fromJson(json);
    }
    else {
      throw Exception('Error');
    }
  }
}