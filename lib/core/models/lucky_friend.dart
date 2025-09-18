part of com.pogo_check_list_ota_labs.app.models;

enum LuckyFriendActivityType { gift, caught, raid, trade, other }

class LuckyFriend {
  const LuckyFriend({
    required this.name,
    required this.activity,
    required this.timeLabel,
    this.avatarUrl,
    this.activityType = LuckyFriendActivityType.other,
  });

  factory LuckyFriend.fromJson(Map<String, dynamic> json) => LuckyFriend(
    name: json['name'] != null ? json['name'] as String : '',
    activity: json['activity'] != null ? json['activity'] as String : '',
    timeLabel: json['time_label'] != null ? json['time_label'] as String : '',
    avatarUrl: json['avatar_url'] != null ? json['avatar_url'] as String : null,
    activityType: _mapActivityType(json['activity_type'] as String?),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'activity': activity,
    'time_label': timeLabel,
    if (avatarUrl != null) 'avatar_url': avatarUrl,
    'activity_type': activityType.name,
  };

  final String name;
  final String activity;
  final String timeLabel;
  final String? avatarUrl;
  final LuckyFriendActivityType activityType;

  static LuckyFriendActivityType _mapActivityType(String? value) {
    switch (value) {
      case 'gift':
        return LuckyFriendActivityType.gift;
      case 'catch':
        return LuckyFriendActivityType.caught;
      case 'raid':
        return LuckyFriendActivityType.raid;
      case 'trade':
        return LuckyFriendActivityType.trade;
      default:
        return LuckyFriendActivityType.other;
    }
  }
}
