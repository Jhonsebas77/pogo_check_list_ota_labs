part of com.pogo_check_list_ota_labs.app.views;

class WantedView extends StatelessWidget {
  const WantedView({super.key});

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
        body: const TabBarView(
          children: <Widget>[WantedPokemon(), OfferPokemon()],
        ),
      ),
    ),
  );
}
