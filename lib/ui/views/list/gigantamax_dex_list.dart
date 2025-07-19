part of com.pogo_check_list_ota_labs.app.views;

class GigantamaxPokemonView extends StatefulWidget {
  const GigantamaxPokemonView({super.key});
  static const String route = '/pokemon/gigantamax-dex';

  @override
  State<GigantamaxPokemonView> createState() => _GigantamaxPokemonViewState();
}

class _GigantamaxPokemonViewState extends State<GigantamaxPokemonView> {
  bool displayOnlyMissingPokemon = false;
  final ScrollController _scrollController = ScrollController();
  bool isInTheEndOfTheList = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      toolbarHeight: 82,
      title: const HeaderFromImage(title: 'Gigantamax'),
      elevation: 0,
    ),
    backgroundColor: const Color.fromRGBO(198, 73, 52, 1),
  );
}
