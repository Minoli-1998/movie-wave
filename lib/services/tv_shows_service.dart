import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moviewave/models/tv_show_model.dart';

class TvShowsService {
  // fields
  final String _apikey = dotenv.env["TMDB_API_KEY"] ?? "";
  final String _baseUrl = "https://api.themoviedb.org/3/tv";

  // method to fetch all tv shows by calling multiple end points
  Future<List<TvShow>> fetchTvShows() async {
    try {
      // top rated
      final topRatedResponse = await http.get(
        Uri.parse("$_baseUrl/top_rated?api_key=$_apikey"),
      );

      // airing today
      final airingTodayResponse = await http.get(
        Uri.parse("$_baseUrl/airing_today?api_key=$_apikey"),
      );

      // popular
      final popuarResponse = await http.get(
        Uri.parse("$_baseUrl/popular?api_key=$_apikey"),
      );

      if (topRatedResponse.statusCode == 200 &&
          airingTodayResponse.statusCode == 200 &&
          popuarResponse.statusCode == 200) {
        // data
        final topRatedData = json.decode(topRatedResponse.body);
        final airingTodayData = json.decode(airingTodayResponse.body);
        final popularData = json.decode(popuarResponse.body);

        // results
        final List<dynamic> topRatedResults = topRatedData["results"];
        final List<dynamic> airingTodaydResults = airingTodayData["results"];
        final List<dynamic> popularResults = popularData["results"];

        final List<TvShow> tvShowList = [];

        tvShowList.addAll(
          topRatedResults
              .map((tvShowData) {
                return TvShow.fromJson(tvShowData);
              })
              .take(10),
        );
        tvShowList.addAll(
          airingTodaydResults
              .map((tvShowData) {
                return TvShow.fromJson(tvShowData);
              })
              .take(10),
        );
        tvShowList.addAll(
          popularResults
              .map((tvShowData) {
                return TvShow.fromJson(tvShowData);
              })
              .take(10),
        );

        return tvShowList;
      } else {
        throw Exception("Failed to fetch Tv Shows");
      }
    } catch (error) {
      print("Error in tv show service : $error");
      return [];
    }
  }
}
