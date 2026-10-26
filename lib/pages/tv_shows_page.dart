import 'package:flutter/material.dart';
import 'package:moviewave/models/tv_show_model.dart';
import 'package:moviewave/services/tv_shows_service.dart';
import 'package:moviewave/widgets/tv_show_card.dart';

class TvShowsPage extends StatefulWidget {
  const TvShowsPage({super.key});

  @override
  State<TvShowsPage> createState() => _TvShowsPageState();
}

class _TvShowsPageState extends State<TvShowsPage> {
  // fields
  List<TvShow> _tvShows = [];
  bool _isLoading = false;
  String _error = "";

  // method to fetch tv shows
  Future<void> _fetchTvShows() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tvShowsList = await TvShowsService().fetchTvShows();

      setState(() {
        _tvShows = tvShowsList;
      });
    } catch (error) {
      _error = "Failed to load Tv Shows";
      throw Exception("Failed to load Tv Shows");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTvShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TV Shows")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(child: Text(_error))
          : Expanded(
              child: ListView.builder(
                itemCount: _tvShows.length,
                itemBuilder: (context, index) {
                  TvShow tvShow = _tvShows[index];

                  return TvShowCard(tvShow: tvShow);
                },
              ),
            ),
    );
  }
}
