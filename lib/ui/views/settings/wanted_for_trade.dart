part of com.pogo_check_list_ota_labs.app.views;

class WantedForTradeView extends StatelessWidget {
  const WantedForTradeView({super.key});

  Future<PokemonTrade> loadTradeData() async {
    String jsonString = await rootBundle.loadString('assets/mocks/trade.json');
    Map<String, dynamic>? jsonMap =
        jsonDecode(jsonString) as Map<String, dynamic>;
    return PokemonTrade.fromJson(jsonMap);
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
                  systemOverlayStyle: SystemUiOverlayStyle.light,
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
                      Tab(
                        icon: Icon(Icons.wifi_protected_setup_sharp),
                        text: 'Buscando',
                      ),
                      Tab(
                        icon: Icon(Icons.catching_pokemon),
                        text: 'Ofreciendo',
                      ),
                    ],
                  ),
                  expandedHeight: 150,
                ),
              ],
          body: FutureBuilder<PokemonTrade>(
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
                return const SimpleTextShimmer();
              }
              if (asyncSnapshot.hasData) {
                PokemonTrade tradeData = asyncSnapshot.data!;
                List<PokemonTradeItem> _wantedPokemon =
                    tradeData.wantedPokemon..sort(
                      (PokemonTradeItem a, PokemonTradeItem b) =>
                          a.id.compareTo(b.id),
                    );
                List<PokemonTradeItem> _offerPokemon =
                    tradeData.offerPokemon..sort(
                      (PokemonTradeItem a, PokemonTradeItem b) =>
                          a.id.compareTo(b.id),
                    );
                return TabBarView(
                  children: <Widget>[
                    PokemonTradeList(pokemonList: _wantedPokemon),
                    PokemonTradeList(pokemonList: _offerPokemon),
                  ],
                );
              }
              return const Center(child: Text('No data available.'));
            },
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8),
          child: Tooltip(
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
        ),
      ),
    );
  }
}
