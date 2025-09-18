part of com.pogo_check_list_ota_labs.app.views;

class TypeChartView extends StatefulWidget {
  const TypeChartView({super.key});

  @override
  State<TypeChartView> createState() => _TypeChartViewState();
}

class _TypeChartViewState extends State<TypeChartView> {
  String _type1 = kPokemonTypes.first;
  String? _type2;

  @override
  Widget build(BuildContext context) {
    List<String> selectedTypes = <String>[_type1];
    if (_type2 != null) {
      selectedTypes.add(_type2!);
    }
    TypeEffectiveness effectiveness = getTypeEffectiveness(selectedTypes);
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Tabla de tipos',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          leading: const DexHeaderLeading(),
          actions: const DexHeaderActions().getActions(),
        ),
        backgroundColor:
            isDarkMode ? null : Theme.of(context).colorScheme.primary,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  color: Colors.black.withValues(alpha: 0.35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: DropdownButton<String>(
                                value: _type1,
                                dropdownColor: Colors.grey.shade900,
                                iconEnabledColor: Colors.white,
                                iconDisabledColor: Colors.white54,
                                style: const TextStyle(color: Colors.white),
                                items:
                                    kPokemonTypes
                                        .map(
                                          (String t) =>
                                              DropdownMenuItem<String>(
                                                value: t,
                                                child: Text(
                                                  t.toUpperCase(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                        )
                                        .toList(),
                                onChanged: (String? value) {
                                  if (value != null) {
                                    setState(() => _type1 = value);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: DropdownButton<String?>(
                                value: _type2,
                                dropdownColor: Colors.grey.shade900,
                                iconEnabledColor: Colors.white,
                                iconDisabledColor: Colors.white54,
                                style: const TextStyle(color: Colors.white),
                                hint: const Text(
                                  'Tipo 2',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                items:
                                    <String?>[null, ...kPokemonTypes]
                                        .map(
                                          (String? t) =>
                                              DropdownMenuItem<String?>(
                                                value: t,
                                                child: Text(
                                                  t?.toUpperCase() ?? 'Ninguno',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                        )
                                        .toList(),
                                onChanged:
                                    (String? value) =>
                                        setState(() => _type2 = value),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children:
                                selectedTypes
                                    .map(
                                      (String type) => TypeBadge(
                                        type: type,
                                        color: kTypeColors[type] ?? Colors.grey,
                                        icon:
                                            kTypeIcons[type] ??
                                            Icons.help_outline,
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: _buildTypeGradient(selectedTypes),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all( 8),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height * 0.1,
                        ),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TypeSection(
                                title: 'Inmunidades',
                                matchup: effectiveness.immunities,
                              ),
                              const SizedBox(height: 8),
                              TypeSection(
                                title: 'Debilidades',
                                matchup: effectiveness.weaknesses,
                              ),
                              const SizedBox(height: 8),
                              TypeSection(
                                title: 'Fortalezas',
                                matchup: effectiveness.resistances,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Gradient _buildTypeGradient(List<String> types) {
    Color primary = kTypeColors[types.first] ?? Colors.grey;
    if (types.length == 1) {
      return LinearGradient(
        colors: <Color>[
          primary.withValues(alpha: 0.85),
          primary.withValues(alpha: 0.65),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    Color secondary = kTypeColors[types.last] ?? Colors.grey;
    return LinearGradient(
      colors: <Color>[
        primary.withValues(alpha: 0.85),
        secondary.withValues(alpha: 0.85),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
