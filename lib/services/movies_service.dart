import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moviewave/models/movie_model.dart';

class MoviesService {
  // get api key
  final String _apiKey = dotenv.env["TMDB_API_KEY"] ?? "";
  final String _baseUrl = "https://api.themoviedb.org/3/movie/";

  // method to fetch all upcoming movies
  Future<List<Movie>> fetchUpcomingMovies({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse("${_baseUrl}upcoming?api_key=$_apiKey&page=$page"),
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

  // method to fecth now playing movies
  Future<List<Movie>> fetchNowPlayingMovies({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse("${_baseUrl}now_playing?api_key=$_apiKey&page=$page"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> resultList = data["results"];

        return resultList.map((element) {
          return Movie.fromJson(element);
        }).toList();
      } else {
        throw Exception("Failed to fecth now playing movies");
      }
    } catch (error) {
      print("Error in fetching now playing movies service $error");
      return [];
    }
  }

  // method to search movie
  // https://api.themoviedb.org/3/search/movie?query=Avengers&api_key=ad71dd68b9e3a63fc0cd6ed2681b93fc
  Future<List<Movie>> searchMovieByName(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://api.themoviedb.org/3/search/movie?query=$query&api_key=$_apiKey",
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> resultList = data["results"];

        return resultList.map((movieData) {
          return Movie.fromJson(movieData);
        }).toList();
      } else {
        throw Exception("Failed to find the movie by name");
      }
    } catch (error) {
      print("Failed to find movie by name $error");
      throw Exception("$error");
    }
  }

  // method fetch similar movies
  // https://api.themoviedb.org/3/movie/43641/similar?api_key=ad71dd68b9e3a63fc0cd6ed2681b93fc
  Future<List<Movie>> fetchSimilarMovies(int id) async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://api.themoviedb.org/3/movie/$id/similar?api_key=$_apiKey",
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> resultList = data["results"];

        return resultList
            .map((movieData) => Movie.fromJson(movieData))
            .toList();
      } else {
        throw Exception("Failed to load similar movies");
      }
    } catch (error) {
      print("Error : $error");
      return [];
    }
  }

  // method to fetch recommend movies
  // https://api.themoviedb.org/3/movie/299536/recommendations?api_key=ad71dd68b9e3a63fc0cd6ed2681b93fc
  Future<List<Movie>> fetchRecommendedMovies(int id) async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://api.themoviedb.org/3/movie/$id/recommendations?api_key=$_apiKey",
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> resultList = data["results"];

        return resultList
            .map((movieData) => Movie.fromJson(movieData))
            .toList();
      } else {
        throw Exception("Failed to load recommended movies");
      }
    } catch (error) {
      print("Error : $error");
      return [];
    }
  }

  // method to fetch movie images using id
  // https://api.themoviedb.org/3/movie/299536/images?api_key=ad71dd68b9e3a63fc0cd6ed2681b93fc
  Future<List<String>> fetchMovieImageFromMovieId(int movieId) async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://api.themoviedb.org/3/movie/$movieId/images?api_key=$_apiKey",
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> backdropsList = data["backdrops"];

        return backdropsList
            .take(10)
            .map(
              (imageData) =>
                  "https://image.tmdb.org/t/p/w500${imageData["file_path"]}",
            )
            .toList();
      } else {
        throw Exception("Failed to load images");
      }
    } catch (error) {
      print("Error in fetching images : $error");
      return [];
    }
  }
}
