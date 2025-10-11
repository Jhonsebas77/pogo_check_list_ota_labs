part of com.pogo_check_list_ota_labs.app.views;

class WantedForTradeView extends ConsumerStatefulWidget {
  const WantedForTradeView({super.key});
  @override
  ConsumerState<WantedForTradeView> createState() => _WantedForTradeViewState();
}

class _WantedForTradeViewState extends ConsumerState<WantedForTradeView> {
  final Set<int> _legendaryIds =
      getLegendaryGroups().expand((List<int> group) => group).toSet();

  bool _showOnlyLegendary = false;
  Future<PokemonTrade> loadTradeData() async {
    String jsonString = await rootBundle.loadString('assets/mocks/trade.json');
    Map<String, dynamic>? jsonMap =
        jsonDecode(jsonString) as Map<String, dynamic>;
    return PokemonTrade.fromJson(jsonMap);
  }

  void _toggleLegendaryFilter() {
    setState(() {
      _showOnlyLegendary = !_showOnlyLegendary;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  systemOverlayStyle: SystemUiOverlayStyle.dark,
                  elevation: 0,
                  toolbarHeight: 82,
                  leading: const DexHeaderLeading(),
                  actions: const DexHeaderActions().getActions(),
                  bottom: TabBar(
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
            child: FutureBuilder<PokemonTrade>(
              future: loadTradeData(),
              builder: (
                BuildContext context,
                AsyncSnapshot<PokemonTrade> asyncSnapshot,
              ) {
                if (asyncSnapshot.hasError) {
                  return const SimpleErrorChip(
                    iconData: Icons.catching_pokemon,
                    text: 'Con la información de los Pokemon a intercambiar',
                  );
                }
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Icon(
                      Icons.catching_pokemon_outlined,
                      color: Colors.grey,
                      size: 50,
                    ),
                  );
                }
                if (asyncSnapshot.hasData) {
                  PokemonTrade tradeData = asyncSnapshot.data!;
                  List<PokemonTradeItem> wantedPokemon =
                      List<PokemonTradeItem>.from(tradeData.wantedPokemon)
                        ..sort(
                          (PokemonTradeItem a, PokemonTradeItem b) =>
                              a.id.compareTo(b.id),
                        );
                  List<PokemonTradeItem> offerPokemon =
                      List<PokemonTradeItem>.from(tradeData.offerPokemon)..sort(
                        (PokemonTradeItem a, PokemonTradeItem b) =>
                            a.id.compareTo(b.id),
                      );
                  if (_showOnlyLegendary) {
                    wantedPokemon =
                        wantedPokemon
                            .where(
                              (PokemonTradeItem pokemon) =>
                                  _legendaryIds.contains(pokemon.id),
                            )
                            .toList();
                    offerPokemon =
                        offerPokemon
                            .where(
                              (PokemonTradeItem pokemon) =>
                                  _legendaryIds.contains(pokemon.id),
                            )
                            .toList();
                  }
                  return TabBarView(
                    children: <Widget>[
                      PokemonTradeList(
                        pokemonList: wantedPokemon,
                        type: 'Buscando',
                      ),
                      PokemonTradeList(
                        pokemonList: offerPokemon,
                        type: 'Ofreciendo',
                      ),
                    ],
                  );
                }
                return const Center(child: Text('No data available.'));
              },
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
