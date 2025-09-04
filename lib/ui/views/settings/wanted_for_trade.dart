part of com.pogo_check_list_ota_labs.app.views;

class WantedForTradeView extends StatelessWidget {
  const WantedForTradeView({super.key});

  Future<PokemonTrade> loadTradeData() async {
    String jsonString = await rootBundle.loadString('assets/mocks/trade.json');
    Map<String, dynamic>? jsonMap = jsonDecode(jsonString);
    return PokemonTrade.fromJson(jsonMap!);
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: NestedScrollView(
        headerSliverBuilder:
            (BuildContext context, bool innerBoxIsScrolled) => <Widget>[
              SliverAppBar(
                systemOverlayStyle: SystemUiOverlayStyle.light,
                pinned: true,
                floating: true,
                toolbarHeight: 82,
                centerTitle: true,
                title: Text(
                  'Intercambios',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                leading: const DexHeaderLeading(),
                actions: const DexHeaderActions().getActions(),
                backgroundColor: Theme.of(context).colorScheme.primary,
                bottom: TabBar(
                  tabs: const <Widget>[
                    Tab(
                      icon: Icon(Icons.wifi_protected_setup_sharp),
                      text: 'Quiero',
                    ),
                    Tab(icon: Icon(Icons.catching_pokemon), text: 'Ofreciendo'),
                  ],
                  indicator: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelColor: Theme.of(context).colorScheme.onSecondary,
                  unselectedLabelColor: Colors.white70,
                  indicatorPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Theme.of(context).colorScheme.primary,
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
            color: Theme.of(context).colorScheme.primaryContainer,
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
