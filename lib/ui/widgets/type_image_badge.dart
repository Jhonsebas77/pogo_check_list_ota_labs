part of com.pogo_check_list_ota_labs.app.widgets;

/// Muestra el banner del tipo usando `assets/types/<type>.png` (200x44).
/// Si la imagen no existe, cae al [TypeBadge] basado en color e icono.
class TypeImageBadge extends StatelessWidget {
  const TypeImageBadge({required this.type, this.height = 36, super.key});

  /// Nombre del tipo en inglés (`fire`, como lo entrega la API) o en español
  /// (`fuego`, como se usa en la tabla de tipos).
  final String type;
  final double height;

  static const double aspectRatio = 200 / 44;

  @override
  Widget build(BuildContext context) {
    String key = type.toLowerCase();
    String? englishType =
        kPokemonTypesTranslated.containsKey(key)
            ? key
            : kPokemonTypesTranslated.entries
                .where((MapEntry<String, String> e) => e.value == key)
                .map((MapEntry<String, String> e) => e.key)
                .firstOrNull;
    String translatedType = kPokemonTypesTranslated[englishType] ?? key;
    return Semantics(
      label: translatedType,
      image: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: Image.asset(
          'assets/types/${englishType ?? key}.png',
          height: height,
          width: height * aspectRatio,
          fit: BoxFit.contain,
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) =>
                  TypeBadge(
                    type: translatedType,
                    color: kTypeColors[translatedType] ?? Colors.grey,
                    icon: kTypeIcons[translatedType] ?? Icons.help_outline,
                  ),
        ),
      ),
    );
  }
}
