part of com.pogo_check_list_ota_labs.app.models;

class TrainerModel {
  const TrainerModel({this.level, this.nickName, this.team, this.trainerId});

  factory TrainerModel.fromJson(Map<dynamic, dynamic> json) => TrainerModel(
    level: json['level'] != null ? json['level'] as String : '',
    nickName: json['nick_name'] != null ? json['nick_name'] as String : '',
    team: json['team'] != null ? json['team'] as String : '',
    trainerId: json['trainer_id'] != null ? json['trainer_id'] as String : '',
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'level': level,
    'nick_name': nickName,
    'team': team,
    'trainer_id': trainerId,
  };

  final String? level;
  final String? trainerId;
  final String? nickName;
  final String? team;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrainerModel &&
          runtimeType == other.runtimeType &&
          hashCode == other.hashCode;

  @override
  int get hashCode => Object.hash(level, trainerId, nickName, team);

  @override
  String toString() => '''TrainerModel(
    'level': $level,
    'nick_name': $nickName,
    'team': $team,
    'trainer_id': $trainerId
  )''';
}
