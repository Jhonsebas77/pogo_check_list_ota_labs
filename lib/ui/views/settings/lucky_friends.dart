part of com.pogo_check_list_ota_labs.app.views;

class LuckyFriendsView extends ConsumerWidget {
  const LuckyFriendsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<PokemonFirebaseState> firebasePokemonState = ref.watch(
      firebasePokemonProvider,
    );
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    ScreenshotController screenshotController = ScreenshotController();
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Amistades con suerte',
          isTransparent: true,
        ),
        backgroundColor:
            isDarkMode ? null : Theme.of(context).colorScheme.primary,
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
                tooltip: 'Editar amistades',
                icon: Icon(
                  Icons.edit,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                onPressed:
                    () => CustomNavigator().push(
                      context,
                      const LuckyFriendsEditorView(),
                      animation: CustomNavigationAnimation.fade,
                    ),
              ),
            ),
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
        body: SafeArea(
          top: false,
          child: firebasePokemonState.when(
            data: (PokemonFirebaseState state) {
              List<LuckyFriend> _friendsInfo = state.allLuckyFriends;
              return SingleChildScrollView(
                child: Screenshot(
                  controller: screenshotController,
                  child: LuckyFriendsList(friends: _friendsInfo),
                ),
              );
            },
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
