part of com.pogo_check_list_ota_labs.app.utils;

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

const Map<String, Map<String, double>> kTypeChart =
    <String, Map<String, double>>{
      'normal': <String, double>{'roca': 0.5, 'fantasma': 0, 'acero': 0.5},
      'fuego': <String, double>{
        'fuego': 0.5,
        'agua': 0.5,
        'planta': 2,
        'hielo': 2,
        'insecto': 2,
        'roca': 0.5,
        'dragon': 0.5,
        'acero': 2,
      },
      'agua': <String, double>{
        'fuego': 2,
        'agua': 0.5,
        'planta': 0.5,
        'tierra': 2,
        'roca': 2,
        'dragon': 0.5,
      },
      'eléctrico': <String, double>{
        'agua': 2,
        'eléctrico': 0.5,
        'planta': 0.5,
        'tierra': 0,
        'volador': 2,
        'dragon': 0.5,
      },
      'planta': <String, double>{
        'fuego': 0.5,
        'agua': 2,
        'planta': 0.5,
        'veneno': 0.5,
        'tierra': 2,
        'volador': 0.5,
        'insecto': 0.5,
        'roca': 2,
        'dragon': 0.5,
        'acero': 0.5,
      },
      'hielo': <String, double>{
        'fuego': 0.5,
        'agua': 0.5,
        'planta': 2,
        'hielo': 0.5,
        'tierra': 2,
        'volador': 2,
        'dragon': 2,
        'acero': 0.5,
      },
      'pelea': <String, double>{
        'normal': 2,
        'hielo': 2,
        'veneno': 0.5,
        'volador': 0.5,
        'psíquico': 0.5,
        'insecto': 0.5,
        'roca': 2,
        'fantasma': 0,
        'siniestro': 2,
        'acero': 2,
        'hada': 0.5,
      },
      'veneno': <String, double>{
        'planta': 2,
        'veneno': 0.5,
        'tierra': 0.5,
        'roca': 0.5,
        'fantasma': 0.5,
        'acero': 0,
        'hada': 2,
      },
      'tierra': <String, double>{
        'fuego': 2,
        'eléctrico': 2,
        'planta': 0.5,
        'veneno': 2,
        'volador': 0,
        'insecto': 0.5,
        'roca': 2,
        'acero': 2,
      },
      'volador': <String, double>{
        'eléctrico': 0.5,
        'planta': 2,
        'pelea': 2,
        'insecto': 2,
        'roca': 0.5,
        'acero': 0.5,
      },
      'psíquico': <String, double>{
        'pelea': 2,
        'veneno': 2,
        'psíquico': 0.5,
        'siniestro': 0,
        'acero': 0.5,
      },
      'insecto': <String, double>{
        'fuego': 0.5,
        'planta': 2,
        'pelea': 0.5,
        'veneno': 0.5,
        'volador': 0.5,
        'psíquico': 2,
        'fantasma': 0.5,
        'siniestro': 2,
        'acero': 0.5,
        'hada': 0.5,
      },
      'roca': <String, double>{
        'fuego': 2,
        'hielo': 2,
        'pelea': 0.5,
        'tierra': 0.5,
        'volador': 2,
        'insecto': 2,
        'acero': 0.5,
      },
      'fantasma': <String, double>{
        'normal': 0,
        'psíquico': 2,
        'fantasma': 2,
        'siniestro': 0.5,
      },
      'dragon': <String, double>{'dragon': 2, 'acero': 0.5, 'hada': 0},
      'siniestro': <String, double>{
        'pelea': 0.5,
        'psíquico': 2,
        'fantasma': 2,
        'siniestro': 0.5,
        'hada': 0.5,
      },
      'acero': <String, double>{
        'fuego': 0.5,
        'agua': 0.5,
        'eléctrico': 0.5,
        'hielo': 2,
        'roca': 2,
        'hada': 2,
        'acero': 0.5,
      },
      'hada': <String, double>{
        'fuego': 0.5,
        'pelea': 2,
        'veneno': 0.5,
        'dragon': 2,
        'siniestro': 2,
        'acero': 0.5,
      },
    };

TypeEffectiveness getTypeEffectiveness(List<String> types) {
  Map<String, double> multipliers = <String, double>{
    for (final String type in kPokemonTypes) type: 1,
  };
  for (String attack in kPokemonTypes) {
    for (String defend in types) {
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
