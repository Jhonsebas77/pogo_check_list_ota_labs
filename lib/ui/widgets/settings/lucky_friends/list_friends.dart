part of com.pogo_check_list_ota_labs.app.widgets;

class LuckyFriendsList extends StatelessWidget {
  const LuckyFriendsList({
    required this.friends,
    this.onLongPressEdit,
    super.key,
  });
  final List<LuckyFriend> friends;
  final void Function(int index, LuckyFriend friend)? onLongPressEdit;

  @override
  Widget build(BuildContext context) {
    if (friends.isEmpty) {
      return const EmptyState();
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: friends.length,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      itemBuilder: (BuildContext context, int index) {
        LuckyFriend friend = friends[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: GestureDetector(
            onLongPress:
                onLongPressEdit == null
                    ? null
                    : () => onLongPressEdit!(index, friend),
            child: LuckyFriendListTile(friend: friend),
          ),
        );
      },
    );
  }
}
