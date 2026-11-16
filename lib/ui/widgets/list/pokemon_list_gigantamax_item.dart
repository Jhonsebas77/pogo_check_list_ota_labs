part of '../widgets.dart';

class PokemonListGigantamaxItem extends ConsumerWidget {
  const PokemonListGigantamaxItem({
    required this.selectPokemon,
    required this.index,
    this.isShiny = false,
    super.key,
  });

  final PokemonModel selectPokemon;
  final int index;
  final bool? isShiny;

  @override
  Widget build(BuildContext context, WidgetRef ref) => GestureDetector(
    onTap: selectPokemon.available
        ? () async {
            PokemonModel pokemon = selectPokemon.copyWith(
              alreadyCatch: !selectPokemon.alreadyCatch,
            );
            if (selectPokemon.isAlternativeForm) {
              await ref
                  .read(firebasePokemonProvider.notifier)
                  .updateGigantamaxPokemonForm(pokemon.id, pokemon, context);
            } else {
              await ref
                  .read(firebasePokemonProvider.notifier)
                  .updateGigantamaxPokemon(index, pokemon, context);
            }
            if (context.mounted) {
              showSuccessSnackBar(
                context,
                '''[Registro actualizado]\n${paddingDexNumber(dexNumber: selectPokemon.id)} ${selectPokemon.name}''',
              );
            }
          }
        : null,
    onLongPress: () {
      CustomNavigator().push(
        context,
        DetailsScreen(pokemonId: selectPokemon.id),
        routeName: '${DetailsScreen.route}/${selectPokemon.id}',
        animation: CustomNavigationAnimation.fade,
      );
    },
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: selectPokemon.alreadyCatch
            ? Theme.of(context).colorScheme.onSurface.withAlpha(100)
            : Theme.of(context).colorScheme.surfaceContainerHighest
                  .withAlpha(100),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(mainAxisAlignment: MainAxisAlignment.center),
    ),
  );
}
