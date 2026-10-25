import 'package:flutter/material.dart';
import 'package:moviewave/models/movie_model.dart';
import 'package:moviewave/services/movies_service.dart';
import 'package:moviewave/widgets/search_movie_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // fields
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _searchMoviesList = [];
  bool _isLoading = false;
  String _error = "";

  // method to search movies
  Future<void> _searchMovies() async {
    setState(() {
      _isLoading = true;
      _error = "";
    });

    try {
      print(_searchController.text);
      final List<Movie> movieList = await MoviesService().searchMovieByName(
        _searchController.text,
      );

      setState(() {
        _searchMoviesList = movieList;
      });
    } catch (error) {
      print("Error : $error");

      setState(() {
        _error = "Failed to find the movie & $error";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Movies")),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search for a movie",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      contentPadding: EdgeInsets.all(10),
                    ),
                    onSubmitted: (value) => _searchMovies(),
                  ),
                ),

                SizedBox(width: 10),

                IconButton(
                  onPressed: _searchMovies,
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.deepOrange),
                  ),
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 30,
                    weight: 10,
                  ),
                ),
              ],
            ),

            if (_isLoading)
              Padding(
                padding: EdgeInsetsGeometry.all(20),
                child: CircularProgressIndicator(),
              )
            else if (_error.isNotEmpty)
              Text(_error)
            else if (_searchMoviesList.isEmpty)
              Padding(
                padding: EdgeInsetsGeometry.all(20),
                child: Text("No movies found. Please search...."),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _searchMoviesList.length,
                  itemBuilder: (context, index) {
                    Movie movie = _searchMoviesList[index];
                    return Column(
                      children: [
                        SearchMovieCard(
                          imagePath: movie.posterPath!,
                          title: movie.title,
                          releaseDate: movie.releaseDate,
                          overview: movie.overview,
                          averageVote: movie.voteAverage,
                          popularity: movie.popularity,
                        ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
