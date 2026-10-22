class TvShow {
  final bool adult;
  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String firstAirDate;
  final String name;
  final bool softcore;
  final double voteAverage;
  final int voteCount;

  TvShow({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    this.posterPath,
    required this.firstAirDate,
    required this.name,
    required this.softcore,
    required this.voteAverage,
    required this.voteCount,
  });

  // method to convert json to dart object
  factory TvShow.fromJson(Map<String, dynamic> json) {
    return TvShow(
      adult: json["adult"] ?? false,
      backdropPath: json["backdrop_path"] as String?,
      genreIds: List<int>.from(json["genre_ids"] ?? []),
      id: json["id"] ?? 0,
      originCountry: List<String>.from(json["origin_country"] ?? []),
      originalLanguage: json["original_language"] ?? "",
      originalName: json["original_name"] ?? "",
      overview: json["overview"] ?? "",
      popularity: (json["popularity"] ?? 0).toDouble(),
      posterPath: json["poster_path"] as String?,
      firstAirDate: json["first_air_date"] ?? "",
      name: json["name"] ?? "",
      softcore: json["softcore"] ?? false,
      voteAverage: (json["vote_average"] ?? 0).toDouble(),
      voteCount: json["vote_count"] ?? 0,
    );
  }
}
