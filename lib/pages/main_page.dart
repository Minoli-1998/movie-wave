import 'package:flutter/material.dart';
import 'package:moviewave/models/movie_model.dart';
import 'package:moviewave/services/movies_service.dart';
import 'package:moviewave/widgets/movie_card.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Movie> _movieList = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  // method to fetch upcoming movies from api and it load when when the page is called mean in the initState
  Future<void> _fetchUpcomingMovies() async {
    // when the page is loading to display more data but all data has displayed
    if (_isLoading || !_hasMore) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final newMovies = await MoviesService().fetchUpcomingMovies(
        page: _currentPage,
      );

      // if user is scrolling fast the API will call nonstoply. It's not good so there will be a delay when fetching new movies list
      await Future.delayed(Duration(seconds: 1));

      // if newMovies is empty that means there is nothing more to load
      setState(() {
        if (newMovies.isEmpty) {
          _hasMore = false;
        } else {
          _movieList.addAll(newMovies);
          _currentPage++;
        }
      });
    } catch (error) {
      throw Exception("Error in fetching movies $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUpcomingMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "MovieWave",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrangeAccent,
          ),
        ),
      ),

      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (!_isLoading ||
              notification.metrics.pixels ==
                  notification.metrics.maxScrollExtent) {
            _fetchUpcomingMovies();
          }

          return true;
        },
        child: ListView.builder(
          // when user reach to the end point of loaded movies have to display a circular loding indigator
          // for that have to add another widget to the item count means have to increase itemCount by one
          // adding one to itemcount manully is not good so if the data is loading can add a one more widget to the list and that is a circular loading indigator
          itemCount: _movieList.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _movieList.length) {
              return Center(child: CircularProgressIndicator());
            }

            Movie movie = _movieList[index];

            return MovieCard(
              imagePath: movie.posterPath!,
              title: movie.title,
              releaseDate: movie.releaseDate,
              overview: movie.overview,
              averageVote: movie.voteAverage,
              popularity: movie.popularity,
            );
          },
        ),
      ),
    );
  }
}
