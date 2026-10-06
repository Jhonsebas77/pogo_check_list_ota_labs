part of com.pogo_check_list_ota_labs.app.models;

class PokemonDetail {
  PokemonDetail({
    required this.name,
    required this.id,
    required this.imageUrl,
    required this.types,
    this.shinyImageUrl,
    this.height = 0,
    this.weight = 0,
    this.abilities = const <PokemonAbility>[],
    this.stats = const <PokemonStat>[],
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    String name = json['name'] as String;
    String capitalizedName = name[0].toUpperCase() + name.substring(1);

    Map<String, dynamic> artwork =
        json['sprites']['other']['official-artwork'] as Map<String, dynamic>;

    List<String> typesList =
        (json['types'] as List<dynamic>)
            .map((dynamic typeInfo) => typeInfo['type']['name'] as String)
            .toList();

    return PokemonDetail(
      name: capitalizedName,
      id: json['id'] as int,
      imageUrl: artwork['front_default'] as String,
      shinyImageUrl: artwork['front_shiny'] as String?,
      types: typesList,
      height: json['height'] as int? ?? 0,
      weight: json['weight'] as int? ?? 0,
      abilities:
          (json['abilities'] as List<dynamic>? ?? <dynamic>[])
              .map(
                (dynamic ability) =>
                    PokemonAbility.fromJson(ability as Map<String, dynamic>),
              )
              .toList(),
      stats:
          (json['stats'] as List<dynamic>? ?? <dynamic>[])
              .map(
                (dynamic stat) =>
                    PokemonStat.fromJson(stat as Map<String, dynamic>),
              )
              .toList(),
    );
  }
  final String name;
  final int id;
  final String imageUrl;
  final String? shinyImageUrl;
  final List<String> types;

  /// Altura en decímetros, como la entrega la API.
  final int height;

  /// Peso en hectogramos, como lo entrega la API.
  final int weight;
  final List<PokemonAbility> abilities;
  final List<PokemonStat> stats;

  double get heightInMeters => height / 10;
  double get weightInKg => weight / 10;
  int get totalStats =>
      stats.fold(0, (int total, PokemonStat stat) => total + stat.baseStat);
}

class PokemonAbility {
  const PokemonAbility({required this.name, this.isHidden = false});

  factory PokemonAbility.fromJson(Map<String, dynamic> json) => PokemonAbility(
    name: json['ability']['name'] as String,
    isHidden: json['is_hidden'] as bool? ?? false,
  );

  /// Nombre en inglés tal como lo entrega la API (`solar-power`).
  final String name;
  final bool isHidden;

  /// `solar-power` → `Solar Power`. Traducirlo exige una llamada extra por
  /// habilidad a `/ability/{name}`, así que se muestra en inglés.
  String get displayName => name
      .split('-')
      .map((String word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');
}

class PokemonStat {
  const PokemonStat({required this.name, required this.baseStat});

  factory PokemonStat.fromJson(Map<String, dynamic> json) => PokemonStat(
    name: json['stat']['name'] as String,
    baseStat: json['base_stat'] as int? ?? 0,
  );

  /// Nombre en inglés tal como lo entrega la API (`special-attack`).
  final String name;
  final int baseStat;

  static const Map<String, String> _labels = <String, String>{
    'hp': 'PS',
    'attack': 'Ataque',
    'defense': 'Defensa',
    'special-attack': 'At. Esp.',
    'special-defense': 'Def. Esp.',
    'speed': 'Velocidad',
  };

  String get label => _labels[name] ?? name;
}

/// Datos de `/pokemon-species/{id}`: categoría y descripción de la Pokédex.
class PokemonSpecies {
  const PokemonSpecies({this.genus, this.flavorText, this.evolutionChainUrl});

  factory PokemonSpecies.fromJson(Map<String, dynamic> json) {
    String? genus = _localized(
      json['genera'] as List<dynamic>? ?? <dynamic>[],
      'genus',
    );
    String? flavorText = _localized(
      (json['flavor_text_entries'] as List<dynamic>? ?? <dynamic>[]).reversed
          .toList(),
      'flavor_text',
    );
    return PokemonSpecies(
      genus: genus,
      // La API trae saltos de línea y form feeds de los juegos originales.
      flavorText: flavorText?.replaceAll(RegExp(r'[\n\f\r]+'), ' ').trim(),
      evolutionChainUrl: json['evolution_chain']?['url'] as String?,
    );
  }

  final String? genus;
  final String? flavorText;
  final String? evolutionChainUrl;

  /// Primer valor de [field] en español, o en inglés si no existe.
  static String? _localized(List<dynamic> entries, String field) {
    String? english;
    for (dynamic entry in entries) {
      String language = entry['language']['name'] as String;
      if (language == 'es') return entry[field] as String;
      if (language == 'en') english ??= entry[field] as String;
    }
    return english;
  }
}

/// Nodo de `/evolution-chain/{id}`: una especie y las que evolucionan de ella.
///
/// La cadena de la API es por especie; las formas regionales que evolucionan
/// distinto (Meowth de Galar → Perrserker) vienen en [links]. Para mostrarlas
/// se usa [formRoots].
class EvolutionNode {
  const EvolutionNode({
    required this.id,
    required this.name,
    this.evolvesTo = const <EvolutionNode>[],
    this.links = const <EvolutionFormLink>[],
  });

  factory EvolutionNode.fromJson(
    Map<String, dynamic> json, {
    String? parentName,
  }) {
    String url = json['species']['url'] as String;
    String name = json['species']['name'] as String;
    Set<EvolutionFormLink> links = <EvolutionFormLink>{
      if (parentName != null)
        for (dynamic detail
            in json['evolution_details'] as List<dynamic>? ?? <dynamic>[])
          EvolutionFormLink(
            from: _formSuffix(detail['required_pokemon_form'], parentName),
            to: _formSuffix(detail['evolved_pokemon_form'], name),
          ),
    };
    return EvolutionNode(
      // `.../pokemon-species/133/` → 133
      id: int.parse(url.split('/').where((String s) => s.isNotEmpty).last),
      name: _capitalize(name),
      evolvesTo:
          (json['evolves_to'] as List<dynamic>? ?? <dynamic>[])
              .map(
                (dynamic node) => EvolutionNode.fromJson(
                  node as Map<String, dynamic>,
                  parentName: name,
                ),
              )
              .toList(),
      links:
          links.isEmpty && parentName != null
              ? const <EvolutionFormLink>[EvolutionFormLink()]
              : links.toList(),
    );
  }

  final int id;
  final String name;
  final List<EvolutionNode> evolvesTo;

  /// Formas de la especie anterior y de esta que participan en la evolución.
  final List<EvolutionFormLink> links;

  /// Una línea evolutiva por cada forma de origen (normal, Alola, Galar…),
  /// con la forma normal primero. La forma normal de la especie base siempre
  /// aparece, aunque no evolucione.
  List<EvolutionForm> get formRoots {
    Map<String, EvolutionForm> nodes = <String, EvolutionForm>{};
    Set<String> withParent = <String>{};

    EvolutionForm nodeFor(EvolutionNode species, String form) =>
        nodes.putIfAbsent(
          '${species.id}-$form',
          () => EvolutionForm(id: species.id, name: species.name, form: form),
        );

    void visit(EvolutionNode parent) {
      for (EvolutionNode child in parent.evolvesTo) {
        for (EvolutionFormLink link in child.links) {
          EvolutionForm from = nodeFor(parent, link.from);
          EvolutionForm to = nodeFor(child, link.to);
          if (!from.evolvesTo.contains(to)) from.evolvesTo.add(to);
          withParent.add('${to.id}-${to.form}');
        }
        visit(child);
      }
    }

    visit(this);
    // Si solo evoluciona una forma regional (Farfetch'd de Galar), la forma
    // normal se agrega sola para dejar claro que esa no evoluciona.
    nodeFor(this, '');
    List<EvolutionForm> roots =
        nodes.entries
            .where(
              (MapEntry<String, EvolutionForm> e) =>
                  !withParent.contains(e.key),
            )
            .map((MapEntry<String, EvolutionForm> e) => e.value)
            .toList();
    // Normal primero; las regionales conservan el orden de la API.
    return <EvolutionForm>[
      ...roots.where((EvolutionForm root) => root.form.isEmpty),
      ...roots.where((EvolutionForm root) => root.form.isNotEmpty),
    ];
  }

  /// Formas que la API nombra pero que en la app son la forma normal de la
  /// especie (sin `alternative_form`): Lycanroc Diurno, Toxtricity Aguda,
  /// Maushold familia de cuatro, Dudunsparce binodular. También las
  /// variantes de sexo (Basculegion), que comparten sprite.
  static const Set<String> _defaultForms = <String>{
    'male',
    'female',
    'midday',
    'amped',
    'family_of_four',
    'two_segment',
  };

  /// Sufijo de la forma en el formato de la app: `meowth-galar` → `galar`,
  /// `basculin-white-striped` → `white_striped`. Vacío para la forma normal
  /// (ver [_defaultForms]).
  static String _formSuffix(dynamic form, String speciesName) {
    if (form == null) return '';
    String name = form['name'] as String;
    String suffix =
        name.startsWith('$speciesName-')
            ? name.substring(speciesName.length + 1)
            : name == speciesName
            ? ''
            : name;
    suffix = suffix.replaceAll('-', '_');
    return _defaultForms.contains(suffix) ? '' : suffix;
  }

  /// `mr-mime` → `Mr Mime`. Respaldo cuando la especie no está en Firebase.
  static String _capitalize(String name) => name
      .split('-')
      .map((String word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');
}

/// Forma de origen y de destino de una evolución (vacío = forma normal).
class EvolutionFormLink {
  const EvolutionFormLink({this.from = '', this.to = ''});

  final String from;
  final String to;

  @override
  bool operator ==(Object other) =>
      other is EvolutionFormLink && other.from == from && other.to == to;

  @override
  int get hashCode => Object.hash(from, to);
}

/// Especie en una forma concreta dentro de una línea evolutiva.
class EvolutionForm {
  EvolutionForm({required this.id, required this.name, this.form = ''});

  final int id;
  final String name;

  /// Sufijo de la forma (`alola`, `galar`…), vacío para la forma normal.
  final String form;
  final List<EvolutionForm> evolvesTo = <EvolutionForm>[];
}
