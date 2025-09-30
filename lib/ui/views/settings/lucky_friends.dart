part of com.pogo_check_list_ota_labs.app.views;

class LuckyFriendsView extends ConsumerWidget {
  const LuckyFriendsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<LuckyFriend>> luckyFriends = ref.watch(
      luckyFriendsProvider,
    );
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Amistades con suerte'),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          elevation: 0,
          toolbarHeight: 82,
          leading: const DexHeaderLeading(),
          actions: const DexHeaderActions().getActions(),
        ),
        backgroundColor:
            isDarkMode ? null : Theme.of(context).colorScheme.primary,
        floatingActionButton: FloatingActionButton(
          mini: true,
          onPressed: () {},
          child: Text('${luckyFriends.value?.length ?? 0}'),
        ),
        body: SafeArea(
          top: false,
          child: luckyFriends.when(
            data:
                (List<LuckyFriend> friends) =>
                    _LuckyFriendsBody(friends: friends),
            error:
                (Object error, StackTrace stackTrace) => const SimpleErrorChip(
                  iconData: Icons.people,
                  text: 'Con la información de tus amigos con suerte',
                ),
            loading: () => const Center(child: SimpleTextShimmer()),
          ),
        ),
      ),
    );
  }
}

class _LuckyFriendsBody extends StatelessWidget {
  const _LuckyFriendsBody({required this.friends});

  final List<LuckyFriend> friends;

  @override
  Widget build(BuildContext context) {
    if (friends.isEmpty) {
      return const EmptyState();
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      children: <Widget>[
        ...friends.map(
          (LuckyFriend friend) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: LuckyFriendListTile(friend: friend),
          ),
        ),
      ],
    );
  }
}
