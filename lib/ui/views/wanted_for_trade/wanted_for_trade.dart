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
      backgroundColor: const Color.fromRGBO(198, 73, 52, 1),
      body: NestedScrollView(
        headerSliverBuilder:
            (BuildContext context, bool innerBoxIsScrolled) => <Widget>[
              SliverAppBar(
                systemOverlayStyle: SystemUiOverlayStyle.light,
                pinned: true,
                floating: true,
                toolbarHeight: 82,
                centerTitle: true,
                title: const Text(
                  'Intercambios',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                leading: const DexHeaderLeading(),
                actions: const DexHeaderActions().getActions(),
                backgroundColor: const Color.fromRGBO(198, 73, 52, 1),
                bottom: TabBar(
                  tabs: const <Widget>[
                    Tab(
                      icon: Icon(Icons.wifi_protected_setup_sharp),
                      text: 'Quiero',
                    ),
                    Tab(icon: Icon(Icons.catching_pokemon), text: 'Ofreciendo'),
                  ],
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.white70,
                  indicatorPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: const Color.fromRGBO(198, 73, 52, 1),
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
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.black45,
          ),
          showDuration: const Duration(seconds: 5),
          preferBelow: true,
          triggerMode: TooltipTriggerMode.tap,
          richMessage: const WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: InformationTradeCard(),
          ),
          child: const CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(Icons.info_outline, size: 16, color: Colors.white),
          ),
        ),
      ),
    ),
  );
}
