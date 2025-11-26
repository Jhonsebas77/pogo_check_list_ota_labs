part of com.pogo_check_list_ota_labs.app.views;

class WantedForTradeView extends ConsumerStatefulWidget {
  const WantedForTradeView({super.key});
  @override
  ConsumerState<WantedForTradeView> createState() => _WantedForTradeViewState();
}

class _WantedForTradeViewState extends ConsumerState<WantedForTradeView>
    with TickerProviderStateMixin {
  final Set<int> _legendaryIds =
      getLegendaryGroups().expand((List<int> group) => group).toSet();

  bool _showOnlyLegendary = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openTradeItemEditor(
    BuildContext context, {
    required PokemonTradeCategory category,
    PokemonTradeItem? item,
    int? index,
  }) {
    CustomNavigator().push(
      context,
      PokemonTradeItemEditorView(
        category: category,
        initialItem: item,
        initialIndex: index,
      ),
      animation: CustomNavigationAnimation.slideBottom,
    );
  }

  void _toggleLegendaryFilter() {
    setState(() {
      _showOnlyLegendary = !_showOnlyLegendary;
    });
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<PokemonFirebaseState> firebasePokemonState = ref.watch(
      firebasePokemonProvider,
    );
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    ScreenshotController screenshotController = ScreenshotController();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor:
            isDarkMode ? null : Theme.of(context).colorScheme.primary,
        body: NestedScrollView(
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) => <Widget>[
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  centerTitle: true,
                  title: const Text('Intercambios'),
                  systemOverlayStyle: getSystemOverlayStyle(context),
                  elevation: 0,
                  toolbarHeight: 82,
                  leading: const DexHeaderLeading(),
                  actions: const DexHeaderActions().getActions(),
                  bottom: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.transparent,
                    labelColor: Colors.white,
                    dividerColor: Colors.transparent,
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
                    tabs: const <Widget>[
                      Tab(icon: Icon(Icons.compare_arrows), text: 'Buscando'),
                      Tab(
                        icon: Icon(Icons.catching_pokemon),
                        text: 'Ofreciendo',
                      ),
                    ],
                  ),
                  expandedHeight: 150,
                ),
              ],
          body: Screenshot(
            controller: screenshotController,
            child: firebasePokemonState.when(
              data: (PokemonFirebaseState state) {
                PokemonTrade? tradeData = state.pokemonForTrade;
                if (tradeData == null) {
                  return const Center(child: EmptyState());
                }
                List<PokemonTradeItem> allWantedPokemon =
                    List<PokemonTradeItem>.from(tradeData.wantedPokemon);
                List<PokemonTradeItem> allOfferPokemon =
                    List<PokemonTradeItem>.from(tradeData.offerPokemon);
                List<int> wantedOrder = List<int>.generate(
                  allWantedPokemon.length,
                  (int index) => index,
                )..sort(
                  (int a, int b) => (allWantedPokemon[a].id ?? 0).compareTo(
                    allWantedPokemon[b].id ?? 0,
                  ),
                );
                List<int> offerOrder = List<int>.generate(
                  allOfferPokemon.length,
                  (int index) => index,
                )..sort(
                  (int a, int b) => (allOfferPokemon[a].id ?? 0).compareTo(
                    allOfferPokemon[b].id ?? 0,
                  ),
                );
                if (_showOnlyLegendary) {
                  wantedOrder =
                      wantedOrder
                          .where(
                            (int index) => _legendaryIds.contains(
                              allWantedPokemon[index].id,
                            ),
                          )
                          .toList();
                  offerOrder =
                      offerOrder
                          .where(
                            (int index) => _legendaryIds.contains(
                              allOfferPokemon[index].id,
                            ),
                          )
                          .toList();
                }
                List<PokemonTradeItem> wantedPokemon =
                    wantedOrder
                        .map((int index) => allWantedPokemon[index])
                        .toList();
                List<PokemonTradeItem> offerPokemon =
                    offerOrder
                        .map((int index) => allOfferPokemon[index])
                        .toList();
                return TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    PokemonTradeList(
                      pokemonList: wantedPokemon,
                      type: 'Buscando',
                      originalIndices: wantedOrder,
                      onLongPressEdit:
                          (int index, PokemonTradeItem item) =>
                              _openTradeItemEditor(
                                context,
                                category: PokemonTradeCategory.wanted,
                                item: item,
                                index: index,
                              ),
                    ),
                    PokemonTradeList(
                      pokemonList: offerPokemon,
                      type: 'Ofreciendo',
                      originalIndices: offerOrder,
                      onLongPressEdit:
                          (int index, PokemonTradeItem item) =>
                              _openTradeItemEditor(
                                context,
                                category: PokemonTradeCategory.offer,
                                item: item,
                                index: index,
                              ),
                    ),
                  ],
                );
              },
              error:
                  (Object error, StackTrace stackTrace) =>
                      const SimpleErrorChip(
                        iconData: Icons.catching_pokemon,
                        text:
                            'Con la información de los Pokemon a intercambiar',
                      ),
              loading:
                  () => const Center(
                    child: Icon(
                      Icons.catching_pokemon_outlined,
                      color: Colors.grey,
                      size: 50,
                    ),
                  ),
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
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
                        'trade-offer-pokemon',
                        context,
                      );
                },
              ),
            ),
            const SizedBox(width: 4),
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: IconButton(
                tooltip: 'Agregar Pokémon',
                icon: Icon(
                  Icons.add,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                onPressed: () {
                  PokemonTradeCategory category =
                      (_tabController.index == 0)
                          ? PokemonTradeCategory.wanted
                          : PokemonTradeCategory.offer;

                  _openTradeItemEditor(context, category: category);
                },
              ),
            ),
            const SizedBox(width: 4),
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: IconButton(
                icon: Icon(
                  _showOnlyLegendary
                      ? Icons.auto_awesome
                      : Icons.auto_awesome_outlined,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                tooltip:
                    _showOnlyLegendary
                        ? 'Mostrar todos los Pokémon'
                        : 'Mostrar solo legendarios',
                onPressed: _toggleLegendaryFilter,
              ),
            ),
            const SizedBox(width: 4),
            if (!kIsWeb)
              Tooltip(
                verticalOffset: 24,
                constraints: const BoxConstraints(maxWidth: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.black87,
                ),
                showDuration: const Duration(seconds: 5),
                preferBelow: true,
                triggerMode: TooltipTriggerMode.tap,
                richMessage: const WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: InformationTradeCard(),
                ),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
