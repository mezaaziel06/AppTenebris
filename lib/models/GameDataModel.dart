class GameDataModel {
  final String gameSessionID;
  final int score;
  final String currentZone;
  final int deaths;

  GameDataModel({
    required this.gameSessionID,
    required this.score,
    required this.currentZone,
    required this.deaths,
  });

  factory GameDataModel.fromJson(Map<String, dynamic> json) {
    return GameDataModel(
      gameSessionID: json['gameSessionID'],
      score: json['score'],
      currentZone: json['currentZone'],
      deaths: json['deaths'],
    );
  }
}
