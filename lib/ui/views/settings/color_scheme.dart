part of com.pogo_check_list_ota_labs.app.views;

class ColorSchemeView extends ConsumerWidget {
  const ColorSchemeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Esquema de colores'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: const WebContent(child: Center(child: ColorSchemeWidget())),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ref.read(themeModeProvider.notifier).themeMode =
                isDarkMode ? ThemeMode.light : ThemeMode.dark;
            showInformationSnackBar(
              context,
              '''[Tema actualizado] ->  ${isDarkMode ? 'Tema claro' : 'Tema oscuro'}''',
            );
          },
          backgroundColor: Theme.of(context).colorScheme.secondary,
          tooltip:
              isDarkMode ? 'Cambiar a modo claro' : 'Cambiar a modo oscuro',
          child: Icon(
            isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          ),
        ),
      ),
    );
  }
}

class ColorSchemeWidget extends StatelessWidget {
  const ColorSchemeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    List<Widget> colorSwatches = <Widget>[
      _ColorSwatch(
        name: 'Primary',
        swatchColor: colorScheme.primary,
        textColor: colorScheme.onPrimary,
      ),
      _ColorSwatch(
        name: 'On Primary',
        swatchColor: colorScheme.onPrimary,
        textColor: colorScheme.primary,
      ),
      _ColorSwatch(
        name: 'Primary Container',
        swatchColor: colorScheme.primaryContainer,
        textColor: colorScheme.onPrimaryContainer,
      ),
      _ColorSwatch(
        name: 'On Primary Container',
        swatchColor: colorScheme.onPrimaryContainer,
        textColor: colorScheme.primaryContainer,
      ),
      _ColorSwatch(
        name: 'Secondary',
        swatchColor: colorScheme.secondary,
        textColor: colorScheme.onSecondary,
      ),
      _ColorSwatch(
        name: 'On Secondary',
        swatchColor: colorScheme.onSecondary,
        textColor: colorScheme.secondary,
      ),
      _ColorSwatch(
        name: 'Secondary Container',
        swatchColor: colorScheme.secondaryContainer,
        textColor: colorScheme.onSecondaryContainer,
      ),
      _ColorSwatch(
        name: 'On Secondary Container',
        swatchColor: colorScheme.onSecondaryContainer,
        textColor: colorScheme.secondaryContainer,
      ),
      _ColorSwatch(
        name: 'Tertiary',
        swatchColor: colorScheme.tertiary,
        textColor: colorScheme.onTertiary,
      ),
      _ColorSwatch(
        name: 'On Tertiary',
        swatchColor: colorScheme.onTertiary,
        textColor: colorScheme.tertiary,
      ),
      _ColorSwatch(
        name: 'Tertiary Container',
        swatchColor: colorScheme.tertiaryContainer,
        textColor: colorScheme.onTertiaryContainer,
      ),
      _ColorSwatch(
        name: 'On Tertiary Container',
        swatchColor: colorScheme.onTertiaryContainer,
        textColor: colorScheme.tertiaryContainer,
      ),
      _ColorSwatch(
        name: 'Error',
        swatchColor: colorScheme.error,
        textColor: colorScheme.onError,
      ),
      _ColorSwatch(
        name: 'On Error',
        swatchColor: colorScheme.onError,
        textColor: colorScheme.error,
      ),
      _ColorSwatch(
        name: 'Error Container',
        swatchColor: colorScheme.errorContainer,
        textColor: colorScheme.onErrorContainer,
      ),
      _ColorSwatch(
        name: 'On Error Container',
        swatchColor: colorScheme.onErrorContainer,
        textColor: colorScheme.errorContainer,
      ),
      _ColorSwatch(
        name: 'Background',
        swatchColor: colorScheme.surface,
        textColor: colorScheme.onSurface,
      ),
      _ColorSwatch(
        name: 'On Background',
        swatchColor: colorScheme.onSurface,
        textColor: colorScheme.surface,
      ),
      _ColorSwatch(
        name: 'Surface',
        swatchColor: colorScheme.surface,
        textColor: colorScheme.onSurface,
      ),
      _ColorSwatch(
        name: 'On Surface',
        swatchColor: colorScheme.onSurface,
        textColor: colorScheme.surface,
      ),
      _ColorSwatch(
        name: 'Surface Variant',
        swatchColor: colorScheme.surfaceContainerHighest,
        textColor: colorScheme.onSurfaceVariant,
      ),
      _ColorSwatch(
        name: 'On Surface Variant',
        swatchColor: colorScheme.onSurfaceVariant,
        textColor: colorScheme.surfaceContainerHighest,
      ),
      _ColorSwatch(
        name: 'Outline',
        swatchColor: colorScheme.outline,
        textColor: colorScheme.inverseSurface,
      ),
      _ColorSwatch(
        name: 'Inverse Surface',
        swatchColor: colorScheme.inverseSurface,
        textColor: colorScheme.onInverseSurface,
      ),
      _ColorSwatch(
        name: 'On Inverse Surface',
        swatchColor: colorScheme.onInverseSurface,
        textColor: colorScheme.inverseSurface,
      ),
      _ColorSwatch(
        name: 'Inverse Primary',
        swatchColor: colorScheme.inversePrimary,
        textColor: colorScheme.primary,
      ),
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: colorSwatches,
          ),
        ],
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.name,
    required this.swatchColor,
    required this.textColor,
  });

  final String name;
  final Color swatchColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    String toHexString(Color color) =>
        '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
    return SizedBox(
      width: 110,
      height: 100,
      child: Card(
        color: swatchColor,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 0.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                name,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Text(
                toHexString(swatchColor),
                style: TextStyle(color: textColor, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
