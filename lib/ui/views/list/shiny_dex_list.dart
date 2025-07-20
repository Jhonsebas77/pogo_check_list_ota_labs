part of com.pogo_check_list_ota_labs.app.views;

class ShinyPokemonView extends StatefulWidget {
  const ShinyPokemonView({super.key});
  static const String route = '/pokemon/shiny-dex';

  @override
  State<ShinyPokemonView> createState() => _ShinyPokemonViewState();
}

class _ShinyPokemonViewState extends State<ShinyPokemonView> {
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

  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
    );
    isInTheEndOfTheList = true;
    setState(() {});
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
    );
    isInTheEndOfTheList = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        toolbarHeight: 82,
        leading: const DexHeaderLeading(),
        actions: const DexHeaderActions().getActions(),
        elevation: 0,
      ),
      backgroundColor: const Color.fromRGBO(198, 73, 52, 1),
      floatingActionButton: FloatingActionButton(
        onPressed: isInTheEndOfTheList ? _scrollToTop : _scrollToEnd,
        backgroundColor: Colors.indigo,
        child: Icon(
          isInTheEndOfTheList ? Icons.arrow_upward : Icons.arrow_downward,
        ),
      ),
    ),
  );
}
