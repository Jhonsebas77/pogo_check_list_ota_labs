part of com.pogo_check_list_ota_labs.app.views;

class LuckyFriendsView extends ConsumerWidget {
  const LuckyFriendsView({super.key});
  static const String route = '/settings/lucky-friends';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<PokemonFirebaseState> firebasePokemonState = ref.watch(
      firebasePokemonProvider,
    );
    ScreenshotController screenshotController = ScreenshotController();
    void openEditor({LuckyFriend? friend, int? index}) {
      CustomNavigator().push(
        context,
        LuckyFriendEditorView(initialFriend: friend, initialIndex: index),
        routeName: '${LuckyFriendEditorView.route}/${index ?? 'new'}',
        animation: CustomNavigationAnimation.fade,
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Amistades con suerte',
          isTransparent: true,
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Chip(
              label: Text(
                '''${firebasePokemonState.value?.allLuckyFriends.length ?? 0} Amigos con suerte''',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              visualDensity: VisualDensity.compact,
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(width: 4),
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: IconButton(
                tooltip: 'Agregar amistad',
                icon: Icon(
                  Icons.person_add_alt_1,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                onPressed: openEditor,
              ),
            ),
            const SizedBox(width: 4),
            const SizedBox(width: 4),
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: IconButton(
                tooltip: 'Tomar screenshot',
                icon: Icon(
                  Icons.screenshot,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                onPressed: () {
                  ref
                      .read(screenShotViewModelNotifier.notifier)
                      .captureAndSaveInGallery(
                        screenshotController,
                        'lucky-friends',
                        context,
                      );
                },
              ),
            ),
          ],
        ),
        body: WebContent(
          child: SafeArea(
            top: false,
            child: firebasePokemonState.when(
              data: (PokemonFirebaseState state) {
                List<LuckyFriend> _friendsInfo = state.allLuckyFriends;
                return SingleChildScrollView(
                  child: Screenshot(
                    controller: screenshotController,
                    child: LuckyFriendsList(
                      friends: _friendsInfo,
                      onLongPressEdit:
                          (int index, LuckyFriend friend) =>
                              openEditor(friend: friend, index: index),
                    ),
                  ),
                );
              },
              error:
                  (Object error, StackTrace stackTrace) =>
                      const SimpleErrorChip(
                        iconData: Icons.people,
                        text: 'Con la información de tus amigos con suerte',
                      ),
              loading: () => const Center(child: SimpleTextShimmer()),
            ),
          ),
        ),
      ),
    );
  }
}
