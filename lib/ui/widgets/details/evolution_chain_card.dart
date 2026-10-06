part of com.pogo_check_list_ota_labs.app.widgets;

/// Línea evolutiva por etapas, con una fila por cada forma de origen cuando
/// las formas regionales evolucionan distinto (p. ej. Meowth normal, de Alola
/// y de Galar). Resalta la especie actual y abre el detalle de las demás al
/// tocarlas.
class EvolutionChainCard extends StatelessWidget {
  const EvolutionChainCard({
    required this.chain,
    required this.currentId,
    this.collection = const <PokemonModel>[],
    super.key,
  });

  final EvolutionNode chain;
  final int currentId;

  /// Especies registradas en Firebase, para el nombre de especies y formas.
  final List<PokemonModel> collection;

  @override
  Widget build(BuildContext context) {
    List<EvolutionForm> lines = chain.formRoots;
    return DetailCard(
      title: 'Línea evolutiva',
      icon: Icons.account_tree_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (int i = 0; i < lines.length; i++) ...<Widget>[
            if (i > 0) const Divider(color: Colors.white24, height: 24),
            if (lines.length > 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _formLabel(lines[i]) ?? 'Normal',
                  style: Paragraphs.disclaimerSemiBold.copyWith(
                    color: onPrimaryMuted,
                  ),
                ),
              ),
            // En pantallas angostas la línea se reduce en vez de desbordarse.
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: _EvolutionBranch(
                  node: lines[i],
                  memberBuilder:
                      (EvolutionForm node) => _EvolutionMember(
                        node: node,
                        isCurrent: node.id == currentId,
                        name: _entry(node.id)?.name ?? node.name,
                        formLabel: _formLabel(node),
                      ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  PokemonModel? _entry(int id) =>
      collection.firstWhereOrNull((PokemonModel p) => p.id == id);

  /// Registro en Firebase de la especie en la forma de [node].
  PokemonModel? _formEntry(EvolutionForm node) {
    PokemonModel? entry = _entry(node.id);
    if (node.form.isEmpty) return entry;
    return entry?.alternativeForms?.firstWhereOrNull(
      (PokemonModel form) => form.formTag?.id == node.form,
    );
  }

  /// Nombre de la forma (`Alola`) o `null` para la forma normal.
  String? _formLabel(EvolutionForm node) {
    if (node.form.isEmpty) return null;
    String? name = _formEntry(node)?.formTag?.name;
    if (name != null && name.isNotEmpty) return name;
    String label = node.form.replaceAll('_', ' ');
    return label[0].toUpperCase() + label.substring(1);
  }
}

/// Una especie seguida de sus evoluciones, cada una en su propia fila. Así
/// cada evolución queda junto a la forma de la que sale (solo Mr. Mime de
/// Galar evoluciona a Mr. Rime; Silcoon a Beautifly y Cascoon a Dustox).
class _EvolutionBranch extends StatelessWidget {
  const _EvolutionBranch({required this.node, required this.memberBuilder});

  final EvolutionForm node;
  final Widget Function(EvolutionForm node) memberBuilder;

  /// Evoluciones finales que caben apiladas (p. ej. los 3 de Tyrogue); con
  /// más (Eevee) se reparten en una cuadrícula de dos columnas.
  static const int _maxStackedBranches = 3;

  @override
  Widget build(BuildContext context) {
    List<EvolutionForm> children = node.evolvesTo;
    bool grid =
        children.length > _maxStackedBranches &&
        children.every((EvolutionForm child) => child.evolvesTo.isEmpty);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        memberBuilder(node),
        if (children.isNotEmpty) ...<Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              Icons.arrow_forward_ios,
              color: onPrimaryMuted,
              size: 16,
            ),
          ),
          if (grid)
            SizedBox(
              width: _EvolutionMember.width * 2 + 4,
              child: Wrap(
                spacing: 4,
                runSpacing: 8,
                children: children.map(memberBuilder).toList(),
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (int i = 0; i < children.length; i++) ...<Widget>[
                  if (i > 0) const SizedBox(height: 8),
                  _EvolutionBranch(
                    node: children[i],
                    memberBuilder: memberBuilder,
                  ),
                ],
              ],
            ),
        ],
      ],
    );
  }
}

class _EvolutionMember extends StatelessWidget {
  const _EvolutionMember({
    required this.node,
    required this.isCurrent,
    required this.name,
    this.formLabel,
  });

  static const double width = 72;

  final EvolutionForm node;
  final bool isCurrent;
  final String name;
  final String? formLabel;

  @override
  Widget build(BuildContext context) {
    String fullName = formLabel == null ? name : '$name ($formLabel)';
    return Semantics(
      button: !isCurrent,
      selected: isCurrent,
      label: fullName,
      excludeSemantics: true,
      child: GestureDetector(
        onTap:
            isCurrent
                ? null
                : () => CustomNavigator().push(
                  context,
                  DetailsScreen(pokemonId: node.id),
                  routeName: '${DetailsScreen.route}/${node.id}',
                  animation: CustomNavigationAnimation.fade,
                ),
        child: SizedBox(
          width: width,
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCurrent ? Colors.white24 : Colors.black12,
                  border:
                      isCurrent
                          ? Border.all(color: Colors.white, width: 2)
                          : null,
                ),
                child: _sprite(
                  node.form.isEmpty ? '${node.id}' : '${node.id}-${node.form}',
                  fallback: _sprite('${node.id}', fallback: _sprite('0')),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: (isCurrent
                        ? Paragraphs.disclaimerSemiBold
                        : Paragraphs.disclaimer)
                    .copyWith(color: Colors.white),
              ),
              Text(
                formLabel ?? paddingDexNumber(dexNumber: node.id),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Paragraphs.navigation.copyWith(color: onPrimaryMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Sprite local `assets/pokedex_sprites/<file>.png`; si falta, [fallback].
  static Widget _sprite(String file, {Widget? fallback}) => Image.asset(
    'assets/pokedex_sprites/$file.png',
    height: 52,
    width: 52,
    cacheHeight: 104,
    cacheWidth: 104,
    fit: BoxFit.contain,
    errorBuilder:
        fallback == null
            ? null
            : (BuildContext context, Object error, StackTrace? stackTrace) =>
                fallback,
  );
}
