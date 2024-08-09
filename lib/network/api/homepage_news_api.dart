import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/homepage_news_model.dart';

class NewsAPIProvider {
  final Dio _dio = Dio();

  Future<NewsModel> fetchmynewslist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print("Fetch news Request");
      final String _url = 'https://newsapi.org/v2/top-headlines?country=in&apiKey=7ba8778afdff45ac834125eeb630abd2';

      Response response = await _dio.get(_url,
        options: Options(
            headers: {
            },
            validateStatus: (status) {
              return status != null && (status == 401 || status == 200 || status == 422);
            }),
      );

      if (response.statusCode == 200) {
        return NewsModel.fromJson(response.data);
      } else if (response.statusCode == 422) {
        print("Error 422: " + response.data["message"]);
        return NewsModel.withError(response.data["message"]);
      } else {
        print("Error ${response.statusCode}: " + response.data["message"]);
        return NewsModel.withError(response.data["message"]);
      }
    } catch (e) {
      print("Exception: $e");
      return NewsModel.withError("An error occurred");
    }
  }
}
