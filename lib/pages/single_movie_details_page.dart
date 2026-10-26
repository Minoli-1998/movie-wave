import 'package:flutter/material.dart';
import 'package:moviewave/models/movie_model.dart';
import 'package:moviewave/services/movies_service.dart';
import 'package:moviewave/widgets/search_movie_card.dart';

class SingleMovieDetailsPage extends StatefulWidget {
  final Movie movie;
  const SingleMovieDetailsPage({super.key, required this.movie});

  @override
  State<SingleMovieDetailsPage> createState() => _SingleMovieDetailsPageState();
}

class _SingleMovieDetailsPageState extends State<SingleMovieDetailsPage> {
  // fields
  List<Movie> _similarMovies = [];
  List<Movie> _recommendedMovies = [];
  List<String> _movieImages = [];

  bool _similarIsLoading = false;
  bool _recommendedIsLoading = false;
  bool _imagesIsLoading = false;

  // methods
  // method to fetch similar movies
  Future<void> _fetchSimilarMovies() async {
    setState(() {
      _similarIsLoading = true;
    });

    try {
      final fetchedMovies = await MoviesService().fetchSimilarMovies(
        widget.movie.id,
      );

      setState(() {
        _similarMovies = fetchedMovies;
      });
    } catch (error) {
      print("Error from similar : $error");
    } finally {
      setState(() {
        _similarIsLoading = false;
      });
    }
  }

  // method to fetch recommended movies
  Future<void> _fetchRecommendedMovies() async {
    setState(() {
      _recommendedIsLoading = true;
    });

    try {
      final fetchedMovies = await MoviesService().fetchRecommendedMovies(
        widget.movie.id,
      );

      setState(() {
        _recommendedMovies = fetchedMovies;
      });
    } catch (error) {
      print("Error from recommended : $error");
    } finally {
      setState(() {
        _recommendedIsLoading = false;
      });
    }
  }

  // method to fetch images
  Future<void> _fetchMovieImages() async {
    setState(() {
      _imagesIsLoading = true;
    });

    try {
      final fetchedImages = await MoviesService().fetchMovieImageFromMovieId(
        widget.movie.id,
      );

      setState(() {
        _movieImages = fetchedImages;
      });
    } catch (error) {
      print("Error from loading images : $error");
    } finally {
      setState(() {
        _imagesIsLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMovieImages();
    _fetchRecommendedMovies();
    _fetchSimilarMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.movie.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // movie details widget
              SearchMovieCard(
                imagePath: widget.movie.posterPath!,
                title: widget.movie.title,
                releaseDate: widget.movie.releaseDate,
                overview: widget.movie.overview,
                averageVote: widget.movie.voteAverage,
                popularity: widget.movie.popularity,
              ),

              // movie images
              _imagesIsLoading
                  ? Center(child: CircularProgressIndicator())
                  : _movieImages.isEmpty
                  ? SizedBox()
                  : Container(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.blueGrey,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Movie Images",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          SizedBox(height: 15),

                          SizedBox(
                            height: 250,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: _movieImages.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                String imagePath = _movieImages[index];
                                return Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      10,
                                    ),
                                    child: Image.network(
                                      imagePath,
                                      width: 250,
                                      height: 250,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

              // similar movies
              _similarIsLoading
                  ? Center(child: CircularProgressIndicator())
                  : _similarMovies.isEmpty
                  ? SizedBox()
                  : Container(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.blueGrey,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Similar Movies",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          SizedBox(height: 15),

                          SizedBox(
                            height: 400,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: _similarMovies.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                Movie movie = _similarMovies[index];
                                return movie.posterPath == null
                                    ? SizedBox()
                                    : _buildMovieCard(movie);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

              // recommended movies
              _recommendedIsLoading
                  ? Center(child: CircularProgressIndicator())
                  : _recommendedMovies.isEmpty
                  ? SizedBox()
                  : Container(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.blueGrey,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Recommended Movies",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          SizedBox(height: 15),

                          SizedBox(
                            height: 400,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: _recommendedMovies.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                Movie movie = _recommendedMovies[index];
                                return _buildMovieCard(movie);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // widget
  Widget _buildMovieCard(Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return SingleMovieDetailsPage(movie: movie);
            },
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // posterpath
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(10),
              child: Image.network(
                "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                width: 150,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: 5),

            // title
            SizedBox(
              width: 150,
              child: Text(
                movie.title,
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 5),

            // average vote
            Text(
              "Average Vote : ${movie.voteAverage}",
              style: TextStyle(color: Colors.deepOrange, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
