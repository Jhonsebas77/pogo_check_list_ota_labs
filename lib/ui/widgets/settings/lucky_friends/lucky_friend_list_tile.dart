part of com.pogo_check_list_ota_labs.app.widgets;

class LuckyFriendListTile extends StatelessWidget {
  const LuckyFriendListTile({required this.friend, super.key});

  final LuckyFriend friend;

  IconData _activityIcon() {
    switch (friend.activityType) {
      case LuckyFriendActivityType.gift:
        return Icons.card_giftcard;
      case LuckyFriendActivityType.caught:
        return Icons.catching_pokemon;
      case LuckyFriendActivityType.raid:
        return Icons.flash_on;
      case LuckyFriendActivityType.trade:
        return Icons.swap_horiz;
      case LuckyFriendActivityType.other:
        return Icons.auto_awesome;
    }
  }

  Color _activityColor(BuildContext context) {
    switch (friend.activityType) {
      case LuckyFriendActivityType.gift:
        return const Color(0xFFFC8F2A);
      case LuckyFriendActivityType.caught:
        return Theme.of(context).colorScheme.primary;
      case LuckyFriendActivityType.raid:
        return Colors.deepPurple;
      case LuckyFriendActivityType.trade:
        return Colors.teal;
      case LuckyFriendActivityType.other:
        return Colors.indigo;
    }
  }

  Widget _buildAvatar(BuildContext context) {
    if (friend.avatarUrl != null && friend.avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 32,
        backgroundImage: NetworkImage(friend.avatarUrl!),
      );
    }
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Image.asset(
          'assets/bg_holder_pokemon.png',
          height: 64,
          width: 64,
          fit: BoxFit.fill,
        ),
        const Center(
          child: Icon(Icons.emoji_people, color: Colors.grey, size: 50),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Image.asset('assets/icon_lucky.png', height: 32, width: 32),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Color activityColor = _activityColor(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildAvatar(context),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        friend.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFDA7B28),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 2,
                    children: List<Widget>.generate(
                      4,
                      (_) => const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircleAvatar(
                          backgroundColor: Colors.orange,
                          child: Icon(
                            Icons.favorite,
                            color: Colors.yellow,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // const SizedBox(width: 16),
          // Row(
          //   mainAxisSize: MainAxisSize.min,
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: <Widget>[
          //     Container(
          //       decoration: BoxDecoration(
          //         shape: BoxShape.circle,
          //         color: activityColor.withOpacity(0.15),
          //       ),
          //       padding: const EdgeInsets.all(10),
          //       child: Icon(_activityIcon(), color: activityColor, size: 20),
          //     ),
          //     const SizedBox(width: 10),
          //     Container(
          //       decoration: BoxDecoration(
          //         shape: BoxShape.circle,
          //         color: activityColor.withOpacity(0.15),
          //       ),
          //       padding: const EdgeInsets.all(10),
          //       child: Icon(_activityIcon(), color: activityColor, size: 20),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
