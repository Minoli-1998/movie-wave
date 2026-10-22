import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String releaseDate;
  final String overview;
  final double averageVote;
  final double popularity;

  const MovieCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.releaseDate,
    required this.overview,
    required this.averageVote,
    required this.popularity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.blueGrey.shade900,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(10),
            child: Image.network(
              "https://image.tmdb.org/t/p/w500/$imagePath",
              width: double.infinity,
              height: 300,
              fit: BoxFit.fitWidth,
              alignment: AlignmentGeometry.topCenter,
            ),
          ),

          SizedBox(height: 10),

          // title
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 10),

          // release date
          Text(
            "Release Date : $releaseDate",
            style: TextStyle(
              color: Colors.deepOrange,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 10),

          // overview
          Text(
            "Overview",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 10),

          // description para
          Text(
            overview,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 10),

          // row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // average vote
              Text(
                "Average Vote: ${averageVote.toStringAsFixed(2)}",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // popularity
              Text(
                "Popularity: ${popularity.toStringAsFixed(3)}",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
