import 'package:flutter/material.dart';
import 'package:moviewave/pages/main_page.dart';
import 'package:moviewave/pages/now_playing_page.dart';
import 'package:moviewave/pages/search_page.dart';
import 'package:moviewave/pages/tv_shows_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // page index
  int _currentIndex = 0;

  final List<Widget> _pages = [
    MainPage(),
    NowPlayingPage(),
    TvShowsPage(),
    SearchPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontSize: 12),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle),
            label: "Now Playing",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_outlined),
            label: "TV Shows",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        ],
      ),

      body: _pages[_currentIndex],
    );
  }
}
