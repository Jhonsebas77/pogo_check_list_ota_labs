library com.pogo_check_list_ota_labs.app.type_chart;

class TypeMatchup {
  const TypeMatchup({required this.type, required this.multiplier});

  final String type;
  final double multiplier;
}

class TypeEffectiveness {
  const TypeEffectiveness({
    required this.weaknesses,
    required this.resistances,
    required this.immunities,
  });

  final List<TypeMatchup> weaknesses;
  final List<TypeMatchup> resistances;
  final List<TypeMatchup> immunities;
}

const List<String> kPokemonTypes = <String>[
  'normal',
  'fire',
  'water',
  'electric',
  'grass',
  'ice',
  'fighting',
  'poison',
  'ground',
  'flying',
  'psychic',
  'bug',
  'rock',
  'ghost',
  'dragon',
  'dark',
  'steel',
  'fairy',
];

const Map<String, Map<String, double>> kTypeChart =
    <String, Map<String, double>>{
      'normal': <String, double>{'rock': 0.5, 'ghost': 0, 'steel': 0.5},
      'fire': <String, double>{
        'fire': 0.5,
        'water': 0.5,
        'grass': 2,
        'ice': 2,
        'bug': 2,
        'rock': 0.5,
        'dragon': 0.5,
        'steel': 2,
      },
      'water': <String, double>{
        'fire': 2,
        'water': 0.5,
        'grass': 0.5,
        'ground': 2,
        'rock': 2,
        'dragon': 0.5,
      },
      'electric': <String, double>{
        'water': 2,
        'electric': 0.5,
        'grass': 0.5,
        'ground': 0,
        'flying': 2,
        'dragon': 0.5,
      },
      'grass': <String, double>{
        'fire': 0.5,
        'water': 2,
        'grass': 0.5,
        'poison': 0.5,
        'ground': 2,
        'flying': 0.5,
        'bug': 0.5,
        'rock': 2,
        'dragon': 0.5,
        'steel': 0.5,
      },
      'ice': <String, double>{
        'fire': 0.5,
        'water': 0.5,
        'grass': 2,
        'ice': 0.5,
        'ground': 2,
        'flying': 2,
        'dragon': 2,
        'steel': 0.5,
      },
      'fighting': <String, double>{
        'normal': 2,
        'ice': 2,
        'poison': 0.5,
        'flying': 0.5,
        'psychic': 0.5,
        'bug': 0.5,
        'rock': 2,
        'ghost': 0,
        'dark': 2,
        'steel': 2,
        'fairy': 0.5,
      },
      'poison': <String, double>{
        'grass': 2,
        'poison': 0.5,
        'ground': 0.5,
        'rock': 0.5,
        'ghost': 0.5,
        'steel': 0,
        'fairy': 2,
      },
      'ground': <String, double>{
        'fire': 2,
        'electric': 2,
        'grass': 0.5,
        'poison': 2,
        'flying': 0,
        'bug': 0.5,
        'rock': 2,
        'steel': 2,
      },
      'flying': <String, double>{
        'electric': 0.5,
        'grass': 2,
        'fighting': 2,
        'bug': 2,
        'rock': 0.5,
        'steel': 0.5,
      },
      'psychic': <String, double>{
        'fighting': 2,
        'poison': 2,
        'psychic': 0.5,
        'dark': 0,
        'steel': 0.5,
      },
      'bug': <String, double>{
        'fire': 0.5,
        'grass': 2,
        'fighting': 0.5,
        'poison': 0.5,
        'flying': 0.5,
        'psychic': 2,
        'ghost': 0.5,
        'dark': 2,
        'steel': 0.5,
        'fairy': 0.5,
      },
      'rock': <String, double>{
        'fire': 2,
        'ice': 2,
        'fighting': 0.5,
        'ground': 0.5,
        'flying': 2,
        'bug': 2,
        'steel': 0.5,
      },
      'ghost': <String, double>{
        'normal': 0,
        'psychic': 2,
        'ghost': 2,
        'dark': 0.5,
      },
      'dragon': <String, double>{'dragon': 2, 'steel': 0.5, 'fairy': 0},
      'dark': <String, double>{
        'fighting': 0.5,
        'psychic': 2,
        'ghost': 2,
        'dark': 0.5,
        'fairy': 0.5,
      },
      'steel': <String, double>{
        'fire': 0.5,
        'water': 0.5,
        'electric': 0.5,
        'ice': 2,
        'rock': 2,
        'fairy': 2,
        'steel': 0.5,
      },
      'fairy': <String, double>{
        'fire': 0.5,
        'fighting': 2,
        'poison': 0.5,
        'dragon': 2,
        'dark': 2,
        'steel': 0.5,
      },
    };

TypeEffectiveness getTypeEffectiveness(List<String> types) {
  Map<String, double> multipliers = <String, double>{
    for (final String type in kPokemonTypes) type: 1,
  };
  for (final String attack in kPokemonTypes) {
    for (final String defend in types) {
      double modifier = kTypeChart[attack]?[defend] ?? 1;
      multipliers[attack] = multipliers[attack]! * modifier;
    }
  }

  List<TypeMatchup> weaknesses = <TypeMatchup>[];
  List<TypeMatchup> resistances = <TypeMatchup>[];
  List<TypeMatchup> immunities = <TypeMatchup>[];

  multipliers.forEach((String type, double value) {
    if (value == 0) {
      immunities.add(TypeMatchup(type: type, multiplier: value));
    } else if (value > 1) {
      weaknesses.add(TypeMatchup(type: type, multiplier: value));
    } else if (value < 1) {
      resistances.add(TypeMatchup(type: type, multiplier: value));
    }
  });

  weaknesses.sort(
    (TypeMatchup a, TypeMatchup b) => b.multiplier.compareTo(a.multiplier),
  );
  resistances.sort(
    (TypeMatchup a, TypeMatchup b) => a.multiplier.compareTo(b.multiplier),
  );
  immunities.sort((TypeMatchup a, TypeMatchup b) => a.type.compareTo(b.type));

  return TypeEffectiveness(
    weaknesses: weaknesses,
    resistances: resistances,
    immunities: immunities,
  );
}
