import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moviewave/models/movie_model.dart';

class MoviesService {
  // get api key
  final String _apiKey = dotenv.env["TMDB_API_KEY"] ?? "";
  final String _baseUrl = "https://api.themoviedb.org/3/movie/upcoming?";

  // method to fetch all upcoming movies
  Future<List<Movie>> fetchUpcomingMovies({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse("${_baseUrl}api_key=$_apiKey&page=$page"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> resultList = data["results"];

        return resultList
            .map((movieData) => Movie.fromJson(movieData))
            .toList();
      } else {
        print("Error in fetching upcoming movies ${response.statusCode}");
        throw Exception("Failed to load upcoming movies");
      }
    } catch (error) {
      print("Error in fetching upcoming movies $error");
      return [];
    }
  }
}
