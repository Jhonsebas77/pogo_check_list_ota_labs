part of com.pogo_check_list_ota_labs.app.views;

class TypeChartView extends StatefulWidget {
  const TypeChartView({super.key});

  @override
  State<TypeChartView> createState() => _TypeChartViewState();
}

const Map<String, Color> _typeColors = <String, Color>{
  'normal': Color(0xFFA8A77A),
  'fire': Color(0xFFEE8130),
  'water': Color(0xFF6390F0),
  'electric': Color(0xFFF7D02C),
  'grass': Color(0xFF7AC74C),
  'ice': Color(0xFF96D9D6),
  'fighting': Color(0xFFC22E28),
  'poison': Color(0xFFA33EA1),
  'ground': Color(0xFFE2BF65),
  'flying': Color(0xFFA98FF3),
  'psychic': Color(0xFFF95587),
  'bug': Color(0xFFA6B91A),
  'rock': Color(0xFFB6A136),
  'ghost': Color(0xFF735797),
  'dragon': Color(0xFF6F35FC),
  'dark': Color(0xFF705746),
  'steel': Color(0xFFB7B7CE),
  'fairy': Color(0xFFD685AD),
};

const Map<String, IconData> _typeIcons = <String, IconData>{
  'normal': Icons.star_outline,
  'fire': Icons.local_fire_department,
  'water': Icons.water_drop,
  'electric': Icons.bolt,
  'grass': Icons.eco,
  'ice': Icons.ac_unit,
  'fighting': Icons.sports_mma,
  'poison': Icons.biotech,
  'ground': Icons.terrain,
  'flying': Icons.air,
  'psychic': Icons.psychology,
  'bug': Icons.bug_report,
  'rock': Icons.landscape,
  'ghost': Icons.nightlight,
  'dragon': Icons.auto_awesome,
  'dark': Icons.dark_mode,
  'steel': Icons.build,
  'fairy': Icons.auto_fix_high,
};

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
        body: Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: _buildTypeGradient(selectedTypes),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    color: Colors.black.withOpacity(0.35),
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
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children:
                                selectedTypes
                                    .map(
                                      (String type) => _TypeBadge(
                                        type: type,
                                        color: _typeColors[type] ?? Colors.grey,
                                        icon:
                                            _typeIcons[type] ??
                                            Icons.help_outline,
                                      ),
                                    )
                                    .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _TypeSection(
                    title: 'Inmunidades',
                    matchups: effectiveness.immunities,
                  ),
                  const SizedBox(height: 24),
                  _TypeSection(
                    title: 'Debilidades',
                    matchups: effectiveness.weaknesses,
                  ),
                  const SizedBox(height: 24),
                  _TypeSection(
                    title: 'Fortalezas',
                    matchups: effectiveness.resistances,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Gradient _buildTypeGradient(List<String> types) {
    Color primary = _typeColors[types.first] ?? Colors.grey;
    if (types.length == 1) {
      return LinearGradient(
        colors: <Color>[primary.withOpacity(0.85), primary.withOpacity(0.65)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    Color secondary = _typeColors[types.last] ?? Colors.grey;
    return LinearGradient(
      colors: <Color>[primary.withOpacity(0.85), secondary.withOpacity(0.85)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}

class _TypeSection extends StatelessWidget {
  const _TypeSection({required this.title, required this.matchups});

  final String title;
  final List<TypeMatchup> matchups;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Card(
      color: Colors.white.withOpacity(0.88),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (matchups.isEmpty)
              Text('Ninguna', style: theme.textTheme.bodyMedium)
            else
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: matchups.map(_TypeMatchupChip.new).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({
    required this.type,
    required this.color,
    required this.icon,
  });

  final String type;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Chip(
    backgroundColor: color.withOpacity(0.9),
    avatar: CircleAvatar(
      backgroundColor: Colors.white.withOpacity(0.25),
      child: Icon(icon, color: Colors.white),
    ),
    label: Text(
      type.toUpperCase(),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );
}

class _TypeMatchupChip extends StatelessWidget {
  const _TypeMatchupChip(this.matchup);

  final TypeMatchup matchup;

  @override
  Widget build(BuildContext context) {
    Color baseColor = _typeColors[matchup.type] ?? Colors.grey;
    IconData icon = _typeIcons[matchup.type] ?? Icons.help_outline;

    return Chip(
      backgroundColor: baseColor.withOpacity(0.9),
      avatar: CircleAvatar(
        backgroundColor: Colors.white.withOpacity(0.25),
        child: Icon(icon, color: Colors.white),
      ),
      label: Text(
        '${matchup.type.toUpperCase()} · ${_formatMultiplier(matchup.multiplier)}x',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatMultiplier(double multiplier) {
    if (multiplier == multiplier.roundToDouble()) {
      return multiplier.toStringAsFixed(0);
    }
    if (multiplier < 1) {
      String formatted = multiplier.toStringAsFixed(2);
      return formatted.endsWith('0')
          ? formatted.substring(0, formatted.length - 1)
          : formatted;
    }
    return multiplier.toStringAsFixed(1);
  }
}
