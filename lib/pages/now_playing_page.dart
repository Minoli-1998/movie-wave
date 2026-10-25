import 'package:flutter/material.dart';
import 'package:moviewave/models/movie_model.dart';
import 'package:moviewave/services/movies_service.dart';
import 'package:moviewave/widgets/movie_card.dart';

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({super.key});

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {
  // fields
  List<Movie> _movieList = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoding = false;

  // method to fetch now playing movies
  Future<void> _fetchNowPlayingMovies() async {
    setState(() {
      _isLoding = true;
    });

    try {
      final fetchedMovies = await MoviesService().fetchNowPlayingMovies(
        page: _currentPage,
      );

      setState(() {
        _movieList = fetchedMovies;
        _totalPages = 100;
      });
    } catch (error) {
      print("Error in now playing page $error");
    } finally {
      setState(() {
        _isLoding = false;
      });
    }
  }

  // method to go prev page
  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      _fetchNowPlayingMovies();
    }
  }

  // method to next page
  void _nextPage() {
    if (_currentPage < _totalPages) {
      _currentPage++;
    }
    _fetchNowPlayingMovies();
  }

  @override
  void initState() {
    super.initState();
    _fetchNowPlayingMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Now Playing Page")),
      body: _isLoding
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _movieList.length + 1,
                    itemBuilder: (context, index) {
                      if (index > _movieList.length - 1) {
                        // pagination widget
                        return _buildPaginationWidget();
                      } else {
                        Movie movie = _movieList[index];
                        return MovieCard(
                          imagePath: movie.posterPath!,
                          title: movie.title,
                          releaseDate: movie.releaseDate,
                          overview: movie.overview,
                          averageVote: movie.voteAverage,
                          popularity: movie.popularity,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPaginationWidget() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _currentPage > 1 ? _previousPage : null,
            child: Text("Previous"),
          ),

          SizedBox(width: 10),

          Text("Page $_currentPage of $_totalPages"),

          SizedBox(width: 10),

          ElevatedButton(
            onPressed: _currentPage < _totalPages ? _nextPage : null,
            child: Text("Next"),
          ),
        ],
      ),
    );
  }
}
