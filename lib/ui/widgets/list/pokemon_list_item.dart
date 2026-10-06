part of com.pogo_check_list_ota_labs.app.widgets;

class PokemonListItem extends ConsumerWidget {
  const PokemonListItem({
    required this.selectPokemon,
    required this.index,
    this.isShiny = false,
    this.isAlreadyCaught = false,
    this.isGigantamax = false,
    super.key,
  });

  final bool isGigantamax;
  final PokemonModel selectPokemon;
  final int index;
  final bool isShiny;
  final bool isAlreadyCaught;

  /// Etiqueta Hero única. Las formas base conservan el `id` (int) para mantener
  /// la animación hacia el detalle; las formas alternativas usan una etiqueta
  /// distinta para evitar colisiones cuando base y forma comparten `id`.
  Object get _heroTag =>
      selectPokemon.isAlternativeForm
          ? '${selectPokemon.id}${selectPokemon.formSuffix}'
          : selectPokemon.id;

  /// Nombre con la forma, si la tiene: `Meowth (Galar)`.
  String get _displayName =>
      selectPokemon.isAlternativeForm
          ? '${selectPokemon.name} (${selectPokemon.formTag!.name})'
          : selectPokemon.name;

  /// `errorBuilder` que cae al sprite [fallbackAsset] de la especie base cuando
  /// falta el PNG de la forma alternativa.
  ImageErrorWidgetBuilder _spriteFallback(String fallbackAsset) =>
      (BuildContext context, Object error, StackTrace? stackTrace) =>
          Image.asset(
            fallbackAsset,
            height: 50,
            width: 50,
            cacheHeight: 100,
            cacheWidth: 100,
            fit: BoxFit.fill,
          );

  @override
  Widget build(BuildContext context, WidgetRef ref) => GestureDetector(
    onTap: () {
      CustomNavigator().push(
        context,
        DetailsScreen(pokemonId: index, title: _displayName),
        routeName: '${DetailsScreen.route}/$index',
        animation: CustomNavigationAnimation.fade,
      );
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8, right: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Image.asset(
                        'assets/bg_holder_pokemon.png',
                        height: 50,
                        width: 50,
                        fit: BoxFit.fill,
                      ),
                      if (isGigantamax)
                        Image.asset(
                          'assets/pokedex_gigantamax/${selectPokemon.id}.png',
                          height: 50,
                          width: 50,
                          cacheHeight: 100,
                          cacheWidth: 100,
                          fit: BoxFit.fill,
                        )
                      else if (isShiny)
                        if (selectPokemon.shinyAvailable == false)
                          Image.asset(
                            'assets/pokedex_sprites_shiny/0.png',
                            height: 50,
                            width: 50,
                            cacheHeight: 100,
                            cacheWidth: 100,
                            fit: BoxFit.fill,
                          )
                        else
                          Hero(
                            tag: _heroTag,
                            child: Image.asset(
                              'assets/pokedex_sprites_shiny/${selectPokemon.id}${selectPokemon.formSuffix}.png',
                              height: 50,
                              width: 50,
                              cacheHeight: 100,
                              cacheWidth: 100,
                              fit: BoxFit.fill,
                              errorBuilder: _spriteFallback(
                                'assets/pokedex_sprites_shiny/${selectPokemon.id}.png',
                              ),
                            ),
                          )
                      else if (!isShiny)
                        if (selectPokemon.available == false)
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Image.asset(
                              'assets/pokedex_sprites/${selectPokemon.id}${selectPokemon.formSuffix}.png',
                              height: 50,
                              width: 50,
                              cacheHeight: 100,
                              cacheWidth: 100,
                              fit: BoxFit.fill,
                              errorBuilder: _spriteFallback(
                                'assets/pokedex_sprites/${selectPokemon.id}.png',
                              ),
                            ),
                          )
                        else
                          Hero(
                            tag: _heroTag,
                            child: Image.asset(
                              'assets/pokedex_sprites/${selectPokemon.id}${selectPokemon.formSuffix}.png',
                              height: 50,
                              width: 50,
                              cacheHeight: 100,
                              cacheWidth: 100,
                              fit: BoxFit.fill,
                              errorBuilder: _spriteFallback(
                                'assets/pokedex_sprites/${selectPokemon.id}.png',
                              ),
                            ),
                          ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          paddingDexNumber(dexNumber: selectPokemon.id),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          _displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (selectPokemon.available)
              GestureDetector(
                onTap:
                    selectPokemon.available
                        ? () async {
                          if (index == selectPokemon.id) {
                            // copyWith preserva alternativeForm/alternativeForms
                            // (evita la pérdida de datos del toggle anterior).
                            PokemonModel _pokemon = selectPokemon.copyWith(
                              alreadyCatch:
                                  isShiny
                                      ? selectPokemon.alreadyCatch
                                      : !selectPokemon.alreadyCatch,
                              alreadyCatchShinyVersion:
                                  isShiny
                                      ? !selectPokemon.alreadyCatchShinyVersion
                                      : selectPokemon.alreadyCatchShinyVersion,
                            );
                            if (selectPokemon.isAlternativeForm) {
                              await ref
                                  .read(firebasePokemonProvider.notifier)
                                  .updatePokemonForm(
                                    _pokemon.id,
                                    _pokemon,
                                    context,
                                  );
                            } else {
                              await ref
                                  .read(firebasePokemonProvider.notifier)
                                  .updatePokemon(
                                    _pokemon.id,
                                    _pokemon,
                                    context,
                                  );
                            }
                            if (context.mounted) {
                              showSuccessSnackBar(
                                context,
                                '''[Registro actualizado]\n${paddingDexNumber(dexNumber: selectPokemon.id)} ${selectPokemon.name}''',
                              );
                            }
                          } else {
                            showErrorSnackBar(
                              context,
                              '''[Error actualizando el registro] -> $index != ${selectPokemon.id}''',
                            );
                          }
                        }
                        : null,
                child: Row(
                  children: <Widget>[
                    if (!selectPokemon.tradable)
                      const Stack(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Color(0xFFA0E1FF),
                            child: Icon(
                              Icons.wifi_protected_setup_sharp,
                              color: onLightAccent,
                            ),
                          ),
                          Icon(Icons.block, color: Colors.red, size: 40),
                        ],
                      ),
                    if (!selectPokemon.shinyAvailable)
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Stack(
                          children: <Widget>[
                            Image.asset(
                              'assets/icon_shiny.png',
                              height: 40,
                              width: 40,
                            ),
                            const Icon(
                              Icons.block,
                              color: Colors.red,
                              size: 40,
                            ),
                          ],
                        ),
                      ),
                    if (isShiny
                        ? selectPokemon.alreadyCatchShinyVersion
                        : selectPokemon.alreadyCatch)
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: <Widget>[
                          Icon(
                            Icons.catching_pokemon,
                            color: Theme.of(context).colorScheme.inverseSurface,
                            size: 50,
                          ),
                          const Icon(
                            Icons.check_circle,
                            color: Colors.lightGreen,
                            size: 30,
                          ),
                        ],
                      )
                    else if (selectPokemon.available)
                      Icon(
                        Icons.catching_pokemon,
                        color: Theme.of(context).colorScheme.inverseSurface,
                        size: 50,
                      ),
                  ],
                ),
              )
            else
              const Stack(
                alignment: AlignmentDirectional.topEnd,
                children: <Widget>[
                  Icon(
                    Icons.catching_pokemon,
                    color: Colors.blueGrey,
                    size: 50,
                  ),
                  Icon(Icons.block, color: Colors.red, size: 30),
                ],
              ),
          ],
        ),
      ),
    ),
  );
}
