part of com.pogo_check_list_ota_labs.app.views;

class WantedView extends StatelessWidget {
  const WantedView({super.key});

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
              return Center(
                child: Text('Error loading data: ${asyncSnapshot.error}'),
              );
            }
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (asyncSnapshot.hasData) {
              PokemonTrade tradeData = asyncSnapshot.data!;
              return TabBarView(
                children: <Widget>[
                  PokemonTradeList(pokemonList: tradeData.wantedPokemon),
                  PokemonTradeList(pokemonList: tradeData.offerPokemon),
                ],
              );
            }
            return const Center(child: Text('No data available.'));
          },
        ),
      ),
    ),
  );
}
