import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../api_key.dart' as apiKey;

class NewsItem {
  String title;
  String description;
  String url;
  String image;

  NewsItem({
    this.title,
    this.description,
    this.url,
    this.image,
  });
}

class News extends ChangeNotifier {
  List<NewsItem> _newsList = [];

  List<NewsItem> get newsList {
    return _newsList;
  }

  Future<void> getAllNews() async {
    String url = "http://newsapi.org/v2/top-headlines?country=my&apiKey=" +
        apiKey.newsApiKey;
    try {
      _newsList.clear();

      Response response = await Dio().get(url);
      print("<getAllNews> response data: " + response.data.toString());
      Map<String, dynamic> _responseMap = response.data as Map<String, dynamic>;

      if (_responseMap["status"] == "ok") {
        // print("<getAllNews> test 1");
        List articles = _responseMap["articles"];
        for (int x = 0; x < articles.length; x++) {
          Map<String, dynamic> articlesItem =
              articles[x] as Map<String, dynamic>;
          // print("<getAllNews> articles loop");
          // print("<getAllNews>" + articlesItem["title"]);
          NewsItem newsItem = new NewsItem(
              title: articlesItem["title"],
              description: articlesItem["description"],
              url: articlesItem["url"],
              image: articlesItem["urlToImage"]);
          _newsList.add(newsItem);
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
