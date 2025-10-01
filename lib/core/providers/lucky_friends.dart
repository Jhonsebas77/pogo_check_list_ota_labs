part of com.pogo_check_list_ota_labs.app.providers;

final FutureProvider<List<LuckyFriend>> luckyFriendsProvider = FutureProvider<
  List<LuckyFriend>
>((FutureProviderRef<List<LuckyFriend>> ref) async {
  try {
    String jsonString = await rootBundle.loadString(
      'assets/mocks/lucky_friends.json',
    );
    Map<String, dynamic> data = jsonDecode(jsonString) as Map<String, dynamic>;
    List<dynamic> friendsData =
        data['friends'] != null
            ? List<dynamic>.from(data['friends'] as List<dynamic>)
            : <dynamic>[];
    return friendsData
        .map(
          (dynamic friend) => LuckyFriend.fromJson(
            Map<String, dynamic>.from(friend as Map<dynamic, dynamic>),
          ),
        )
        .toList()
      ..sort(
        (LuckyFriend a, LuckyFriend b) =>
            a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
  } catch (error, stackTrace) {
    debugPrint('Failed to load lucky friends: $error');
    debugPrint('Stacktrace: $stackTrace');
    throw Exception('Could not load lucky friends.');
  }
});
